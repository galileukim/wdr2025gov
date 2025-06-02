## code to prepare `12-pefa` dataset goes here
library(readr)
library(tidyr)
library(here)

# last accessed: 4/23/2025
open_budget_input <- read_csv(
  "https://data360files.worldbank.org/data360-data/data/IBP_OBS/IBP_OBS.csv"
)

open_budget <- open_budget_input |>
  pivot_wider(
    id_cols = c(REF_AREA_ID, TIME_PERIOD),
    values_from = OBS_VALUE,
    names_from = INDICATOR_ID
  ) |>
  select(
    country_code = REF_AREA_ID,
    year = TIME_PERIOD,
    budget_transparency_score = IBP_OBS_OBI,
    budget_transparency_rank = IBP_OBS_RANK,
    supreme_audit_oversight_score = IBP_OBS_SAI_OBI,
    oversight_score = IBP_OBS_OVERSIGHT_OBI,
    legislative_oversight_score = IBP_OBS_LEG_OBI,
    public_participation_score = IBP_OBS_PUB_ENG
  )

usethis::use_data(open_budget, overwrite = TRUE)
