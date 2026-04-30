# Run the full pipeline in order.

cat("Start Pipeline\n\n")

source("R/00_config.R")

# Create output directories if they don't exist
dir.create(p_out, recursive = TRUE, showWarnings = FALSE)
dir.create(p_log, recursive = TRUE, showWarnings = FALSE)

cat("1/6 ~ Ingesting raw data\n")
source("R/01_ingest.R")

cat("2/6 ~ Running diagnostics\n")
source("R/02_diagnose.R")

cat("3/6 ~ Cleaning...\n")
source("R/03_clean.R")

cat("4/6 ~ Imputing\n")
source("R/04_impute.R")

cat("5/6 ~ Exporting\n")
source("R/05_export.R")

cat("6/6 ~ Building data dictionary\n")
source("R/data_dictionary.R")

cat("\nPipeline complete. All outputs written to outputs/\n")