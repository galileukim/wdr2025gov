## code to prepare `09-open_budget` dataset goes here
# source: https://data360.worldbank.org/en/indicator/IBP_OBS_OVERSIGHT_OBI
# extracted on 4/21/2025
library(readr)
library(tidyr)

open_budget_input <- read_csv(
  here("data-raw", "input", "wbdata360", "IBP_OBS_OVERSIGHT_OBI_WIDEF.csv")
)

open_budget <- open_budget_input |>
  pivot_longer(
    cols = c(`2017`:`2023`),
    names_to = "year",
    values_to = "oversight_score"
  ) |>
  select(
    country_code = REF_AREA_ID,
    year,
    oversight_score
  )

usethis::use_data(open_budget, overwrite = TRUE)
