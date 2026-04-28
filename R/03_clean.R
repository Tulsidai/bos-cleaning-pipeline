# cleans the Audible dataset one issue class at a time
# Input: outputs/diagnosed.rds  Output: outputs/cleaned.rds

source("R/00_config.R")

library(stringr)
library(dplyr)
library(lubridate)

# Load
df <- readRDS(file.path(p_out, "diagnosed.rds"))
log_lines <- c(paste("Cleaning started:", Sys.time()),
               paste("Rows at start:", nrow(df)))

# helper to log each stage
log_stage <- function(label, detail = NULL) {
  lines <- c("", paste0("~~ ", label, " ~~"), detail)
  lines
}

# Duplicate check (logged here, no deduplication applied)
n_dupes_full <- sum(duplicated(df))
n_dupes_key  <- sum(duplicated(df[, c("name", "author")]))
log_lines <- c(log_lines, log_stage("Duplicate check",
                                    paste("Full row duplicates:", n_dupes_full,
                                          "| Name + author duplicates:", n_dupes_key,
                                          "| No deduplication applied — confirmed distinct editions")))


# 1. Author - strip prefix, insert spaces between joined words
df <- df |>
  mutate(
    author = str_remove(author, "^Writtenby:"),
    author = str_replace_all(author, "(?<=[a-z])(?=[A-Z])", " "),
    author = str_replace_all(author, "(?<=[A-Z])(?=[A-Z][a-z])", " ")
  )

log_lines <- c(log_lines, log_stage("Author cleaning",
                                    paste("Sample:", paste(head(df$author, 3), collapse = " | "))))


# 2. Narrator - strip prefix, insert spaces between joined words
df <- df |>
  mutate(
    narrator = str_remove(narrator, "^Narratedby:"),
    narrator = str_replace_all(narrator, "(?<=[a-z])(?=[A-Z])", " "),
    narrator = str_replace_all(narrator, "(?<=[A-Z])(?=[A-Z][a-z])", " ")
  )

log_lines <- c(log_lines, log_stage("Narrator cleaning",
                                    paste("Sample:", paste(head(df$narrator, 3), collapse = " | "))))


# 3. Language — title case, replace underscores with spaces
df <- df |>
  mutate(language = str_to_title(str_replace_all(language, "_", " ")))

log_lines <- c(log_lines, log_stage("Language normalisation",
                                    paste("Unique values:", paste(sort(unique(df$language)), collapse = ", "))))


# 4. Price - strip commas, convert Free to 0, coerce to numeric
df <- df |>
  mutate(price = as.numeric(ifelse(price == "Free", "0",
                                   str_remove_all(price, ","))))

log_lines <- c(log_lines, log_stage("Price cleaning",
                                    paste("Free entries converted to 0:", sum(df$price == 0),
                                          "| NAs after coercion:", sum(is.na(df$price)))))


# 5. Stars — split into rating and rating_count, handle "Not rated yet"
df <- df |>
  mutate(
    rating = ifelse(stars == "Not rated yet", NA_real_,
                    as.numeric(str_extract(stars, "^[0-9.]+")))  ,
    rating_count = ifelse(stars == "Not rated yet", NA_integer_,
                          as.integer(str_extract(stars, "(?<=stars)[0-9]+")))
  )

log_lines <- c(log_lines, log_stage("Stars split",
                                    paste("Not rated yet (rating NA):", sum(is.na(df$rating)),
                                          "| Sample ratings:", paste(head(df$rating, 3), collapse = ", "))))


# 6. Time — parse duration string into total minutes as numeric
parse_duration <- function(x) {
  hrs  <- as.numeric(str_extract(x, "\\d+(?= hr)"))
  mins <- as.numeric(str_extract(x, "\\d+(?= min)"))
  hrs  <- ifelse(is.na(hrs), 0, hrs)
  mins <- ifelse(is.na(mins), 0, mins)
  ifelse(x == "Less than 1 minute", 0, hrs * 60 + mins)
}

df <- df |>
  mutate(duration_mins = parse_duration(time))

log_lines <- c(log_lines, log_stage("Time parsing",
                                    paste("NAs after parsing:", sum(is.na(df$duration_mins)),
                                          "| Sample:", paste(head(df$duration_mins, 3), collapse = ", "))))


# 7. Release date — parse DD-MM-YY to proper date, infer century
df <- df |>
  mutate(
    releasedate = as.Date(
      ifelse(as.numeric(str_extract(releasedate, "\\d+$")) >= p_year_cutoff,
             paste0(str_extract(releasedate, "^\\d+-\\d+-"),
                    p_year_old + as.numeric(str_extract(releasedate, "\\d+$"))),
             paste0(str_extract(releasedate, "^\\d+-\\d+-"),
                    p_year_recent + as.numeric(str_extract(releasedate, "\\d+$")))),
      format = "%d-%m-%Y")
  )


log_lines <- c(log_lines, log_stage("Release date parsing",
                                    paste("NAs after parsing:", sum(is.na(df$releasedate)),
                                          "| Range:", min(df$releasedate, na.rm = TRUE), "to", max(df$releasedate, na.rm = TRUE))))


# 8. Name — flag short entries (< 3 chars) for review
df <- df |>
  mutate(short_name_flag = nchar(name) < p_short_name_nchar)

log_lines <- c(log_lines, log_stage("Short name flagging",
                                    paste("Flagged:", sum(df$short_name_flag))))


# 9. Outlier flagging — IQR method on price and duration_mins
iqr_flag <- function(x) {
  q1  <- quantile(x, 0.25, na.rm = TRUE)
  q3  <- quantile(x, 0.75, na.rm = TRUE)
  iqr <- q3 - q1
  x < (q1 - p_outlier_k * iqr) | x > (q3 + p_outlier_k * iqr)
}

df <- df |>
  mutate(
    price_outlier    = iqr_flag(price),
    duration_outlier = iqr_flag(duration_mins)
  )

log_lines <- c(log_lines, log_stage("Outlier flagging",
                                    paste("Price outliers:", sum(df$price_outlier),
                                          "| Duration outliers:", sum(df$duration_outlier))))

# Write log and save

log_lines <- c(log_lines, "", paste("Cleaning completed:", Sys.time()),
               paste("Rows at end:", nrow(df)))

writeLines(log_lines, file.path(p_log, "cleaning_log.txt"))
cat(paste(log_lines, collapse = "\n"), "\n")

saveRDS(df, file.path(p_out, "cleaned.rds"))