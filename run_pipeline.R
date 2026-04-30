# Run the full pipeline in order.

cat("Start Pipeline\n\n")

source("R/00_config.R")

# Create output directories if they don't exist
dir.create(p_out, recursive = TRUE, showWarnings = FALSE)
dir.create(p_log, recursive = TRUE, showWarnings = FALSE)

cat("1/7 ~ Ingesting raw data\n")
source("R/01_ingest.R")

cat("2/7 ~ Running diagnostics\n")
source("R/02_diagnose.R")

cat("3/7 ~ Cleaning...\n")
source("R/03_clean.R")

cat("4/7 ~ Imputing\n")
source("R/04_impute.R")

cat("5/7 ~ Exporting\n")
source("R/05_export.R")

cat("6/7 ~ Building data dictionary\n")
source("R/data_dictionary.R")

cat("7/7 ~ Rendering report\n")
quarto::quarto_render("R/06_report.qmd", output_file = "../outputs/report.docx")

cat("\nPipeline complete. All outputs written to outputs/\n")