## code to prepare `wwbi` dataset goes here
library(dplyr)
library(readxl)
library(janitor)
library(tidyr)
library(stringr)

# accessed 2025.04.11
wwbi_input <- fetch_prosperitydata360_data(
  "WB.WWBI",
  "WB.WWBI.BI.EMP.TOTL.PB.ZS"
) |>
  as_tibble()

wwbi_occupation_input <- read_xlsx(
  here("data-raw", "input", "wwbi", "wwbi_occupation.xlsx")
)

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
    share_public_sector = `WB.WWBI.BI.EMP.TOTL.PB.ZS`
  ) |>
  mutate(
    year = as.numeric(
      str_sub(year, -4, -1)
    )
  )

wwbi_occupation <- wwbi_occupation_input |>
  select(
    country_code = ccode,
    everything()
  ) |>
  clean_names()

wwbi <- wwbi |>
  classify_income_group()

usethis::use_data(wwbi, overwrite = TRUE)
usethis::use_data(wwbi_occupation, overwrite = TRUE)
