import { serve } from "https://deno.land/std/http/server.ts";
import * as jose from "npm:jose";

// =========================
// STATUS CODES
// =========================
// 1 = new booking (waiting)
// 2 = confirmed     (waiting)
// 3 = completed     (removed from queue)
// 4 = cancelled     (removed from queue)
const ACTIVE_STATUSES = [1, 2];

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

function sbHeaders(key: string) {
  return {
    "Content-Type": "application/json",
    apikey: key,
    Authorization: `Bearer ${key}`,
  };
}

// Recomputes waiting_list for every active appointment for the same
// doctor on the same day (morning + evening shifts share ONE queue),
// and writes it back to each row.
// Returns the ordered active list (index 0 = next patient).
async function recalculateWaitingList(
  supabaseUrl: string,
  supabaseKey: string,
  doctor_id: string | number,
  appointment_date: string
) {
  const statusFilter = `status=in.(${ACTIVE_STATUSES.join(",")})`;
  const url =
    `${supabaseUrl}/rest/v1/appointments?doctor_id=eq.${doctor_id}` +
    `&appointment_date=eq.${appointment_date}` +
    `&${statusFilter}` +
    `&select=id,created_at,name` +
    `&order=created_at.asc,id.asc`;

  const res = await fetch(url, { headers: sbHeaders(supabaseKey) });
  if (!res.ok) return [];
  const activeList = await res.json();

  // patients ahead = position in the ordered list (0 = you're next)
  await Promise.all(
    activeList.map(async (row: any, index: number) => {
      const patchRes = await fetch(`${supabaseUrl}/rest/v1/appointments?id=eq.${row.id}`, {
        method: "PATCH",
        headers: sbHeaders(supabaseKey),
        body: JSON.stringify({ waiting_list: index }),
      });
      if (!patchRes.ok) {
        console.log("WAITING_LIST PATCH FAILED for id", row.id, await patchRes.text());
      }
    })
  );

  return activeList;
}

// =========================
// GET FIREBASE ACCESS TOKEN
// =========================
async function getAccessToken() {
  const serviceAccount = JSON.parse(
    Deno.env.get("FIREBASE_SERVICE_ACCOUNT")!
  );
  const privateKey = serviceAccount.private_key.replace(/\\n/g, "\n");
  const key = await jose.importPKCS8(privateKey, "RS256");

  const jwt = await new jose.SignJWT({
    iss: serviceAccount.client_email,
    scope: "https://www.googleapis.com/auth/firebase.messaging",
    aud: "https://oauth2.googleapis.com/token",
  })
    .setProtectedHeader({ alg: "RS256", typ: "JWT" })
    .setIssuedAt()
    .setExpirationTime("1h")
    .sign(key);

  const res = await fetch("https://oauth2.googleapis.com/token", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      grant_type: "urn:ietf:params:oauth:grant-type:jwt-bearer",
      assertion: jwt,
    }),
  });

  const data = await res.json();
  return data.access_token;
}

