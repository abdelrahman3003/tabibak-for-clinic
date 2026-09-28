import { serve } from "https://deno.land/std/http/server.ts";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const body = await req.json();
    const { doctor_id } = body;

    if (!doctor_id) {
      return new Response(
        JSON.stringify({
          success: false,
          error: "doctor_id is required",
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

    const headers = {
      apikey: supabaseKey,
      Authorization: `Bearer ${supabaseKey}`,
      "Content-Type": "application/json",
    };

    // 1. Approve doctor (status = 2 -> Approved, is_registered = true)
    const updateRes = await fetch(
      `${supabaseUrl}/rest/v1/doctors?doctor_id=eq.${doctor_id}`,
      {
        method: "PATCH",
        headers: {
          ...headers,
          Prefer: "return=representation",
        },
        body: JSON.stringify({
          status: 2,
          is_registered: true,
        }),
      }
    );

    const updatedDoctorList = await updateRes.json();
    const updatedDoctor = updatedDoctorList?.[0];

    if (!updatedDoctor) {
      return new Response(
        JSON.stringify({
          success: false,
          error: "Doctor not found",
        }),
        {
          status: 404,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        }
      );
    }

    // 2. Get doctor info
    const doctorName = updatedDoctor.name || "دكتور";

    // 3. Obtain Firebase Access Token
    const accessToken = await getAccessToken();

    // 4. Send Approval Notification to the DOCTOR
    const doctorNotificationTitle = "🎉 تم اعتماد حسابك بنجاح";
    const doctorNotificationBody = `دكتور ${doctorName}، تم قبول واعتماد حسابك في تطبيق طبيبك. يمكنك الآن إدارة عيادتك واستقبال الحجوزات.`;

    // 4a. Persist notification in DB for Doctor
    try {
      await fetch(`${supabaseUrl}/rest/v1/notifications`, {
        method: "POST",
        headers: { ...headers, Prefer: "return=representation" },
        body: JSON.stringify({
          user_id: doctor_id,
          title: doctorNotificationTitle,
          message: doctorNotificationBody,
          type: "general",
          data: {
            type: "doctor_approved",
            doctor_id: String(doctor_id),
          },
        }),
      });
    } catch (e) {
      console.error("Error inserting notification for doctor:", e);
    }

    // 4b. Find doctor's device tokens from user_devices and doctors table
    const doctorDevicesRes = await fetch(
      `${supabaseUrl}/rest/v1/user_devices?user_id=eq.${doctor_id}&is_active=eq.true&select=fcm_token`,
      { headers }
    );
    const doctorDevices = doctorDevicesRes.ok ? await doctorDevicesRes.json() : [];

    const doctorTokens = [
      ...new Set([
        ...(Array.isArray(doctorDevices)
          ? doctorDevices.map((d: { fcm_token?: string | null }) => d.fcm_token)
          : []),
        updatedDoctor.fcm_token,
      ].filter((token): token is string => typeof token === "string" && token.trim().length > 0)),
    ];

    let doctorPushSent = 0;
    for (const token of doctorTokens) {
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
                notification: {
                  title: doctorNotificationTitle,
                  body: doctorNotificationBody,
                },
                data: {
                  type: "doctor_approved",
                  doctor_id: String(doctor_id),
                },
                android: { priority: "high" },
                apns: { payload: { aps: { sound: "default" } } },
              },
            }),
          }
        );
        if (pushRes.ok) doctorPushSent++;
      } catch (e) {
        console.error("Error sending push to doctor token:", token, e);
      }
    }

    // 5. Broadcast to patients in same city/markaz (Optional: if clinic address exists)
    let usersNotifiedCount = 0;
    try {
      const addressRes = await fetch(
        `${supabaseUrl}/rest/v1/clinic_address?select=city_id,markaz_id,governorate_id,clinic_data!inner(doctor_id)&clinic_data.doctor_id=eq.${doctor_id}`,
        { headers }
      );
      const clinicAddresses = addressRes.ok ? await addressRes.json() : [];
      const clinicAddress = clinicAddresses?.[0];

      if (clinicAddress) {
        const markazId = clinicAddress.markaz_id || clinicAddress.city_id;
        const governorateId = clinicAddress.governorate_id;

        let query = `${supabaseUrl}/rest/v1/users?select=fcm_token`;
        if (markazId) {
          query += `&or=(district_id.eq.${markazId},city_id.eq.${markazId})`;
        } else if (governorateId) {
          query += `&governorate_id=eq.${governorateId}`;
        }

        const usersRes = await fetch(query, { headers });
        const users = usersRes.ok ? await usersRes.json() : [];

        for (const user of users) {
          if (!user.fcm_token) continue;
          try {
            const fcmRes = await fetch(
              `https://fcm.googleapis.com/v1/projects/${projectId}/messages:send`,
              {
                method: "POST",
                headers: {
                  "Content-Type": "application/json",
                  Authorization: `Bearer ${accessToken}`,
                },
                body: JSON.stringify({
                  message: {
                    token: user.fcm_token,
                    notification: {
                      title: "🩺 طبيب جديد",
                      body: `تم انضمام الدكتور ${doctorName} في منطقتك ويمكنك حجز موعد الآن.`,
                    },
                    data: {
                      type: "new_doctor",
                      doctor_id: String(doctor_id),
                    },
                  },
                }),
              }
            );
            if (fcmRes.ok) usersNotifiedCount++;
          } catch (e) {
            console.error("Error sending user notification:", e);
          }
        }
      }
    } catch (e) {
      console.error("Optional patient broadcast error:", e);
    }

    return new Response(
      JSON.stringify({
        success: true,
        message: "Doctor approved and notification sent successfully",
        doctor: updatedDoctor,
        doctor_push_sent: doctorPushSent > 0,
        doctor_tokens_targeted: doctorTokens.length,
        patients_notified: usersNotifiedCount,
      }),
      {
        status: 200,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      }
    );
  } catch (err: any) {
    return new Response(
      JSON.stringify({
        success: false,
        error: err?.message ?? String(err),
      }),
      {
        status: 500,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      }
    );
  }
});

