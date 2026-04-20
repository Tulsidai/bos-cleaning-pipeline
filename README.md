# BOS Technical Unit Data Cleaning Pipeline

**Participant:** Tulsidai Singh
**Dataset:** TBD
**Evaluating officer:** Imraan Khan  

## Overview
TBD once dataset is assigned.

## How to reproduce
1. Clone this repository
2. Open `bos-cleaning-pipeline.Rproj` in RStudio
3. Run `renv::restore()` to install packages
4. Run `source("run_pipeline.R")` to execute the full pipeline

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
| `outputs/report.docx` | Automated Word report |

## Dependencies
See `renv.lock`. Restore with `renv::restore()`.
Python users can read `.sav` and `.dta` via `pyreadstat`, no separate Python export is provided.

## Notes
TBD