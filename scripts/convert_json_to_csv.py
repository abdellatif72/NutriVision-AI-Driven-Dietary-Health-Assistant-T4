import json
import csv
import os

def main():
    script_dir = os.path.dirname(os.path.abspath(__file__))
    json_path = os.path.join(script_dir, "food_catalog_backup.json")
    csv_path = os.path.join(script_dir, "food_catalog_downloaded.csv")
    
    if not os.path.exists(json_path):
        print(f"Error: {json_path} not found.")
        return
        
    with open(json_path, 'r', encoding='utf-8') as f:
        data = json.load(f)
        
    if not data:
        print("No data to convert.")
        return
        
    # Get headers from the first item keys
    headers = list(data[0].keys())
    
    # Remove id and created_at if we want a clean importable file
    # but let's keep them so it's a direct copy
    with open(csv_path, 'w', encoding='utf-8', newline='') as f:
        writer = csv.DictWriter(f, fieldnames=headers)
        writer.writeheader()
        for row in data:
            # Handle list fields (like tags) by joining them
            row_copy = dict(row)
            if isinstance(row_copy.get('tags'), list):
                row_copy['tags'] = ", ".join(row_copy['tags'])
            writer.writerow(row_copy)
            
    print(f"Successfully converted JSON to CSV: {csv_path}")

if __name__ == "__main__":
    main()
