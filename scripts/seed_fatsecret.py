import os
import re
import requests

def get_secret_from_dart(secret_name):
    # Try relative path first, then absolute path
    paths = [
        os.path.join(os.path.dirname(__file__), '../lib/core/constants/app_secrets.dart'),
        '/mnt/6AF6AC44F6AC11FD/anaT3bt/NutriVision-AI-Driven-Dietary-Health-Assistant-T4/lib/core/constants/app_secrets.dart'
    ]
    for path in paths:
        if os.path.exists(path):
            with open(path, 'r', encoding='utf-8') as f:
                content = f.read()
                match = re.search(fr"{secret_name}\s*=\s*['\"]([^'\"]+)['\"]", content)
                if match:
                    return match.group(1)
    return None

# Load credentials
CLIENT_ID = get_secret_from_dart('fatSecretApiKey')
CLIENT_SECRET = get_secret_from_dart('fatSecretApiSecret')

def get_access_token():
    token_url = "https://oauth.fatsecret.com/connect/token"
    if not CLIENT_ID or not CLIENT_SECRET:
        raise ValueError("Please ensure fatSecretApiKey and fatSecretApiSecret are set in app_secrets.dart")
        
    # Requesting token with grant_type and scope.
    data = {
        "grant_type": "client_credentials",
        "scope": "basic"
    }
    
    response = requests.post(
        token_url,
        data=data,
        auth=(CLIENT_ID, CLIENT_SECRET)
    )
    if response.status_code != 200:
        print(f"Error Response from FatSecret: {response.status_code} - {response.text}")
    response.raise_for_status()
    return response.json()["access_token"]



def search_foods(query, token):
    api_url = "https://platform.fatsecret.com/rest/server.api"
    headers = {"Authorization": f"Bearer {token}"}
    params = {
        "method": "foods.search",
        "search_expression": query,
        "format": "json",
        "max_results": 5
    }
    response = requests.get(api_url, headers=headers, params=params)
    response.raise_for_status()
    # إرجاع قائمة الأطعمة بشكل سليم حتى لو رجع عنصر واحد (dict) أو مفيش عناصر
    foods_data = response.json().get("foods", {})
    if not foods_data:
        return []
    food = foods_data.get("food", [])
    if isinstance(food, dict):
        return [food]
    elif isinstance(food, list):
        return food
    return []

def get_food_details(food_id, token):
    api_url = "https://platform.fatsecret.com/rest/server.api"
    headers = {"Authorization": f"Bearer {token}"}
    params = {
        "method": "food.get.v2",
        "food_id": food_id,
        "format": "json"
    }
    response = requests.get(api_url, headers=headers, params=params)
    response.raise_for_status()
    return response.json().get("food", {})

def map_to_unified_schema(food_data):
    servings_list = food_data.get("servings", {}).get("serving", [])
    if not isinstance(servings_list, list):
        servings_list = [servings_list] if servings_list else []
    
    # هنا ممكن نرجع المابينج للـ Unified Schema لاحقاً
    return servings_list

if __name__ == "__main__":
    try:
        token = get_access_token()
        print("تم الحصول على الـ Token بنجاح!")
        
        query = "تفاح"
        results = search_foods(query, token)
        print(f"\n--- نتائج البحث عن: {query} ---")
        
        for food in results:
            print(f"الاسم: {food.get('food_name')} | الـ ID: {food.get('food_id')}")
            
        if results:
            first_food_id = results[0]['food_id']
            print(f"\n--- جلب تفاصيل أكلة ID: {first_food_id} ---")
            details = get_food_details(first_food_id, token)
            print(details)
            
    except Exception as e:
        print(f"حدث خطأ أثناء التشغيل: {e}")
