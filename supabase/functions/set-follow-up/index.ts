import { serve } from "https://deno.land/std@0.224.0/http/mod.ts";
import { getAccessToken } from "./firebase.ts";

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

serve(async (req) => {
  try {
    const { appointment_id, clinic_id, follow_up_date } = await req.json();
    if (appointment_id == null || clinic_id == null || !follow_up_date) {
      return new Response(
        JSON.stringify({
          success: false,
          error: "appointment_id, clinic_id, and follow_up_date are required",
        }),
        { status: 400 },
      );
    }
    const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
    const supabaseKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
    const projectId = Deno.env.get("FIREBASE_PROJECT_ID")!;
    const authenticatedUserId = await getAuthenticatedUserId(
      req,
      supabaseUrl,
      supabaseKey,
    );
    if (!authenticatedUserId) {
      return new Response(
        JSON.stringify({ success: false, error: "Authentication required" }),
        { status: 401 },
      );
    }

    const appointmentRes = await fetch(
      `${supabaseUrl}/rest/v1/appointments?id=eq.${appointment_id}&clinic_id=eq.${clinic_id}&select=doctor_id`,
      {
        headers: {
          apikey: supabaseKey,
          Authorization: `Bearer ${supabaseKey}`,
        },
      },
    );
    const appointment = appointmentRes.ok
      ? (await appointmentRes.json())?.[0]
      : null;
    if (!appointment) {
      return new Response(
        JSON.stringify({ success: false, error: "Appointment not found in this clinic" }),
        { status: 404 },
      );
    }
    if (appointment.doctor_id !== authenticatedUserId) {
      return new Response(
        JSON.stringify({ success: false, error: "Appointment not owned by doctor" }),
        { status: 403 },
      );
    }

    // 1. Update follow up date
    const updateRes = await fetch(
      `${supabaseUrl}/rest/v1/appointments?id=eq.${appointment_id}&clinic_id=eq.${clinic_id}`,
      {
        method: "PATCH",
        headers: {
          "Content-Type": "application/json",
          apikey: supabaseKey,
          Authorization: `Bearer ${supabaseKey}`,
          Prefer: "return=representation",
        },
        body: JSON.stringify({
          follow_up_date,
          appointment_type: 2,
        }),
      }
    );

    const updated = (await updateRes.json())?.[0];
    if (!updated) {
      return new Response(
        JSON.stringify({ success: false, error: "الموعد غير موجود" }),
        { status: 404 }
      );
    }

    // 2. Get user fcm token
    const userRes = await fetch(
      `${supabaseUrl}/rest/v1/users?user_id=eq.${updated.user_id}&select=fcm_token`,
      {
        headers: {
          apikey: supabaseKey,
          Authorization: `Bearer ${supabaseKey}`,
        },
      }
    );

    const user = (await userRes.json())?.[0];
    const devicesRes = await fetch(
      `${supabaseUrl}/rest/v1/user_devices?user_id=eq.${updated.user_id}&is_active=eq.true&select=fcm_token`,
      {
        headers: {
          apikey: supabaseKey,
          Authorization: `Bearer ${supabaseKey}`,
        },
      },
    );
    const devices = devicesRes.ok ? await devicesRes.json() : [];
    const tokens = [...new Set([
      ...(Array.isArray(devices) ? devices.map((device: { fcm_token?: string | null }) => device.fcm_token) : []),
      user?.fcm_token,
    ].filter((token): token is string => typeof token === 'string' && token.trim().length > 0))];
    let notification_sent = false;
    let notification_id: number | null = null;

    const message = `✅ تم تحديد موعد إعادة الكشف بتاريخ ${follow_up_date}`;

    // 2a. Persist to inbox
    const insertRes = await fetch(`${supabaseUrl}/rest/v1/notifications`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        apikey: supabaseKey,
        Authorization: `Bearer ${supabaseKey}`,
        Prefer: "return=representation",
      },
      body: JSON.stringify({
        user_id: updated.user_id,
        clinic_id,
        title: "موعد متابعة",
        message,
        type: "reminder",
        data: {
          appointment_id: String(appointment_id),
          clinic_id: String(clinic_id),
          type: "follow_up",
        },
      }),
    });
    if (insertRes.ok) {
      notification_id = (await insertRes.json())?.[0]?.id ?? null;
    }

    // 3. Send notification
    if (tokens.length > 0) {
      const accessToken = await getAccessToken();

      const results = await Promise.all(tokens.map(async (token) => {
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
                token,
                notification: {
                  title: "موعد متابعة",
                  body: message,
                },
                data: {
                  appointment_id: String(appointment_id),
                  clinic_id: String(clinic_id),
                  type: "follow_up",
                  notification_id:
                    notification_id != null ? String(notification_id) : "",
                },
              },
            }),
          }
        );
        return fcmRes.ok;
      }));
      notification_sent = results.some((sent) => sent);
    }

    return new Response(
      JSON.stringify({
        success: true,
        data: updated,
        notification_sent,
        notification_id,
      }),
      { status: 200 }
    );
  } catch (err: any) {
    return new Response(
      JSON.stringify({ success: false, error: err?.message ?? String(err) }),
      { status: 500 }
    );
  }
});
