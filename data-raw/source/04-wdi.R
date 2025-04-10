## code to prepare `wdi` dataset goes here
wdi_gdp_pc_input <- fetch_prosperitydata360_data(
  "WB.WDI",
  "WB.WDI.NY.GDP.PCAP.PP.KD"
) |>
  as_tibble()

wdi_gdp_pc <- wdi_gdp_pc_input |>
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
    gdp_per_capita_ppp_2017 = `WB.WDI.NY.GDP.PCAP.PP.KD`
  ) |>
  mutate(
    year = as.numeric(
      str_sub(year, -4, -1)
    )
  )

usethis::use_data(wdi_gdp_pc, overwrite = TRUE)
