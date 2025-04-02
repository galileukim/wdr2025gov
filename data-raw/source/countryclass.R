## code to prepare `countryclass` dataset goes here
library(readxl)

countryclass_input <- readxl::read_xlsx(
  here("data-raw", "input", "CLASS.xlsx")
)

countryclass <- countryclass_input |>
  select(
    economy = Economy,
    country_code = Code,
    region = Region,
    income_group = `Income group`
  )

usethis::use_data(countryclass, overwrite = TRUE)
