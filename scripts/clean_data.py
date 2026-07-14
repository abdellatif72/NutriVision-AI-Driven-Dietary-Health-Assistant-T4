import os
import csv
import re

# Emojis keyword matching engine
def get_emoji(name_en, name_ar):
    name_en = name_en.lower()
    name_ar = name_ar

    # Match specific Arabic/Levantine dishes
    if "كشري" in name_ar or "koshari" in name_en: return "🍚"
    if "فلافل" in name_ar or "falafel" in name_en or "طعمية" in name_ar or "taamia" in name_en: return "🧆"
    if "فول" in name_ar or "foul" in name_en or "beans" in name_en: return "🫘"
    if "حمص" in name_ar or "hummus" in name_en or "hommos" in name_en: return "🥣"
    if "سلطة" in name_ar or "salad" in name_en or "تبولة" in name_ar or "tabbouleh" in name_en or "فتوش" in name_ar or "fattoush" in name_en: return "🥗"
    if "خبز" in name_ar or "bread" in name_en or "pita" in name_en: return "🍞"
    if "أرز" in name_ar or "رز" in name_ar or "rice" in name_en: return "🍚"
    if "شوربة" in name_ar or "soup" in name_en: return "🥣"
    if "دجاج" in name_ar or "chicken" in name_en or "djaj" in name_en: return "🍗"
    if "لحم" in name_ar or "meat" in name_en or "beef" in name_en or "lamb" in name_en or "ضأن" in name_ar or "كفتة" in name_ar or "kafta" in name_en or "كبة" in name_ar or "kebba" in name_en or "شاورما" in name_ar or "shawarma" in name_en: return "🥩"
    if "سمك" in name_ar or "fish" in name_en or "tilapia" in name_en or "sardines" in name_en or "صيادية" in name_ar or "sayadia" in name_en or "جمبري" in name_ar or "shrimp" in name_en or "seafood" in name_en: return "🐟"
    if "بيض" in name_ar or "egg" in name_en: return "🥚"
    if "حليب" in name_ar or "milk" in name_en: return "🥛"
    if "زبادي" in name_ar or "yogurt" in name_en: return "🥣"
    if "جبن" in name_ar or "cheese" in name_en: return "🧀"
    if "تمر" in name_ar or "date" in name_en: return "🌴"
    if "تين" in name_ar or "fig" in name_en: return "🫘"
    if "مشمش" in name_ar or "apricot" in name_en: return "🍑"
    if "رمان" in name_ar or "pomegranate" in name_en: return "🍎"
    if "بطيخ" in name_ar or "watermelon" in name_en: return "🍉"
    if "طماطم" in name_ar or "tomato" in name_en: return "🍅"
    if "خيار" in name_ar or "cucumber" in name_en: return "🥒"
    if "باذنجان" in name_ar or "eggplant" in name_en: return "🍆"
    if "سبانخ" in name_ar or "spinach" in name_en: return "🥬"
    if "بامية" in name_ar or "okra" in name_en: return "🥬"
    if "كوسا" in name_ar or "كوسة" in name_ar or "zucchini" in name_en: return "🥒"
    if "كرنب" in name_ar or "ملفوف" in name_ar or "cabbage" in name_en: return "🥬"
    if "جزر" in name_ar or "carrot" in name_en: return "🥕"
    if "بطاطا" in name_ar or "بطاطس" in name_ar or "potato" in name_en: return "🥔"
    if "بقلاوة" in name_ar or "baklava" in name_en or "كنافة" in name_ar or "kounafa" in name_en or "معمول" in name_ar or "maamoul" in name_en or "غريبة" in name_ar or "ghourayba" in name_en or "بسبوسة" in name_ar or "قطايف" in name_ar or "katayef" in name_en or "مهلبية" in name_ar or "mouhallabiya" in name_en or "رز بحليب" in name_ar or "زنود الست" in name_ar or "znoud" in name_en or "حلويات" in name_ar or "sweet" in name_en or "dessert" in name_en or "cake" in name_en or "biscuit" in name_en or "بسكويت" in name_ar: return "🍰"
    if "مكسرات" in name_ar or "nuts" in name_en or "لوز" in name_ar or "almonds" in name_en or "جوز" in name_ar or "walnuts" in name_en or "بندق" in name_ar or "hazelnuts" in name_en or "فستق" in name_ar or "pistachio" in name_en or "صنوبر" in name_ar or "pinenuts" in name_en: return "🥜"
    if "زيت" in name_ar or "oil" in name_en: return "🫗"
    if "بذور" in name_ar or "seeds" in name_en or "سمسم" in name_ar or "sesame" in name_en: return "🫘"
    
    return "🍲" # Default food emoji

