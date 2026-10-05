import { serve } from "https://deno.land/std@0.224.0/http/mod.ts";
import * as jose from "npm:jose";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
  "Content-Type": "application/json",
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
    const { appointment_id, clinic_id, positions } = await req.json();

    if (!appointment_id || clinic_id == null || !positions) {
      return new Response(
        JSON.stringify({
          success: false,
          error: "appointment_id, clinic_id, and positions are required",
        }),
        { status: 400, headers: corsHeaders }
      );
    }

    const pos = Number(positions);
    if (![1, 2, 3].includes(pos)) {
      return new Response(
        JSON.stringify({
          success: false,
          error: "positions must be 1, 2, or 3",
        }),
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

    const appointmentRes = await fetch(
      `${supabaseUrl}/rest/v1/appointments?id=eq.${appointment_id}&clinic_id=eq.${clinic_id}&select=id,doctor_id`,
      { headers: rest },
    );
    const clinicAppointments = appointmentRes.ok
      ? await appointmentRes.json()
      : [];
    if (!Array.isArray(clinicAppointments) || clinicAppointments.length === 0) {
      return new Response(
        JSON.stringify({
          success: false,
          error: "Appointment not found in this clinic",
        }),
        { status: 404, headers: corsHeaders },
      );
    }
    if (clinicAppointments[0].doctor_id !== authenticatedUserId) {
      return new Response(
        JSON.stringify({ success: false, error: "Appointment not owned by doctor" }),
        { status: 403, headers: corsHeaders },
      );
    }

    // 1. Call postgres function postpone_appointment
    const rpcRes = await fetch(
      `${supabaseUrl}/rest/v1/rpc/postpone_appointment`,
      {
        method: "POST",
        headers: rest,
        body: JSON.stringify({
          p_appointment_id: appointment_id,
          p_positions: pos,
        }),
      }
    );

    const rpcData = await rpcRes.json();
    if (!rpcRes.ok || !rpcData?.success) {
      return new Response(
        JSON.stringify({
          success: false,
          error: rpcData?.error || "Failed to postpone appointment",
        }),
        { status: 400, headers: corsHeaders }
      );
    }

    const {
      user_id,
      new_position,
      doctor_id,
      moved_by,
      next_appointment_id,
      next_user_id,
    } = rpcData;

    // 2. Fetch doctor name
    let doctorName = "الطبيب";
    if (doctor_id) {
      try {
        const docRes = await fetch(
          `${supabaseUrl}/rest/v1/doctors?doctor_id=eq.${doctor_id}&select=name`,
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
      console.error("FCM Access Token error:", e);
    }

    // 3. Notify the Postponed Patient
    if (user_id && accessToken) {
      const posText =
        pos === 1 ? "موضعاً واحداً" : pos === 2 ? "موضعين" : "3 مواضع";
      const patientTitle = "⏳ تأجيل ترتيب دورك";
      const patientBody = `نظراً للتأخر، تم تأخير ترتيب دورك ${posText} في قائمة الانتظار مع دكتور ${doctorName}. رقمك الجديد في الانتظار: ${new_position + 1}`;

      await sendFcmToUser(
        supabaseUrl,
        supabaseKey,
        projectId,
        accessToken,
        user_id,
        patientTitle,
        patientBody,
        "appointment",
        {
          appointment_id: String(appointment_id),
          clinic_id: String(clinic_id),
          waiting_list: String(new_position),
          type: "postpone",
        }
      );
    }

    // 4. Notify the NEW NEXT Patient (waiting_list = 0)
    if (next_user_id && next_user_id !== user_id && accessToken) {
      const nextTitle = "🔔 حان دورك الآن!";
      const nextBody = `أنت الآن المريض التالي في قائمة الانتظار مع دكتور ${doctorName}. يرجى التوجه لغرفة الكشف.`;

      await sendFcmToUser(
        supabaseUrl,
        supabaseKey,
        projectId,
        accessToken,
        next_user_id,
        nextTitle,
        nextBody,
        "your_turn",
        {
          appointment_id: String(next_appointment_id),
          clinic_id: String(clinic_id),
          waiting_list: "0",
          type: "your_turn",
        }
      );
    }

    return new Response(
      JSON.stringify({
        success: true,
        data: rpcData,
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
