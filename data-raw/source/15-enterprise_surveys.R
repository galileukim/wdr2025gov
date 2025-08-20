## code to prepare `15-enterprise_surveys` dataset goes here
library(readr)
library(tidyr)
library(stringr)
library(haven)
library(dplyr)
library(readxl)
library(survey)
library(countrycode)
library(here)

# last accessed: 6/29/2025
enterprise_surveys_input <- read_csv(
  "https://data360files.worldbank.org/data360-data/data/WB_ES/WB_ES_T_MGMT1.csv"
)

enterprise_surveys <- enterprise_surveys_input |>
  # extract indicators only for the economy as a whole
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

# supplement to enterprise surveys: procurement payment
enterprise_surveys_procurement_input <- read_dta(
  here(
    "data-raw", "input",
    "enterprise-surveys",
    "ES-Indicators-Database-Global-Methodology_May_5_2025.dta"
  )
)

government_payment_deadline <- read_excel(
  here(
    "data-raw", "input",
    "enterprise-surveys",
    "procurement_payment_deadline.xlsx"
  )
)

# Clean and prepare data
enterprise_surveys_procurement <- enterprise_surveys_procurement_input %>%
  filter(!is.na(strata)) %>%
  select(country, year, reg9, wt, strata, idstd) %>%
  # reg9 corresponds to the amount of days to get paid by the firm
  filter(!is.na(reg9)) %>%
  mutate(country = str_remove(country, "\\d{4}$")) %>%
  left_join(government_payment_deadline, by = c("country" = "country_name")) %>%

  # Payment calculations
  mutate(
    paid_on_time = if_else(reg9 <= gov_payment_deadline, 1, 0, missing = NA_real_),
    days_over    = pmax(reg9 - gov_payment_deadline, 0)
  ) %>%

  # Remove missing values after computation
  filter(!is.na(paid_on_time))

# Survey design
design_procurement <- svydesign(
  ids = ~idstd,
  weights = ~wt,
  data = enterprise_surveys_procurement,
  nest = TRUE,
  single.unit = "adjust"
)

# Compute average by country
enterprise_surveys_procurement <- svyby(
  ~paid_on_time,
  ~country,
  design_procurement,
  svymean,
  na.rm = TRUE
) %>%
  as_tibble() %>%
  rename(
    share_paid_on_time   = paid_on_time,
    share_paidontime_se  = se
  ) |>
  left_join(
    government_payment_deadline |> select(-deadline_binary),
    by = c("country" = "country_name")
  ) |>
  mutate(
    country_code = countrycode(
      country,
      origin = "country.name.en.regex",
      destination = "wb"
    ),
    year = 2025
  ) |>
  select(
    country_code,
    year,
    everything(),
    -country
  )

usethis::use_data(enterprise_surveys, overwrite = TRUE)
usethis::use_data(enterprise_surveys_procurement, overwrite = TRUE)
