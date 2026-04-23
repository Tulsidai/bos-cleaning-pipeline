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
  lines <- c("", paste0("── ", label, " ──"), detail)
  lines
}

# 1. Author — strip prefix, insert spaces between joined words
df <- df |>
  mutate(
    author = str_remove(author, "^Writtenby:"),
    author = str_replace_all(author, "(?<=[a-z])(?=[A-Z])", " "),
    author = str_replace_all(author, "(?<=[A-Z])(?=[A-Z][a-z])", " ")
  )

log_lines <- c(log_lines, log_stage("Author cleaning",
                                    paste("Sample:", paste(head(df$author, 3), collapse = " | "))))