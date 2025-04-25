## code to prepare `11-women` dataset goes here
library(readr)
library(tidyr)
library(here)

# last accessed: 4/25/2025
women_ministry_input <- read_csv(
  "https://data360files.worldbank.org/data360-data/data/WB_GS/WB_GS_SG_GEN_MNST_ZS.csv"
)

women_ministry <- women_ministry_input |>
  # data only starts being collected in 2005
  filter(
    TIME_PERIOD >= 2005
  ) |>
  pivot_wider(
    id_cols = c(REF_AREA_ID, TIME_PERIOD),
    values_from = OBS_VALUE,
    names_from = INDICATOR_ID
  ) |>
  select(
    country_code = REF_AREA_ID,
    year = TIME_PERIOD,
    prop_women_ministry = WB_GS_SG_GEN_MNST_ZS
  )

usethis::use_data(women_ministry, overwrite = TRUE)
