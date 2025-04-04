## code to prepare `gsps_macro` dataset goes here
# set-up ------------------------------------------------------------------
library(readxl)
library(dplyr)
library(janitor)
library(labelled)
library(stringr)
library(sinew)
library(here)

# read-in data ------------------------------------------------------------
# circumvent firewall for download
options(download.file.method ="curl", download.file.extra ="-k -L")

lcl <-  here("data-raw", "input", "gsps_macro.xlsx")

if(!file.exists(lcl)){
  download.file(
    "https://www.globalsurveyofpublicservants.org/sites/default/files/2023-11/GSPS_Indicators_Dataset_11_10_23.xlsx",
    destfile = here("data-raw", "input", "gsps_macro.xlsx"),
    overwrite = TRUE
  )
}

gsps_input <- read_xlsx(
  here("data-raw", "input", "gsps_macro.xlsx"),
  sheet = 1
  ) |>
  clean_names()

gsps <- gsps_input |>
  mutate(
    topic_group = case_when(
      str_detect(topic, "(?i)Recruitment") ~ "Recruitment",
      str_detect(topic, "(?i)Performance") ~ "Performance"
    ),
    indicator_group = case_when(
      str_detect(question_text, "(?i)written exam") & !str_detect(question_text, "skewed") ~ "Recruitment standard: written examination",
      indicator %in% c("Politicization", "Criteria (political connections)") & str_detect(question_text, "first job|hire|hiring") ~ "Recruitment standard: political connections",
      # indicator == "Criteria (professional experience)" ~ "Recruitment standard: professional experience",
      # indicator == "Criteria (education)" ~ "Recruitment standard: education",
      indicator == "Assessment (none)" ~ "Recruitment standard: none",
      indicator %in% c("Performance evaluation (performance evaluated)", "Performance evaluation (last 2 years)", "Performance evaluated") ~ "Performance standard: evaluation",
      indicator == "Performance evaluation (promotion)" | (topic_group == "Performance" & str_detect(question_text, "promotion") & !str_detect(question_text, "transparent and fair")) ~ "Performance standard: promotion",
      T ~ "Other"
    )
  ) |>
  # add country codes
  left_join(
    countryclass,
    by = c("country" = "economy")
  ) |>
  select(
    country_code,
    economy = country,
    year,
    region,
    group,
    mean,
    lower_ci,
    upper_ci,
    scale,
    response_rate
  )

usethis::use_data(gsps, overwrite = TRUE)
