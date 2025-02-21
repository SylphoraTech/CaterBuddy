// db.js
require('dotenv').config();
const { createClient } = require('@supabase/supabase-js');

// Retrieve your Supabase URL and key from environment variables
const supabaseUrl = process.env.SUPABASE_URL;
const supabaseKey = process.env.SUPABASE_KEY;

// Create and export the Supabase client instance
const supabase = createClient(supabaseUrl, supabaseKey);

module.exports = supabase;