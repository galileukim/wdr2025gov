## code to prepare `labor` dataset goes here
library(dplyr)
library(tidyr)
library(janitor)
library(stringr)

labor_force_input <- fetch_prosperitydata360_data(
  "WB.EDSTATS",
  "WB.EDSTATS.SL.TLF.TOTL.IN"
) |>
  as_tibble()

labor_force <- labor_force_input |>
  # remove duplicated indicators
  distinct(COUNTRY_CODE, CAL_YEAR, .keep_all = TRUE) |>
  pivot_wider_data360() |>
  rename(
    total_labor_force = `WB.EDSTATS.SL.TLF.TOTL.IN`
  )

unemployment_input <- fetch_prosperitydata360_data(
  "UN.SDG",
  "UN.SDG.SL.UEM.TOTL.NE.ZS"
)|>
  as_tibble()

unemployment <- unemployment_input |>
  # remove duplicated indicators
  distinct(COUNTRY_CODE, CAL_YEAR, .keep_all = TRUE) |>
  pivot_wider_data360() |>
  rename(
    unemployment_rate = `UN.SDG.SL.UEM.TOTL.NE.ZS`
  )

unemployment <- unemployment_input |>
  pivot_wider_data360() |>
  rename(
    public_paid_employee = `WB.WWBI.BI.PWK.PUBS.NO`
  )

labor <- labor_force |>
  left_join(
    unemployment,
    by = c("country_code", "year")
  )

usethis::use_data(labor, overwrite = TRUE)
