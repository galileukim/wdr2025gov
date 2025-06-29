## code to prepare `15-enterprise_surveys` dataset goes here
library(readr)
library(tidyr)
library(here)

# last accessed: 6/29/2025
enterprise_surveys_input <- read_csv(
  "https://data360files.worldbank.org/data360-data/data/WB_ES/WB_ES_T_MGMT1.csv"
)

enterprise_surveys <- enterprise_surveys_input |>
  # extract indicators only forthe economy as a whole
  filter(
    COMP_BREAKDOWN_1_LABEL == "Total" &
      COMP_BREAKDOWN_2_LABEL == "Total" &
      COMP_BREAKDOWN_3_LABEL == "Total" &
      !is.na(OBS_VALUE)
  ) |>
  pivot_wider(
    id_cols = c(REF_AREA, TIME_PERIOD),
    values_from = OBS_VALUE,
    names_from = INDICATOR
  ) |>
  select(
    country_code = REF_AREA,
    year = TIME_PERIOD,
    management_practices_index = WB_ES_T_MGMT1
  )

usethis::use_data(enterprise_surveys, overwrite = TRUE)
