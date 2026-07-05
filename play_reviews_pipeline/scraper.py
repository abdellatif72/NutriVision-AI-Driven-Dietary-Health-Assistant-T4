from google_play_scraper import Sort, reviews
import csv
import os

app_id = os.getenv("APP_ID", "<PUT_APP_ID_HERE>")
app_name = "<OPTIONAL_NAME>"


def save_reviews_to_csv(reviews_list, csv_path, fields=None):
    if not reviews_list:
        return
    if fields is None:
        fields = ["userName", "at", "content", "score", "thumbsUpCount"]
    with open(csv_path, "w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=fields)
        writer.writeheader()
        for r in reviews_list:
            row = {}
            for k in fields:
                v = r.get(k)
                if hasattr(v, "isoformat"):
                    v = v.isoformat()
                row[k] = v
            writer.writerow(row)


def import_review(lang, count, star):
    result, _ = reviews(
        app_id,
        lang=lang,
        sort=Sort.MOST_RELEVANT,
        count=count,
        filter_score_with=star,
    )
    return result


def export_language_reviews(lang, count_per_star=100):
    all_reviews = []
    all_reviews.extend(import_review(lang, count_per_star, 5))
    all_reviews.extend(import_review(lang, count_per_star, 4))
    all_reviews.extend(import_review(lang, count_per_star, 3))
    all_reviews.extend(import_review(lang, count_per_star, 2))
    all_reviews.extend(import_review(lang, count_per_star, 1))

    file_name = f"data/google_reviews_{lang}.csv"
    save_reviews_to_csv(all_reviews, file_name)


if __name__ == "__main__":
    if app_id == "<PUT_APP_ID_HERE>":
        raise ValueError("Set APP_ID environment variable or update app_id in scraper.py")

    os.makedirs("data", exist_ok=True)
    export_language_reviews("en", 100)
    export_language_reviews("ar", 100)
