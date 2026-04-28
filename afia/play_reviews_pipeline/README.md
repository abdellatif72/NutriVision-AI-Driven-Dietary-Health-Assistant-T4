# Google Play Reviews Pipeline

This pipeline runs end-to-end:
1. Scrape Google Play reviews for one app (`en` + `ar`).
2. Create or reuse an app-specific folder under `apps/<app_name>/`.
3. Save app CSVs to `apps/<app_name>/data/`.
4. Execute that app folder's `analysis.ipynb` and write images to `apps/<app_name>/outputs/`.

## Files
- `scraper.py`: review collection
- `analysis.ipynb`: template notebook copied per app
- `run_pipeline.py`: orchestrator
- `apps/<app_name>/analysis.ipynb`: app-specific notebook
- `apps/<app_name>/data/`: app-specific CSV files
- `apps/<app_name>/outputs/`: app-specific wordcloud images

## Run
```bash
python run_pipeline.py --app-id com.example.app --app-name "My App"
```

## Optional
Run steps separately:
```bash
cd apps/"My App"
APP_ID=com.example.app python ../../scraper.py
jupyter nbconvert --to notebook --execute --inplace analysis.ipynb
```
