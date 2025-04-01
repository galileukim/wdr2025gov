## code to prepare `ccpcnc` dataset goes here
library(readr)
library(dplyr)
library(countrycode)
library(stringr)
library(here)

# accessed in: 4/1/2025
src <- "https://www.comparativeconstitutionsproject.org/data/ccpcnc_v5.zip"
lcl <- "data-raw/comparativeconstitutions"

if (!file.exists(lcl)) {
  tmp <- tempfile(fileext = ".zip")
  download.file(src, tmp, method = "wininet")

  dir.create(lcl)
  unzip(tmp, exdir = lcl, junkpaths = TRUE)
}

constitution_input <- read_csv(
  here(lcl, "ccpcnc_v5.csv"),
  col_select = c(
    cowcode, country, year, systid, systyear,
    evntid, evnttype,
    civil, civil_article, civil_comments
  )
)

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
    )
  ) |>
  rename_at(
    vars(starts_with("civil")),
    \(string) str_replace(string, "civil", "merit")
  ) |>
  select(
    country_code,
    year,
    everything()
  )

usethis::use_data(
  constitution,
  overwrite = TRUE
)
