## code to prepare `wwbi` dataset goes here
library(dplyr)
library(tidyr)
library(stringr)

wwbi_input <- fetch_prosperitydata360_data(
  "WB.WWBI",
  "WB.WWBI.BI.PWK.PUBS.NO"
) |>
  as_tibble()

wwbi <- wwbi_input |>
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
  rename(
    public_paid_employee = `WB.WWBI.BI.PWK.PUBS.NO`
  ) |>
  mutate(
    year = as.numeric(
      str_sub(year, -4, -1)
    )
  )

wwbi <- wwbi |>
  left_join(
    countryclass,
    by = c("country_code")
  )

usethis::use_data(wwbi, overwrite = TRUE)
