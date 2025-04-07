## code to prepare `ccpcnc` dataset goes here
library(readr)
library(dplyr)
library(countrycode)
library(purrr)
library(stringr)
library(here)

# accessed in: 4/1/2025
# constitutional characteristics
src <- c(
  "https://www.comparativeconstitutionsproject.org/data/ccpcnc_v5.zip",
  "https://comparativeconstitutionsproject.org/data/ccpcce_v1_3.zip"
)

lcl <- "data-raw/input/comparativeconstitutions"

if (!file.exists(lcl)) {
  dir.create(lcl)

  src |>
    map(
      \(src){
        tmp <- tempfile(fileext = ".zip")
        files <- download.file(src, tmp, method = "wininet")

        unzip(tmp, exdir = lcl, junkpaths = TRUE)
      }
    )
  # tmp <- tempfile(fileext = ".zip")
  # files <- src |>
  #   map(
  #     \(x) download.file(x, tmp, method = "curl")
  #   )
  #
  # dir.create(lcl)
  # tmp |>
  #   map(
  #     \(x) unzip(tmp, exdir = lcl, junkpaths = TRUE)
  #   )
}

# constitutional events
# src <-
# lcl <- "data-raw/input/comparativeconstitutions"
#
# constitution_input <- read_csv(
#   here(lcl, "ccpcnc_v5.csv"),
#   col_select = c(
#     cowcode, country, year, systid, systyear,
#     evntid, evnttype,
#     doctit,
#     civil, civil_article, civil_comments
#   )
# )

constitution <- constitution_input |>
  filter(
    year >= 1880
  ) |>
  mutate(
    country_code = countrycode(
      cowcode,
      origin = "cown",
      destination = "wb"
    ),
    region = countrycode(
      cowcode,
      origin = "cown",
      destination = "region"
    ),
    # reclassify meritocratic
    civil = case_when(
      civil == 1 ~ "yes",
      civil == 2 ~ "no",
      civil == 96 ~ "other",
      T ~ NA_character_
    ),
    doctit = case_when(
      doctit == 1 ~ "Constitution",
      doctit == 2 ~ "Fundamental Law",
      doctit == 3 ~ "Basic Law",
      doctit == 96 ~ "Other",
      doctit == 98 ~ NA_character_
    )
  ) |>
  rename_at(
    vars(starts_with("civil")),
    \(string) str_replace(string, "civil", "merit")
  ) |>
  select(
    country_code,
    year,
    type_constitution = doctit,
    everything()
  )

usethis::use_data(
  constitution,
  overwrite = TRUE
)