// =========================
// MAIN HANDLER
// =========================
serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const {
      appointment_date,
      doctor_id,
      user_id,
      status = 2,
      phone,
      name,
      description,
      shift_morning_id,
      shift_evening_id,
    } = await req.json();

    if (!doctor_id || !name || !appointment_date) {
      return new Response(
        JSON.stringify({
          success: false,
          error: "doctor_id, name, and appointment_date are required",
        }),
        {
          status: 400,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        }
      );
    }

    const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
    const supabaseKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
    const projectId = Deno.env.get("FIREBASE_PROJECT_ID")!;

    // Sanitize user_id: check if it exists in users table (only registered patients exist in users table)
    let validUserId: string | null = null;
    if (user_id && user_id !== doctor_id) {
      const checkUserRes = await fetch(
        `${supabaseUrl}/rest/v1/users?user_id=eq.${user_id}&select=user_id`,
        { headers: sbHeaders(supabaseKey) }
      );
      const users = checkUserRes.ok ? await checkUserRes.json() : [];
      if (users.length > 0) {
        validUserId = user_id;
      }
    }

    // =========================
    // 1. INSERT APPOINTMENT
    // =========================
    const insertRes = await fetch(`${supabaseUrl}/rest/v1/appointments`, {
      method: "POST",
      headers: { ...sbHeaders(supabaseKey), Prefer: "return=representation" },
      body: JSON.stringify({
        appointment_date,
        doctor_id,
        user_id: validUserId,
        status,
        phone,
        name,
        description,
        appointment_morning_shift_id: shift_morning_id ?? null,
        appointment_evening_shift_id: shift_evening_id ?? null,
      }),
    });

    const inserted = await insertRes.json();

    if (!insertRes.ok) {
      return new Response(
        JSON.stringify({ success: false, stage: "database", error: inserted }),
        { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    const appointmentRow = Array.isArray(inserted) ? inserted[0] : inserted;
    const appointmentId = appointmentRow?.id;

    // =========================
    // 2. RECALCULATE waiting_list for the whole day's queue
    // =========================
    const activeList = await recalculateWaitingList(
      supabaseUrl,
      supabaseKey,
      doctor_id,
      appointment_date
    );

    const myIndex = activeList.findIndex((r: any) => r.id === appointmentId);
    const myWaitingList = myIndex >= 0 ? myIndex : activeList.length - 1; // patients ahead
    const totalWaiting = activeList.length;

    // =========================
    // 3. GET DOCTOR NAME (for patient notification)
    // =========================
    let doctorName = "الطبيب";
    try {
      const docRes = await fetch(
        `${supabaseUrl}/rest/v1/doctors?doctor_id=eq.${doctor_id}&select=name`,
        { headers: sbHeaders(supabaseKey) }
      );
      const docData = await docRes.json();
      if (docData?.[0]?.name) {
        doctorName = docData[0].name;
      }
    } catch (_) {
      // ignore
    }

    // =========================
    // 4. NOTIFICATION LOGIC:
    // When clinic creates appointment:
    // - NO notification to clinic/doctor (they created it themselves).
    // - IF valid patient user_id exists: send notification to the patient.
    // =========================
    let patient_notification_sent = false;
    let patient_notification_saved = false;

    if (validUserId) {
      const patientTitle = "✅ تأكيد الموعد";
      const patientBody = `تم تأكيد موعدك مع دكتور ${doctorName} بتاريخ ${appointment_date}. رقم انتظارك: ${myWaitingList + 1}`;

      // Persist notification for patient
      try {
        const notifRes = await fetch(`${supabaseUrl}/rest/v1/notifications`, {
          method: "POST",
          headers: { ...sbHeaders(supabaseKey), Prefer: "return=representation" },
          body: JSON.stringify({
            user_id: validUserId,
            title: patientTitle,
            message: patientBody,
            type: "appointment",
            data: {
              appointment_id: String(appointmentId),
              status: String(status),
              waiting_list: String(myWaitingList),
            },
          }),
        });
        if (notifRes.ok) patient_notification_saved = true;
      } catch (e) {
        console.error("Error saving notification for patient:", e);
      }

      // Fetch patient's device tokens
      const patientDevicesRes = await fetch(
        `${supabaseUrl}/rest/v1/user_devices?user_id=eq.${validUserId}&is_active=eq.true&select=fcm_token`,
        { headers: sbHeaders(supabaseKey) }
      );
      const patientDevices = patientDevicesRes.ok ? await patientDevicesRes.json() : [];

      const patientUserRes = await fetch(
        `${supabaseUrl}/rest/v1/users?user_id=eq.${validUserId}&select=fcm_token`,
        { headers: sbHeaders(supabaseKey) }
      );
      const patientUser = patientUserRes.ok ? (await patientUserRes.json())?.[0] : null;

      const patientTokens = [
        ...new Set([
          ...(Array.isArray(patientDevices)
            ? patientDevices.map((d: { fcm_token?: string | null }) => d.fcm_token)
            : []),
          patientUser?.fcm_token,
        ].filter((token): token is string => typeof token === "string" && token.trim().length > 0)),
      ];

      if (patientTokens.length > 0) {
        try {
          const accessToken = await getAccessToken();
          for (const token of patientTokens) {
            try {
              const pushRes = await fetch(
                `https://fcm.googleapis.com/v1/projects/${projectId}/messages:send`,
                {
                  method: "POST",
                  headers: {
                    "Content-Type": "application/json",
                    Authorization: `Bearer ${accessToken}`,
                  },
                  body: JSON.stringify({
                    message: {
                      token,
                      notification: { title: patientTitle, body: patientBody },
                      android: { notification: { title: patientTitle, body: patientBody, default_sound: true } },
                      apns: {
                        payload: { aps: { alert: { title: patientTitle, body: patientBody }, sound: "default" } },
                      },
                      data: {
                        appointment_id: String(appointmentId),
                        status: String(status),
                        waiting_list: String(myWaitingList),
                        patients_waiting: String(totalWaiting),
                      },
                    },
                  }),
                }
              );
              if (pushRes.ok) patient_notification_sent = true;
            } catch (err) {
              console.error("Error sending push to patient:", err);
            }
          }
        } catch (e) {
          console.error("FCM Access Token error:", e);
        }
      }
    }

    return new Response(
      JSON.stringify({
        success: true,
        data: {
          appointment: { ...appointmentRow, waiting_list: myWaitingList },
          patients_waiting_total: totalWaiting,
          patient_notification_sent,
          patient_notification_saved,
        },
      }),
      { status: 200, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  } catch (err: any) {
    return new Response(
      JSON.stringify({ success: false, error: err?.message ?? String(err) }),
      { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  }
});
