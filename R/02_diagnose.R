# diagnostics on the raw loaded data
# Findings are written to a log and charts saved to outputs/logs/

source("R/00_config.R")

library(naniar)
library(visdat)
library(ggplot2)

# load
df <- readRDS(file.path(p_out, "raw_loaded.rds"))

# missingness

miss_summary <- miss_var_summary(df)

#type overview

col_types <- sapply(df, class)

#Duplicates
n_dupes_full <- sum(duplicated(df))
n_dupes_key <- sum(duplicated(df[, c("name", "author")]))

# Range checks
n_free <- sum(df$price == "Free")
n_not_rated <- sum(df$stars == "Not rated yet")
n_short_name <- sum(nchar(df$name) < p_short_name_nchar)

# empty string checks
empty_strings <- colSums(df == "")

# log

log_lines <- c(
  paste("Diagnostics completed:", Sys.time()),
  "",
  "~~ Missingness ~~",
  capture.output(print(miss_summary)),
  "",
  "~~ Column types ~~",
  capture.output(print(col_types)),
  "",
  "~~ Duplicates ~~",
  paste("Full row duplicates:", n_dupes_full),
  paste("Duplicates on name + author:", n_dupes_key),
  "",
  "~~ Known issues ~~",
  paste("Free price entries:", n_free),
  paste("Not rated yet (stars):", n_not_rated),
  paste("Short names (< 3 chars):", n_short_name),
  "",
  "~~ Empty strings ~~",
  capture.output(print(empty_strings))
)

writeLines(log_lines, file.path(p_log, "diagnostics_log.txt"))
cat(paste(log_lines, collapse = "\n"), "\n")



# CHARTS

# Recode known non-NA placeholders to NA for visualisation only
df_vis <- df
df_vis$stars[df_vis$stars == "Not rated yet"] <- NA
df_vis$price[df_vis$price == "Free"]          <- NA

# Missingness by variable
p_miss <- gg_miss_var(df_vis, show_pct = TRUE) +
  labs(title = "Missingness by variable (incl. placeholders)", x = NULL) +
  theme_minimal()

ggsave(file.path(p_log, "missingness.png"), p_miss, width = 8, height = 5)

# Type overview
p_types <- vis_dat(df_vis)
ggsave(file.path(p_log, "type_overview.png"), p_types, width = 10, height = 6)

# Missingness by variable
p_miss <- gg_miss_var(df, show_pct = TRUE) +
  labs(title = "Missingness by variable", x = NULL) +
  theme_minimal()

ggsave(file.path(p_log, "missingness.png"), p_miss, width = 8, height = 5)

# Type overview
png(file.path(p_log, "type_overview.png"), width = 800, height = 500)
vis_dat(df)
dev.off()