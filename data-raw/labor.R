## code to prepare `labor` dataset goes here
library(dplyr)
library(tidyr)
library(janitor)
library(stringr)

pivot_wider_data360 <- function(data){
  data |>
    select(
      country_code = COUNTRY_CODE,
      indicator_id = INDICATOR_ID,
      year = CAL_YEAR,
      value = IND_VALUE
    ) |>
    filter(
      country_code != "AGGREGATE"
    ) |>
    pivot_wider(
      names_from = indicator_id,
      values_from = value
    ) |>
    mutate(
      year = as.numeric(
        str_sub(year, -4, -1)
      )
    )
}

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
