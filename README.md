# BOS Technical Unit Data Cleaning Pipeline

**Participant:** Tulsidai Singh
**Dataset:** Audible Dataset
**Evaluating officer:** Imraan Khan  

## Overview
A reproducible R pipeline that ingests, diagnoses, cleans and exports the Audible audiobook dataset.

## Data source
Audible Dataset by Snehangsude from Kaggle (CC0 Public Domain)  
https://www.kaggle.com/datasets/snehangsude/audible-dataset  
Raw file: `raw/audible_uncleaned.csv`

## How to reproduce
1. Clone this repository
2. Open `bos-cleaning-pipeline.Rproj` in RStudio
3. Run `renv::restore()` to install dependencies
4. Run `source("run_pipeline.R")` to execute the full pipeline

All outputs will be written to `outputs/`.


## Project structure

```
raw/           # raw data — never edited in place
R/             # pipeline scripts
outputs/       # cleaned datasets, data dictionary, rendered report
reports/       # weekly Friday reports
presentation/  # final PowerPoint
```

## Outputs

| File | Format |
|------|--------|
| `outputs/cleaned.sav` | SPSS |
| `outputs/cleaned.dta` | Stata |
| `outputs/cleaned.xlsx` | Excel (data + data dictionary sheets) |
| `outputs/cleaned.rds` | R native |
| `outputs/data_dictionary.csv` | Data dictionary (CSV) |
| `outputs/report.docx` | Automated Word report |

## Dependencies

Managed with `renv`. Run `renv::restore()` to install the exact package versions used.  
Python users can read `.sav` and `.dta` via `pyreadstat` — no separate Python export is provided.
Quarto CLI must be installed separately — download from [quarto.org](https://quarto.org).  
To run without RStudio: `Rscript run_pipeline.R` from the project root.

## Scripts

| Script | Purpose |
|--------|---------|
| `R/00_config.R` | All paths, thresholds, and parameters |
| `R/01_ingest.R` | Load raw CSV, validate shape, log |
| `R/02_diagnose.R` | Exploratory diagnostics, missingness charts |
| `R/03_clean.R` | All 8 cleaning stages, logged |
| `R/04_impute.R` | Imputation decisions and logging |
| `R/05_export.R` | Multi-format exports |
| `R/data_dictionary.R` | Build and write data dictionary |
| `R/06_report.qmd` | Automated Word report |
| `run_pipeline.R` | Single entry point — runs everything |

## Data source note

The raw dataset is CC0 Public Domain and is included in this repository for reproducibility.
