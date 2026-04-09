from supabase import create_client, Client
from flask import current_app

def get_supabase_client() -> Client:
    url = current_app.config.get("SUPABASE_URL")
    key = current_app.config.get("SUPABASE_SERVICE_KEY") or current_app.config.get("SUPABASE_ANON_KEY")
    if not url or not key:
        raise ValueError("Supabase URL and Key must be set in config.py or environment variables")
    return create_client(url, key)