# Category Arabic-to-English translation mapping
def get_category_en(category_ar):
    if not category_ar:
        return "Other"
    category_ar = category_ar.strip()
    mapping = {
        "أكل شامي": "Levantine Dishes",
        "أكل لبناني": "Levantine Dishes",
        "أكل مصري": "Egyptian Dishes",
        "أكل عربي": "Arabic Dishes",
        "أكل مغاربي": "Maghrebi Dishes",
        "أكل مغربي": "Maghrebi Dishes",
        "حلويات عربية": "Arabic Sweets",
        "حلويات": "Sweets",
        "مخبوزات": "Bakery",
        "مكون أساسي": "Basic Ingredients",
        "مكونات": "Basic Ingredients",
        "خضروات": "Vegetables",
        "فواكه": "Fruits",
        "لحوم": "Meat",
        "أسماك": "Seafood",
        "ألبان": "Dairy",
        "بروتينات": "Proteins",
        "بذور": "Seeds",
        "مكسرات": "Nuts",
        "زيوت": "Oils"
    }
    return mapping.get(category_ar, "Other")

# Parse and clean numerical strings
def clean_numeric(val):
    if val is None:
        return 0.0
    val_str = str(val).strip()
    if val_str in ("Tr", "T", "-", "T.r", "t.r", "", "None"):
        return 0.0
    if val_str.startswith("<"):
        try:
            num = float(val_str[1:])
            return num / 2.0
        except ValueError:
            return 0.0
    match = re.search(r"([0-9]+(?:\.[0-9]+)?)", val_str)
    if match:
        return float(match.group(1))
    return 0.0

def format_sql_val(val):
    if val is None:
        return "NULL"
    if isinstance(val, (int, float)):
        return str(val)
    escaped = val.replace("'", "''")
    return f"'{escaped}'"

def format_sql_array(tags):
    if not tags:
        return "ARRAY[]::text[]"
    escaped_tags = [t.replace("'", "''") for t in tags]
    elements = ", ".join(f"'{t}'" for t in escaped_tags)
    return f"ARRAY[{elements}]::text[]"

