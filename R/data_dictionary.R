# Builds the data dictionary from the cleaned dataset

source("R/00_config.R")
library(openxlsx)

df_raw   <- readRDS(file.path(p_out, "raw_loaded.rds"))
df_clean <- readRDS(file.path(p_out, "imputed.rds"))

dict <- data.frame(
  variable = c("name", "author", "narrator", "time", "releasedate", "language",
               "stars", "price", "rating", "rating_count", "duration_mins",
               "short_name_flag", "price_outlier", "duration_outlier"),
  
  type = c("character", "character", "character", "character", "date",
           "character", "character", "numeric", "numeric", "integer",
           "numeric", "logical", "logical", "logical"),
  
  label = c("Audiobook title", "Author(s)", "Narrator(s)",
            "Duration as original string", "Release date",
            "Language of the audiobook", "Stars as original string",
            "Price in INR", "Numeric star rating (1-5)",
            "Number of ratings", "Duration in minutes",
            "Flag: title has fewer than 3 characters",
            "Flag: price is an IQR outlier",
            "Flag: duration is an IQR outlier"),
  
  valid_range_or_values = c(
    "Any string", "Any string", "Any string",
    "e.g. '2 hrs and 20 mins'", "1998-12-27 to 2025-11-14",
    "36 languages", "e.g. '4.5 out of 5 stars41 ratings' or 'Not rated yet'",
    "0 to 7198 INR", "0 to 5", "0 to 12573",
    "0 to 7198", "TRUE / FALSE", "TRUE / FALSE", "TRUE / FALSE"),
  
  pct_missing_raw = c(0, 0, 0, 0, 0, 0, 0, 0, NA, NA, NA, NA, NA, NA),
  
  pct_missing_clean = c(0, 0, 0, 0, 0, 0, 0, 0, 82.77, 82.77, 0, 0, 0, 0),
  
  imputation = c(
    "None", "None", "None", "None", "None", "None", "None", "None",
    "Left as NA — structural missing (83% unrated, imputation not justified)",
    "Left as NA — structural missing",
    "None", "None", "None", "None"),
  
  notes = c(
    "50 entries flagged as short (< 3 chars) — likely legitimate titles",
    "Prefix 'Writtenby:' stripped, word spacing inserted",
    "Prefix 'Narratedby:' stripped, word spacing inserted",
    "Parsed into duration_mins",
    "Parsed from DD-MM-YY, century inferred using cutoff rule",
    "Normalised to title case, underscore replaced with space",
    "Split into rating and rating_count; 'Not rated yet' → NA",
    "'Free' converted to 0, commas stripped, coerced to numeric",
    "Extracted from stars column",
    "Extracted from stars column",
    "Parsed from time column",
    "TRUE for 50 records with nchar(name) < 3",
    "IQR method, k=1.5, 704 flagged",
    "IQR method, k=1.5, 2098 flagged")
)

write.csv(dict, file.path(p_out, "data_dictionary.csv"), row.names = FALSE)
cat("Data dictionary written:", nrow(dict), "variables\n")