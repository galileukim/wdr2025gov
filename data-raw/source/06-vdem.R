## code to prepare `06-vdem` dataset goes here
# url: https://www.v-dem.net/data/the-v-dem-dataset/country-year-v-dem-fullothers-v15/
# accessed: 4/15/2025
library(readr)
library(janitor)
library(countrycode)

vdem_input <- read_csv(
  here("data-raw", "input", "V-Dem-CY-FullOthers-v15_csv.zip")
)

vdem <- vdem_input |>
  filter(
    year >= 1990
  ) |>
  clean_names() |>
  mutate(
    country_code = countrycode(country_name, origin = "country.name", destination = "wb")
  ) |>
  select(
    country_code,
    year,
    merit_criteria = v2stcritrecadm,
    impartial = v2clrspct
  )

usethis::use_data(vdem, overwrite = TRUE)
