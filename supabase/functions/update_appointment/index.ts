import { serve } from "https://deno.land/std/http/server.ts";
import * as jose from "npm:jose";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
  "Content-Type": "application/json",
};

// DB truth: 1 pending, 2 confirmed, 3 completed, 4 cancelled.
const STATUS_TEXT: Record<number, { body: string; type: string }> = {
  1: { body: "موعدك قيد الانتظار", type: "appointment" },
  2: { body: "تم قبول موعدك بنجاح ✅", type: "appointment" },
  3: { body: "تم إتمام موعدك ✅", type: "result" },
  4: { body: "تم إلغاء موعدك ❌", type: "cancellation" },
};

async function getAuthenticatedUserId(
  req: Request,
  supabaseUrl: string,
  serviceRoleKey: string,
): Promise<string | null> {
  const authorization = req.headers.get("Authorization");
  if (!authorization) return null;
  const response = await fetch(`${supabaseUrl}/auth/v1/user`, {
    headers: {
      apikey: Deno.env.get("SUPABASE_ANON_KEY") ?? serviceRoleKey,
      Authorization: authorization,
    },
  });
  if (!response.ok) return null;
  const user = await response.json();
  return typeof user?.id === "string" ? user.id : null;
}

async function getAccessToken(): Promise<string> {
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
  if (!data.access_token) throw new Error(JSON.stringify(data));
  return data.access_token;
}

async function sendFcmToUser(
  supabaseUrl: string,
  supabaseKey: string,
  projectId: string,
  accessToken: string,
  userId: string,
  title: string,
  body: string,
  notificationType: string,
  customData: Record<string, string>
) {
  const rest = {
    "Content-Type": "application/json",
    apikey: supabaseKey,
    Authorization: `Bearer ${supabaseKey}`,
  };

  // 1. Save in inbox
  let notificationId: number | null = null;
  try {
    const insertRes = await fetch(`${supabaseUrl}/rest/v1/notifications`, {
      method: "POST",
      headers: { ...rest, Prefer: "return=representation" },
      body: JSON.stringify({
        user_id: userId,
        clinic_id: customData.clinic_id ?? null,
        title,
        message: body,
        type: notificationType,
        data: customData,
      }),
    });
    if (insertRes.ok) {
      notificationId = (await insertRes.json())?.[0]?.id ?? null;
    }
  } catch (e) {
    console.error("Error saving notification:", e);
  }

  // 2. Fetch device tokens
  try {
    const [devicesRes, userRes] = await Promise.all([
      fetch(
        `${supabaseUrl}/rest/v1/user_devices?user_id=eq.${userId}&is_active=eq.true&select=fcm_token`,
        { headers: rest }
      ),
      fetch(
        `${supabaseUrl}/rest/v1/users?user_id=eq.${userId}&select=fcm_token`,
        { headers: rest }
      ),
    ]);

    const devices = devicesRes.ok ? await devicesRes.json() : [];
    const user = userRes.ok ? (await userRes.json())?.[0] : null;

    const tokens = [
      ...new Set([
        ...(Array.isArray(devices)
          ? devices.map((d: { fcm_token?: string | null }) => d.fcm_token)
          : []),
        user?.fcm_token,
      ].filter(
        (token): token is string =>
          typeof token === "string" && token.trim().length > 0
      )),
    ];

    if (tokens.length > 0) {
      await Promise.all(
        tokens.map((token) =>
          fetch(
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
                  notification: { title, body },
                  android: {
                    priority: "high",
                    notification: { title, body, default_sound: true },
                  },
                  apns: {
                    payload: {
                      aps: { alert: { title, body }, sound: "default" },
                    },
                  },
                  data: {
                    ...customData,
                    notification_id:
                      notificationId != null ? String(notificationId) : "",
                  },
                },
              }),
            }
          ).catch((e) => console.error("FCM send error:", e))
        )
      );
    }
  } catch (err) {
    console.error("Error sending push notification:", err);
  }
}

serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }
  try {
    const { appointment_id, clinic_id, status } = await req.json();

    if (appointment_id == null || clinic_id == null || status == null) {
      return new Response(
        JSON.stringify({
          success: false,
          error: "appointment_id, clinic_id, and status are required",
        }),
        { status: 400, headers: corsHeaders }
      );
    }
    if (![1, 2, 3, 4].includes(status)) {
      return new Response(
        JSON.stringify({ success: false, error: "Invalid status (1-4 only)" }),
        { status: 400, headers: corsHeaders }
      );
    }

    const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
    const supabaseKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
    const projectId = Deno.env.get("FIREBASE_PROJECT_ID")!;
    const rest = {
      "Content-Type": "application/json",
      apikey: supabaseKey,
      Authorization: `Bearer ${supabaseKey}`,
    };
    const authenticatedUserId = await getAuthenticatedUserId(
      req,
      supabaseUrl,
      supabaseKey,
    );
    if (!authenticatedUserId) {
      return new Response(
        JSON.stringify({ success: false, error: "Authentication required" }),
        { status: 401, headers: corsHeaders },
      );
    }

    // 1. Get appointment
    const apptRes = await fetch(
      `${supabaseUrl}/rest/v1/appointments?id=eq.${appointment_id}&clinic_id=eq.${clinic_id}&select=*`,
      { headers: rest }
    );
    const appointment = (await apptRes.json())?.[0];
    if (!appointment) {
      return new Response(
        JSON.stringify({ success: false, error: "Appointment not found" }),
        { status: 404, headers: corsHeaders }
      );
    }
    if (appointment.doctor_id !== authenticatedUserId) {
      return new Response(
        JSON.stringify({ success: false, error: "Appointment not owned by doctor" }),
        { status: 403, headers: corsHeaders },
      );
    }

    // 2. Update appointment status
    const updateRes = await fetch(
      `${supabaseUrl}/rest/v1/appointments?id=eq.${appointment_id}&clinic_id=eq.${clinic_id}`,
      {
        method: "PATCH",
        headers: { ...rest, Prefer: "return=representation" },
        body: JSON.stringify({ status }),
      }
    );
    if (!updateRes.ok) {
      const err = await updateRes.text();
      return new Response(
        JSON.stringify({ success: false, error: `Update failed: ${err}` }),
        { status: 500, headers: corsHeaders }
      );
    }
    const updated = (await updateRes.json())?.[0];

    // Fetch doctor name
    let doctorName = "الطبيب";
    if (appointment.doctor_id) {
      try {
        const docRes = await fetch(
          `${supabaseUrl}/rest/v1/doctors?doctor_id=eq.${appointment.doctor_id}&select=name`,
          { headers: rest }
        );
        const docData = await docRes.json();
        if (docData?.[0]?.name) {
          doctorName = docData[0].name;
        }
      } catch (_) {}
    }

    let accessToken = "";
    try {
      accessToken = await getAccessToken();
    } catch (e) {
      console.error("Access token error:", e);
    }

    // 3. Notify the appointment owner about their status update
    if (appointment.user_id && accessToken) {
      const meta = STATUS_TEXT[status];
      await sendFcmToUser(
        supabaseUrl,
        supabaseKey,
        projectId,
        accessToken,
        appointment.user_id,
        "تحديث الموعد",
        meta.body,
        meta.type,
        {
          appointment_id: String(appointment_id),
          clinic_id: String(clinic_id),
          status: String(status),
        }
      );
    }

    // 4. If status is Completed (3) or Cancelled (4), advance the queue & notify the NEXT patient (waiting_list = 0)
    let nextPatientData = null;
    if ((status === 3 || status === 4) && appointment.doctor_id && appointment.appointment_date) {
      try {
        const advRes = await fetch(
          `${supabaseUrl}/rest/v1/rpc/advance_queue_and_get_next`,
          {
            method: "POST",
            headers: rest,
            body: JSON.stringify({
              p_doctor_id: appointment.doctor_id,
              p_appointment_date: appointment.appointment_date,
              p_clinic_id: clinic_id,
            }),
          }
        );
        nextPatientData = await advRes.json();

        const nextUserId = nextPatientData?.next_user_id;
        const nextApptId = nextPatientData?.next_appointment_id;

        // If a next registered patient is now at the front of the queue, notify them!
        if (nextUserId && nextUserId !== appointment.user_id && accessToken) {
          const nextTitle = "🔔 حان دورك الآن!";
          const nextBody = `أنت الآن المريض التالي في قائمة الانتظار مع دكتور ${doctorName}. يرجى التوجه لغرفة الكشف.`;

          await sendFcmToUser(
            supabaseUrl,
            supabaseKey,
            projectId,
            accessToken,
            nextUserId,
            nextTitle,
            nextBody,
            "your_turn",
            {
              appointment_id: String(nextApptId),
              clinic_id: String(clinic_id),
              waiting_list: "0",
              type: "your_turn",
            }
          );
        }
      } catch (err) {
        console.error("Error advancing queue or notifying next patient:", err);
      }
    }

    return new Response(
      JSON.stringify({
        success: true,
        data: {
          appointment: updated,
          next_patient: nextPatientData,
        },
        message: "Updated successfully",
      }),
      { status: 200, headers: corsHeaders }
    );
  } catch (err: any) {
    return new Response(
      JSON.stringify({ success: false, error: err?.message ?? String(err) }),
      { status: 500, headers: corsHeaders }
    );
  }
});
