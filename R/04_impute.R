# Imputation on the cleaned dataset.

source("R/00_config.R")

library(dplyr)

# Load
df <- readRDS(file.path(p_out, "cleaned.rds"))
log_lines <- c(paste("Imputation started:", Sys.time()),
               paste("Rows at start:", nrow(df)))

# rating and rating_count 72,417 NAs (83% missing)
# Structural missing books with no ratings on Audible, not a data error
# Imputing 83% of a column would be misleading. Left as NA
log_lines <- c(log_lines, "",
               "── Rating / rating_count ──",
               paste("NAs in rating:", sum(is.na(df$rating))),
               paste("NAs in rating_count:", sum(is.na(df$rating_count))),
               "Decision: left as NA — structural missing, imputation not justified.")

# Log and save
log_lines <- c(log_lines, "", paste("Imputation completed:", Sys.time()))
writeLines(log_lines, file.path(p_log, "imputation_log.txt"))
cat(paste(log_lines, collapse = "\n"), "\n")

saveRDS(df, file.path(p_out, "imputed.rds"))