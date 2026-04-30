# Exports the cleaned dataset in four formats with labels preserved.
# .rds, .sav, .dta, .xlsx

source("R/00_config.R")

library(haven)
library(openxlsx)

# Load
df <- readRDS(file.path(p_out, "imputed.rds"))
dict <- read.csv(file.path(p_out, "data_dictionary.csv"))

# RDS
saveRDS(df, file.path(p_out, "cleaned.rds"))
cat("RDS written\n")

# SPSS (.sav)
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