# Reads the raw CSV, validates shape, column names, writes a log

source("R/00_config.R")

library(readr)
library(janitor)

# Load

raw <- read_csv(p_raw, show_col_types = FALSE, locale = locale(encoding = "UTF-8"))
raw <- clean_names(raw)

# Validate shape
stopifnot(
  "Row count mismatch (check source file)" = nrow(raw) == p_exp_rows,
  "Column count mismatch" = ncol(raw) == p_exp_cols,
  "Column names mismatch" = all(names(raw) == p_exp_names)
)

# Log
dir.create(p_log, recursive = TRUE, showWarnings = FALSE)

log_lines <- c(
  paste("Ingest completed:", Sys.time()),
  paste("Rows loaded:", nrow(raw)),
  paste("Columns loaded:", ncol(raw)),
  paste("Columns:", paste(names(raw), collapse = ", ")),
  paste("Encoding: UTF-8"),
  paste("Source:", p_raw)
)

writeLines(log_lines, file.path(p_log, "ingest_log.txt"))
cat(paste(log_lines, collapse = "\n"), "\n")

# Pass forward
saveRDS(raw, file.path(p_out, "raw_loaded.rds"))