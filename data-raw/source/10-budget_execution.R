## code to prepare `10-budget_execution` dataset goes here
# source: https://data360.worldbank.org/en/indicator/WB_WDI_GF_XPD_BUDG_ZS
# accessed in: 4/21/2025
library(readr)
library(tidyr)

budget_execution_input <- read_csv(
  here("data-raw", "input", "wbdata360", "WB_WDI_GF_XPD_BUDG_ZS_WIDEF.csv")
)

budget_execution <- budget_execution_input |>
  pivot_longer(
    cols = c(`2004`:`2022`),
    names_to = "year",
    values_to = "budget_execution_rate"
  ) |>
  select(
    country_code = REF_AREA_ID,
    year,
    budget_execution_rate
  )

usethis::use_data(budget_execution, overwrite = TRUE)
