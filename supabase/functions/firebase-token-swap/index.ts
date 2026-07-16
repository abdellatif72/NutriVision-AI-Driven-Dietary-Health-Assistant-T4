import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import * as jose from "https://deno.land/x/jose@v4.14.4/index.ts"

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const { firebase_token } = await req.json()
    if (!firebase_token) {
      return new Response(JSON.stringify({ error: 'firebase_token is required' }), {
        status: 400,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      })
    }

    // 1. استدعاء معرّف المشروع من متغيرات البيئة
    let projectId = Deno.env.get('FIREBASE_PROJECT_ID')
    if (!projectId) {
      throw new Error('FIREBASE_PROJECT_ID environment variable is not set')
    }
    // Clean any literal quotes set by CLI/environments
    projectId = projectId.replace(/^["']|["']$/g, '')

    // 2. التحقق من صحة التوكن عبر خدمة مفاتيح Google العامة (JWKS)
    const JWKS = jose.createRemoteJWKSet(
      new URL('https://www.googleapis.com/service_accounts/v1/jwk/securetoken@system.gserviceaccount.com')
    )

    const { payload } = await jose.jwtVerify(firebase_token, JWKS, {
      issuer: `https://securetoken.google.com/${projectId}`,
      audience: projectId,
    })

    const userId = payload.sub
    if (!userId) {
      throw new Error('No user ID found in firebase token')
    }

    // 3. قراءة سر تشفير الـ JWT الخاص بـ Supabase (موجود تلقائياً في السيرفر)
    const jwtSecret = Deno.env.get('JWT_SECRET')
    if (!jwtSecret) {
      throw new Error('JWT_SECRET environment variable is not set')
    }

    const secretKey = new TextEncoder().encode(jwtSecret)
    
    // 4. إنشاء توكن جديد خاص بـ Supabase يحمل نفس الـ User ID
    const supabaseToken = await new jose.SignJWT({
      role: 'authenticated',
      aud: 'authenticated',
      sub: userId,
      email: payload.email,
      app_metadata: { provider: 'firebase' },
      user_metadata: { name: payload.name || '' },
    })
      .setProtectedHeader({ alg: 'HS256' })
      .setIssuedAt()
      .setExpirationTime('1h') // صلاحية التوكن ساعة واحدة
      .sign(secretKey)

    // إرجاع التوكن الجديد للتطبيق
    return new Response(JSON.stringify({ supabase_token: supabaseToken }), {
      status: 200,
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
    })
  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), {
      status: 500,
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
    })
  }
})