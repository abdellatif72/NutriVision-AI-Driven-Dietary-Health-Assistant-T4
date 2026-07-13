import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import * as jose from "npm:jose"

const FIREBASE_PROJECT_ID = "nutrivision-7e139"

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

serve(async (req) => {
  // Handle CORS preflight requests
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const body = await req.json()
    const firebase_token = body.firebase_token

    if (!firebase_token) {
      throw new Error("Missing firebase_token in request body")
    }

    // 1. Verify the Firebase JWT
    // Google hosts the public keys for Firebase Auth here:
    const JWKS = jose.createRemoteJWKSet(
      new URL('https://www.googleapis.com/service_accounts/v1/jwk/securetoken@system.gserviceaccount.com')
    )
    
    const { payload } = await jose.jwtVerify(firebase_token, JWKS, {
      issuer: `https://securetoken.google.com/${FIREBASE_PROJECT_ID}`,
      audience: FIREBASE_PROJECT_ID,
    })

    const firebaseUid = payload.sub
    if (!firebaseUid) {
      throw new Error("Invalid Firebase token: missing sub (uid)")
    }

    // 2. Mint a custom Supabase token
    const supabaseSecret = Deno.env.get('SUPABASE_AUTH_JWT_SECRET') || Deno.env.get('SUPABASE_JWT_SECRET')
    if (!supabaseSecret) {
      throw new Error("Server configuration error: Missing Supabase JWT secret")
    }

    const secret = new TextEncoder().encode(supabaseSecret)
    
    // We set the role to 'authenticated' and sub to the Firebase UID
    // This perfectly aligns with Supabase RLS policies (auth.uid() = user_id)
    const customToken = await new jose.SignJWT({
      aud: 'authenticated',
      role: 'authenticated',
      sub: firebaseUid,
      email: payload.email,
    })
      .setProtectedHeader({ alg: 'HS256' })
      .setIssuedAt()
      .setExpirationTime('1h') // Token expires in 1 hour
      .sign(secret)

    // Return the new Supabase token to the Flutter app
    return new Response(
      JSON.stringify({ supabase_token: customToken }),
      { 
        headers: { ...corsHeaders, "Content-Type": "application/json" },
        status: 200,
      }
    )

  } catch (error) {
    console.error("Token swap error:", error)
    return new Response(
      JSON.stringify({ error: error.message }), 
      { 
        headers: { ...corsHeaders, "Content-Type": "application/json" },
        status: 400,
      }
    )
  }
})
