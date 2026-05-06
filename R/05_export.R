# Exports the cleaned dataset in four formats with labels preserved.
# .rds, .sav, .dta, .xlsx

source("R/00_config.R")

library(haven)
library(openxlsx)

# Load
df <- readRDS(file.path(p_out, "cleaned.rds"))
dict <- read.csv(file.path(p_out, "data_dictionary.csv"))

#RDS already done in 03

# SPSS (.sav)

# attach variable labels from data dictionary
labels <- setNames(dict$label, dict$variable)
labels <- labels[names(df)]
for (v in names(labels)) attr(df[[v]], "label") <- labels[[v]]

write_sav(df, file.path(p_out, "cleaned.sav"))
cat("SAV written\n")

# Stata (.dta)
write_dta(df, file.path(p_out, "cleaned.dta"))
cat("DTA written\n")

# Excel (.xlsx) — data on sheet 1, data dictionary on sheet 2
wb <- createWorkbook()

addWorksheet(wb, "data")
writeData(wb, "data", df)

addWorksheet(wb, "data_dictionary")
writeData(wb, "data_dictionary", dict)

saveWorkbook(wb, file.path(p_out, "cleaned.xlsx"), overwrite = TRUE)
cat("XLSX written\n")

cat("\nAll exports complete.\n")