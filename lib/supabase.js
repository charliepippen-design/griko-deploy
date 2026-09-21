import { createClient } from "@supabase/supabase-js";

const supabaseUrl =
  process.env.NEXT_PUBLIC_SUPABASE_URL ||
  "https://xhpcztzisqdzqiwrojvl.supabase.co";

const supabaseAnonKey =
  process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY ||
  "sb_publishable_fvHGcE6xrVfdg5tHLZKZUQ_7yKSg_iV";

export const supabase = createClient(supabaseUrl, supabaseAnonKey);