def main():
    script_dir = os.path.dirname(os.path.abspath(__file__))
    input_csv = os.path.join(script_dir, "data.csv")
    output_csv = os.path.join(script_dir, "data_cleaned.csv")
    output_sql = os.path.join(script_dir, "seed_foods.sql")
    
    if not os.path.exists(input_csv):
        print(f"Error: Input file {input_csv} not found.")
        return

    cleaned_rows = []
    
    with open(input_csv, mode="r", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        for row in reader:
            # Check if row is completely empty of nutritional value
            cal_str = row.get("السعرات (Energy)", "").strip()
            prot_str = row.get("البروتين", "").strip()
            fat_str = row.get("الدهون (Fat)", "").strip()
            carb_str = row.get("الكارب (CHO)", "").strip()
            
            if cal_str == "" and prot_str == "" and fat_str == "" and carb_str == "":
                # Drop rows with no nutritional data
                continue

            name_en = row.get("اسم الطبق", "").strip()
            name_ar = row.get("اسم الطبق بالعربية", "").strip()
            sheet_name = row.get("اسم ورقة العمل", "").strip()
            
            # Categories Backfill
            cat_ar = row.get("التصنيف", "").strip()
            if not cat_ar:
                cat_ar = sheet_name
            cat_en = get_category_en(cat_ar)
            
            # Numeric Parsing
            calories = int(round(clean_numeric(cal_str)))
            protein = clean_numeric(prot_str)
            fat = clean_numeric(fat_str)
            carbs = clean_numeric(carb_str)
            fiber = clean_numeric(row.get("الألياف (Fibre)", ""))
            
            # Vitamins (discarded in SQL but let's keep them in CSV for completeness)
            vit_a = clean_numeric(row.get("Vit A", ""))
            vit_d = clean_numeric(row.get("Vit D", ""))
            vit_e = clean_numeric(row.get("Vit E", ""))
            vit_c = clean_numeric(row.get("Vit C", ""))

            # Emoji Mapping
            emoji = get_emoji(name_en, name_ar)
            
            # Tags Clean & Remove Meat from Ward el Sham
            tags_str = row.get("الوسوم (Tags)", "").strip()
            tags_list = [t.strip() for t in tags_str.split(',') if t.strip()]
            if name_en == 'Ward el sham' or name_ar == 'ورد الشام':
                tags_list = [t for t in tags_list if t.lower() != 'meat']
            
            cleaned_row = {
                "sheet_name": sheet_name,
                "name_en": name_en,
                "name_ar": name_ar,
                "category_ar": cat_ar,
                "category_en": cat_en,
                "emoji": emoji,
                "serving_size_g": 100,
                "serving_label_ar": "١٠٠ غرام",
                "serving_label_en": "100 g",
                "calories": calories,
                "protein_g": protein,
                "fat_g": fat,
                "carbs_g": carbs,
                "fiber_g": fiber,
                "vit_a": vit_a,
                "vit_d": vit_d,
                "vit_e": vit_e,
                "vit_c": vit_c,
                "tags": tags_list
            }
            cleaned_rows.append(cleaned_row)
            
    # Write Cleaned CSV
    csv_headers = [
        "sheet_name", "name_en", "name_ar", "category_ar", "category_en",
        "emoji", "serving_size_g", "serving_label_ar", "serving_label_en",
        "calories", "protein_g", "fat_g", "carbs_g", "fiber_g",
        "vit_a", "vit_d", "vit_e", "vit_c", "tags"
    ]
    with open(output_csv, mode="w", encoding="utf-8", newline="") as f:
        writer = csv.writer(f)
        writer.writerow(csv_headers)
        for r in cleaned_rows:
            writer.writerow([
                r["sheet_name"], r["name_en"], r["name_ar"], r["category_ar"], r["category_en"],
                r["emoji"], r["serving_size_g"], r["serving_label_ar"], r["serving_label_en"],
                r["calories"], r["protein_g"], r["fat_g"], r["carbs_g"], r["fiber_g"],
                r["vit_a"], r["vit_d"], r["vit_e"], r["vit_c"],
                ", ".join(r["tags"])
            ])
            
    print(f"Successfully cleaned data. Total rows written to CSV: {len(cleaned_rows)}")
    
    # Generate SQL Seeding File
    with open(output_sql, mode="w", encoding="utf-8") as f:
        f.write("-- Food Catalog Seed Script\n")
        f.write("-- Generated automatically by clean_data.py\n\n")
        f.write("INSERT INTO public.food_catalog (\n")
        f.write("    name_ar, name_en, emoji, category_ar, category_en,\n")
        f.write("    serving_size_g, serving_label_ar, serving_label_en,\n")
        f.write("    calories, protein_g, carbs_g, fat_g, fiber_g,\n")
        f.write("    tags, source\n")
        f.write(") VALUES\n")
        
        values_queries = []
        for r in cleaned_rows:
            row_vals = [
                format_sql_val(r["name_ar"]),
                format_sql_val(r["name_en"]),
                format_sql_val(r["emoji"]),
                format_sql_val(r["category_ar"]),
                format_sql_val(r["category_en"]),
                str(r["serving_size_g"]),
                format_sql_val(r["serving_label_ar"]),
                format_sql_val(r["serving_label_en"]),
                str(r["calories"]),
                str(r["protein_g"]),
                str(r["carbs_g"]),
                str(r["fat_g"]),
                str(r["fiber_g"]),
                format_sql_array(r["tags"]),
                format_sql_val("local_catalog")
            ]
            values_queries.append("    (" + ", ".join(row_vals) + ")")
            
        f.write(",\n".join(values_queries))
        f.write(";\n")
        
    print(f"Successfully generated seed SQL: {output_sql}")

if __name__ == "__main__":
    main()
