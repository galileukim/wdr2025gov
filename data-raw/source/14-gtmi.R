## code to prepare `gtmi` dataset goes here
# set-up ------------------------------------------------------------------
library(readxl)
library(dplyr)
library(janitor)
library(here)

# read-in -----------------------------------------------------------------
# circumvent firewall for download
options(download.file.method ="curl", download.file.extra ="-k -L")

lcl <- here("data-raw", "input", "gtmi", "gtmi.xlsx")

# accessed in: 6/25/2025
if(!file.exists(lcl)){
  download.file(
    "https://datacatalogfiles.worldbank.org/ddh-published/0037889/DR0089805/WBG_GovTech%20Dataset_Oct2022.xlsx",
    destfile = here("data-raw", "input", "gtmi", "gtmi.xlsx"),
    overwrite = TRUE
  )
}

gtmi_input <- read_xlsx(
  here("data-raw", "input", "gtmi", "gtmi.xlsx"),
  sheet = "CG_GTMI_Data"
) |>
  clean_names() |>
  filter(year == 2022)

# process -----------------------------------------------------------------
gtmi <- gtmi_input |>
  select(
    country_code = code,
    hrmis_year_est = i_9_3,
    egp_year_est = i_12_3,
    fmis_year_est = i_5_5
  ) |>
  mutate(
    across(
      c(ends_with("est")),
      as.numeric
    )
  )

# write-out ---------------------------------------------------------------
usethis::use_data(gtmi, overwrite = TRUE)
