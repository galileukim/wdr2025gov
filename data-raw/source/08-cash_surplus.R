## code to prepare `cash_surplus` dataset goes here
library(stringr)

cash_surplus_input <- fetch_prosperitydata360_data(
  "IMF.GFSSSUC",
  "IMF.GFSSSUC.GXOB_G14_CA_GDP_PT"
) |>
  as_tibble()

cash_surplus <- cash_surplus_input |>
  filter(
    ATTRIBUTE_1 == "Budgetary central government"
  ) |>
  # remove duplicated entries
  distinct(
    COUNTRY_CODE, CAL_YEAR, IND_VALUE,
    .keep_all = TRUE
  ) |>
  pivot_wider_data360() |>
  rename(
    cash_surplus_pct_gdp = IMF.GFSSSUC.GXOB_G14_CA_GDP_PT
  )

usethis::use_data(cash_surplus, overwrite = TRUE)
