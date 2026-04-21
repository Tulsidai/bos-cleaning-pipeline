# paths, thresholds, parameters
library(here)

# Paths
p_raw <- here("raw", "audible_uncleaned.csv")
p_out <- here("outputs")
p_log <- here("outputs", "logs")
p_cleaned <- here("outputs", "cleaned.rds")

# Shape of raw data
p_exp_rows <- 87489L
p_exp_cols <- 8L
p_exp_names <- c("name", "author", "narrator", "time", "releasedate", "language", "stars", "price")

# Date parsing (2-digit years 95-99 = 1990s, 00-94 = 2000s)
p_year_cutoff <- 95L
p_year_old    <- 1900L
p_year_recent <- 2000L

# Short name flags - 3 characters
p_short_name_nchar <- 3L

# Outliers
p_outlier_method <- "iqr"
p_outlier_k      <- 1.5