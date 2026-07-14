import os
import re
import urllib.request
import json

def get_secret_from_dart(secret_name):
    path = '/mnt/6AF6AC44F6AC11FD/anaT3bt/NutriVision-AI-Driven-Dietary-Health-Assistant-T4/lib/core/constants/app_secrets.dart'
    if os.path.exists(path):
        with open(path, 'r', encoding='utf-8') as f:
            content = f.read()
            match = re.search(fr"{secret_name}\s*=\s*['\"]([^'\"]+)['\"]", content)
            if match:
                return match.group(1)
    return None

def main():
    supabase_url = get_secret_from_dart('supabaseUrl')
    supabase_anon_key = get_secret_from_dart('supabaseAnonKey')
    
    if not supabase_url or not supabase_anon_key:
        print("Error: Supabase credentials not found in app_secrets.dart")
        return
        
    print(f"Fetching food catalog from {supabase_url}...")
    
    url = f"{supabase_url}/rest/v1/food_catalog?select=*"
    headers = {
        "apikey": supabase_anon_key,
        "Authorization": f"Bearer {supabase_anon_key}"
    }
    
    req = urllib.request.Request(url, headers=headers)
    try:
        with urllib.request.urlopen(req) as response:
            body = response.read().decode('utf-8')
            data = json.loads(body)
            backup_path = '/mnt/6AF6AC44F6AC11FD/anaT3bt/NutriVision-AI-Driven-Dietary-Health-Assistant-T4/scripts/food_catalog_backup.json'
            with open(backup_path, 'w', encoding='utf-8') as f:
                json.dump(data, f, indent=2, ensure_ascii=False)
            print(f"Successfully backed up {len(data)} items to {backup_path}")
    except Exception as e:
        print("Error backing up food catalog:", e)

if __name__ == "__main__":
    main()