/* =========================
   🔐 Firebase Access Token
========================= */

async function getAccessToken(): Promise<string> {
  const serviceAccount = JSON.parse(
    Deno.env.get("FIREBASE_SERVICE_ACCOUNT")!
  );

  const privateKey = serviceAccount.private_key.replace(/\\n/g, "\n");

  const key = await crypto.subtle.importKey(
    "pkcs8",
    pemToArrayBuffer(privateKey),
    {
      name: "RSASSA-PKCS1-v1_5",
      hash: "SHA-256",
    },
    false,
    ["sign"]
  );

  const encode = (obj: object) =>
    btoa(JSON.stringify(obj))
      .replace(/=/g, "")
      .replace(/\+/g, "-")
      .replace(/\//g, "_");

  const now = Math.floor(Date.now() / 1000);

  const header = {
    alg: "RS256",
    typ: "JWT",
  };

  const payload = {
    iss: serviceAccount.client_email,
    scope: "https://www.googleapis.com/auth/firebase.messaging",
    aud: "https://oauth2.googleapis.com/token",
    iat: now,
    exp: now + 3600,
  };

  const unsigned = `${encode(header)}.${encode(payload)}`;

  const signature = await crypto.subtle.sign(
    "RSASSA-PKCS1-v1_5",
    key,
    new TextEncoder().encode(unsigned)
  );

  const jwt =
    unsigned +
    "." +
    btoa(String.fromCharCode(...new Uint8Array(signature)))
      .replace(/=/g, "")
      .replace(/\+/g, "-")
      .replace(/\//g, "_");

  const res = await fetch("https://oauth2.googleapis.com/token", {
    method: "POST",
    headers: {
      "Content-Type": "application/x-www-form-urlencoded",
    },
    body: new URLSearchParams({
      grant_type: "urn:ietf:params:oauth:grant-type:jwt-bearer",
      assertion: jwt,
    }),
  });

  const data = await res.json();

  if (!data.access_token) {
    throw new Error(JSON.stringify(data));
  }

  return data.access_token;
}

/* =========================
   🔑 PEM Helper
========================= */

function pemToArrayBuffer(pem: string) {
  const b64 = pem
    .replace("-----BEGIN PRIVATE KEY-----", "")
    .replace("-----END PRIVATE KEY-----", "")
    .replace(/\s/g, "");

  const binary = atob(b64);
  const bytes = new Uint8Array(binary.length);

  for (let i = 0; i < binary.length; i++) {
    bytes[i] = binary.charCodeAt(i);
  }

  return bytes.buffer;
}
