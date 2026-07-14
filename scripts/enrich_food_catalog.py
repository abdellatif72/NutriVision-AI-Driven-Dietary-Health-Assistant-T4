import os
import re
import csv
import json
import time
import urllib.request
import urllib.error

def get_secret_from_dart(secret_name):
    path = '/mnt/6AF6AC44F6AC11FD/anaT3bt/NutriVision-AI-Driven-Dietary-Health-Assistant-T4/lib/core/constants/app_secrets.dart'
    if os.path.exists(path):
        with open(path, 'r', encoding='utf-8') as f:
            content = f.read()
            match = re.search(fr"{secret_name}\s*=\s*['\"]([^'\"]+)['\"]", content)
            if match:
                return match.group(1)
    return None

def call_gemini_api(api_key, prompt):
    url = f"https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key={api_key}"
    payload = {
        "contents": [
            {
                "parts": [
                    {"text": prompt}
                ]
            }
        ],
        "generationConfig": {
            "responseMimeType": "application/json"
        }
    }
    
    headers = {
        "Content-Type": "application/json"
    }
    
    req = urllib.request.Request(
        url,
        data=json.dumps(payload).encode('utf-8'),
        headers=headers,
        method="POST"
    )
    
    max_retries = 3
    for attempt in range(max_retries):
        try:
            with urllib.request.urlopen(req, timeout=60) as response:
                body = response.read().decode('utf-8')
                res_json = json.loads(body)
                text_content = res_json['candidates'][0]['content']['parts'][0]['text']
                return json.loads(text_content)
        except urllib.error.HTTPError as e:
            print(f"HTTP Error (attempt {attempt+1}/{max_retries}): {e.code} - {e.read().decode('utf-8')}")
            if e.code == 429: # Rate limit
                time.sleep(10)
            else:
                time.sleep(2)
        except Exception as e:
            print(f"Error calling Gemini (attempt {attempt+1}/{max_retries}): {e}")
            time.sleep(2)
            
    raise Exception("Failed to call Gemini API after maximum retries.")

def main():
    api_key = get_secret_from_dart('geminiApiKey')
    if not api_key:
        print("Error: geminiApiKey not found in app_secrets.dart")
        return
        
    script_dir = os.path.dirname(os.path.abspath(__file__))
    input_csv = os.path.join(script_dir, "data.csv")
    output_csv = os.path.join(script_dir, "data_enriched.csv")
    
    if not os.path.exists(input_csv):
        print(f"Error: Input file {input_csv} not found.")
        return

    # Read original CSV rows
    rows = []
    with open(input_csv, mode="r", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        fieldnames = reader.fieldnames
        for r in reader:
            rows.append(r)
            
    print(f"Loaded {len(rows)} rows from {input_csv}.")
    
    # Batch processing
    batch_size = 50
    enriched_results = {}
    
    for i in range(0, len(rows), batch_size):
        batch = rows[i:i+batch_size]
        print(f"\nProcessing batch {i // batch_size + 1} / {(len(rows) + batch_size - 1) // batch_size}...")
        
        # Prepare item description for the prompt
        batch_items = []
        for index, item in enumerate(batch):
            batch_items.append({
                "temp_id": index,
                "name_en": item.get("اسم الطبق", ""),
                "name_ar": item.get("اسم الطبق بالعربية", ""),
                "category_ar": item.get("التصنيف", "") or item.get("اسم ورقة العمل", "")
            })
            
        prompt = f"""
You are a nutrition database expert.
I have a list of food items. For each item, you must determine:
1. A realistic, standard single serving size in grams (serving_size_g).
   Guidelines for serving sizes:
   - Eggs: 50g (1 egg)
   - Fruits: 120g to 180g (e.g. medium banana 120g, medium apple 150g, 1 piece of smaller fruit 80g, etc.)
   - Liquids/Beverages/Milk: 240g (1 cup / glass)
   - Main dishes (rice, pasta, cooked meals): 200g - 300g (e.g. 1 plate / portion)
   - Bread / Pita: 50g - 100g (e.g. 1 loaf / piece)
   - Spreads / Oils / Honey: 15g (1 tablespoon) or 10g (1 teaspoon)
   - Snacks / Nuts: 30g (1 handful / portion)
   - Arabic sweets / pastries: 50g - 100g (1 piece / portion)
2. A localized English serving label (serving_label_en), e.g. "1 medium banana (120 g)", "1 large egg (50 g)", "1 cup (240 g)", "1 plate (200 g)", "1 tablespoon (15 g)", "1 loaf (80 g)".
3. A localized Arabic serving label (serving_label_ar) using Arabic numerals (e.g. ١, ٢, ٣, ٥) and Arabic text (e.g. غرام, كوب, حبة, طبق, ملعقة كبيرة), e.g. "موزة متوسطة (١٢٠ غرام)", "بيضة كبيرة (٥٠ غرام)", "كوب (٢٤٠ غرام)", "طبق (٢٠٠ غرام)", "ملعقة كبيرة (١٥ غرام)", "رغيف (٨٠ غرام)".

Here is the food list (JSON format):
{json.dumps(batch_items, ensure_ascii=False, indent=2)}

Respond with a JSON array of objects. Each object must contain:
- "temp_id": the corresponding temp_id from the input list
- "serving_size_g": integer
- "serving_label_en": string
- "serving_label_ar": string

Do not include any explanation. Just return the JSON array.
"""
        
        try:
            suggestions = call_gemini_api(api_key, prompt)
            # Map suggestions back
            for sug in suggestions:
                temp_id = sug.get("temp_id")
                if temp_id is not None and temp_id < len(batch):
                    item = batch[temp_id]
                    # Unique key based on name_en and name_ar
                    key = (item.get("اسم الطبق", ""), item.get("اسم الطبق بالعربية", ""))
                    enriched_results[key] = {
                        "serving_size_g": int(sug.get("serving_size_g", 100)),
                        "serving_label_en": sug.get("serving_label_en", "100 g"),
                        "serving_label_ar": sug.get("serving_label_ar", "١٠٠ غرام")
                    }
            print(f"Batch {i // batch_size + 1} completed successfully.")
        except Exception as e:
            print(f"Error processing batch {i // batch_size + 1}: {e}")
            # Fallback to 100g
            for item in batch:
                key = (item.get("اسم الطبق", ""), item.get("اسم الطبق بالعربية", ""))
                enriched_results[key] = {
                    "serving_size_g": 100,
                    "serving_label_en": "100 g",
                    "serving_label_ar": "١٠٠ غرام"
                }
        
        # Avoid hitting API rate limit too hard
        time.sleep(2)

    # Write enriched CSV
    new_fieldnames = list(fieldnames) + ["serving_size_g", "serving_label_en", "serving_label_ar"]
    with open(output_csv, mode="w", encoding="utf-8", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=new_fieldnames)
        writer.writeheader()
        
        for item in rows:
            key = (item.get("اسم الطبق", ""), item.get("اسم الطبق بالعربية", ""))
            enrichment = enriched_results.get(key, {
                "serving_size_g": 100,
                "serving_label_en": "100 g",
                "serving_label_ar": "١٠٠ غرام"
            })
            
            new_row = dict(item)
            new_row["serving_size_g"] = enrichment["serving_size_g"]
            new_row["serving_label_en"] = enrichment["serving_label_en"]
            new_row["serving_label_ar"] = enrichment["serving_label_ar"]
            writer.writerow(new_row)
            
    print(f"\nFinished enrichment. Total items written to enriched CSV: {len(rows)}")

if __name__ == "__main__":
    main()
