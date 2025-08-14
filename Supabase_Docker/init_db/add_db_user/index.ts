
const CORS_HEADERS = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

function response( json, status ) {
  return new Response(JSON.stringify(json), {
    status: status,
    headers: { ...CORS_HEADERS, 'Content-Type': 'application/json' }
  })
}

import { createClient } from 'npm:@supabase/supabase-js@2';
import { serve } from 'https://deno.land/std@0.168.0/http/server.ts';

// Deno environment configuration
const supabase_url = Deno.env.get('SUPABASE_URL');
const supabase_key = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY');

// db user credentials
const EMAIL = "database@flowcellutions.com"
const DB_PW = "FlowCellDB!"

serve(async (req)=>{
  // This is needed if you're planning to invoke your function from a browser.
  if (req.method === 'OPTIONS')
    return new Response('ok', { headers: CORS_HEADERS })

  // Only allow POST requests
  if (req.method !== 'POST')
    return new Response("Method Not Allowed", { status: 405 })

  try {
    // Create Supabase client with service role key for admin operations
    const SB = createClient(supabase_url, supabase_key)

    // Create user with email and password
    const credentials = {
      email: EMAIL,
      password: DB_PW
    }

    const { data, error } = await SB.auth.signUp(credentials)
    if (error) return response({ error: error.message }, 400)

    // sign out db-user to revert to service user (bypassing rls)
    SB.auth.signOut()

    const user_id = data.user.id
    await SB.from('Experiments').update({ user_id: user_id }).eq('id', 1)

    // Return successful user creation response
    return response({ user: data.user }, 201)
  }
  catch ( err ) {
    const error = { error: "Internal Server Error", details: err.message }
    return response(error, 500)
  }
})
