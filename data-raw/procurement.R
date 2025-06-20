library(dplyr)
library(here)
library(readxl)
library(janitor)

# Load data
# this code was transalted from Stata with the assistance of ChatGPT
data <- read_excel(here("data-raw", "input", "procurement", "Master_Procurement_Data.xlsx"), sheet = "all data") |>
  rename(
    Q45Renegotiation10 = "Q.45 - Renegotiation 10"
  )

# -----------------------------
# Transform Transparency Variables
# -----------------------------
data <- data %>%
  mutate(across(c(Q20AwardLaw, Q20ContractLaw, Q20DocumentsLaw, Q20ModelsLaw, Q20NoticeLaw, Q20PlansLaw,
                  Q45FeaturesDisclosureonly, Q20AwardPractice, Q20ContractPractice, Q20Documentspractice,
                  Q20ModelsPractice, Q20NoticePractice, Q20PlansPractice, Q50RenegPublicity),
                ~ recode(., "No" = 0, "Yes" = 1) %>% as.numeric()))

# -----------------------------
# Transform Competition Variables
# -----------------------------
data <- data %>%
  mutate(across(c(Q14Open, Q15Prequalification, Q18Dividing, Q21Preparation, Q28BidOpening,
                  Q30Standstill, Q15aPrequalificationprocedu, Bid_opening_p, complaints_award_first_suspensio),
                ~ recode(., "No" = 0, "Yes" = 1) %>% as.numeric())) %>%
  mutate(Q16Openpractice = case_when(
    Q16Openpractice %in% c("Open is default", "Open is most common") ~ 1,
    Q16Openpractice == "Other" ~ 0,
    TRUE ~ NA_real_
  )) %>%
  mutate(across(c(abuse_PE_advertisement, Q18a),
                ~ case_when(
                  . %in% c("Very Rarely", "Rarely") ~ 1,
                  . %in% c("Occasionally", "Often", "Very Often") ~ 0,
                  TRUE ~ NA_real_
                )))

# -----------------------------
# Transform Limits to Exclusion Variables
# -----------------------------
data <- data %>%
  mutate(across(c(Q22ContentDocs, Q38Abnormallylowbids, Q39Errors, Q39cErrorspractice),
                ~ recode(., "No" = 0, "Yes" = 1) %>% as.numeric())) %>%
  mutate(Q25Clarifications = case_when(
    Q25Clarifications == "The procuring entity addresses all clarifications in a public meeting." ~ 1,
    Q25Clarifications %in% c("The procuring entity will answer, and it is always required to communicate the answer to all other bidders too.",
                             "The procuring entity will answer, but it is not always required to communicate the answer to all other bidders.",
                             "The procuring entity will only answer to the relevant bidder.", "Other") ~ 0,
    TRUE ~ NA_real_
  )) %>%
  mutate(Q35AwardCriteria = case_when(
    Q35AwardCriteria == "Price" ~ 1,
    Q35AwardCriteria %in% c("Price and qualitative elements", "Discretion of the Procuring Entity") ~ 0,
    TRUE ~ NA_real_
  )) %>%
  mutate(across(c(abuse_PE_tech_specifications, clarification_circumvent_informa, abuse_COMP_low_bids10),
                ~ case_when(
                  . %in% c("Very Rarely", "Rarely") ~ 1,
                  . %in% c("Occasionally", "Often", "Very Often") ~ 0,
                  TRUE ~ NA_real_
                ))) %>%
  mutate(eval_price_only_frequency = case_when(
    eval_price_only_frequency %in% c("Often", "Very Often") ~ 1,
    eval_price_only_frequency %in% c("Very Rarely", "Rarely", "Occasionally") ~ 0,
    TRUE ~ NA_real_
  ))

# -----------------------------
# Transform Integrity Variables
# -----------------------------
data <- data %>%
  mutate(across(c(Q45Additional10, Q58Paymentbylaw, Q58eLatePaymentinterest),
                ~ recode(., "No" = 0, "Yes" = 1) %>% as.numeric())) %>%
  mutate(Q12Certificate = case_when(
    Q12Certificate %in% c("Yes", "Yes, there is a specific budget allocation", "Yes, a certificate is required") ~ 1,
    Q12Certificate == "No" ~ 0,
    TRUE ~ NA_real_
  ),
  Q23Subcontracting = case_when(
    Q23Subcontracting == "Features, disclosure, liability." ~ 1,
    Q23Subcontracting %in% c("No", "Liability.", "Features.", "Features, liability.",
                             "Features, disclosure.", "Disclosure.", "Disclosure, liability.") ~ 0,
    TRUE ~ NA_real_
  ),
  Q45Renegotiation10 = case_when(
    Q45Renegotiation10 %in% c("Features, disclosure, liability.", "Liability.", "Features.",
                              "Features, liability.", "Features, disclosure.", "Disclosure.",
                              "Disclosure, liability.") ~ 1,
    Q45Renegotiation10 == "No" ~ 0,
    TRUE ~ NA_real_
  )) %>%
  mutate(across(c(Q13, abuse_COMP_subcontractors, abuse_COMP_renegotiation),
                ~ case_when(
                  . %in% c("Very Rarely", "Rarely") ~ 1,
                  . %in% c("Occasionally", "Often", "Very Often") ~ 0,
                  TRUE ~ NA_real_
                ))) %>%
  mutate(across(c(Q58c, Q58f),
                ~ case_when(
                  . %in% c("Often", "Very Often") ~ 1,
                  . %in% c("Very Rarely", "Rarely", "Occasionally") ~ 0,
                  TRUE ~ NA_real_
                )))

# -----------------------------
# Transform Quality and Integrity of Process Variables
# -----------------------------
data <- data %>%
  mutate(Overrun = recode(Overrun,
                          "Very Often" = 0.05,
                          "Often" = 0.3,
                          "Occasionally" = 0.625,
                          "Rarely" = 0.825,
                          "Very Rarely" = 0.95) %>% as.numeric()) %>%
  mutate(across(c(Low_quality, Favoritism, Corruption, Collusion, No_competition),
                ~ recode(.,
                         "Very Often" = 0.95,
                         "Often" = 0.7,
                         "Occasionally" = 0.375,
                         "Rarely" = 0.175,
                         "Very Rarely" = 0.05) %>% as.numeric()))

# -----------------------------
# Construct Indexes
# -----------------------------
procurement <- data %>%
  rowwise() %>%
  mutate(
    Transparency_l = mean(c_across(c(Q20AwardLaw, Q20ContractLaw, Q20DocumentsLaw, Q20ModelsLaw,
                                     Q20NoticeLaw, Q20PlansLaw, Q45FeaturesDisclosureonly)), na.rm = TRUE),
    Transparency_p = mean(c_across(c(Q20AwardPractice, Q20ContractPractice, Q20Documentspractice,
                                     Q20ModelsPractice, Q20NoticePractice, Q20PlansPractice, Q50RenegPublicity)), na.rm = TRUE),

    Competition_l = mean(c_across(c(Q14Open, Q15Prequalification, Q18Dividing, Q21Preparation,
                                    Q28BidOpening, Q30Standstill)), na.rm = TRUE),
    Competition_p = mean(c_across(c(Q16Openpractice, Q15aPrequalificationprocedu, Q18a, abuse_PE_advertisement,
                                    Bid_opening_p, complaints_award_first_suspensio)), na.rm = TRUE),

    Limits_to_Exclusion_l = mean(c_across(c(Q22ContentDocs, Q25Clarifications, Q35AwardCriteria,
                                            Q38Abnormallylowbids, Q39Errors)), na.rm = TRUE),
    Limits_to_Exclusion_p = mean(c_across(c(abuse_PE_tech_specifications, clarification_circumvent_informa,
                                            eval_price_only_frequency, abuse_COMP_low_bids10, Q39cErrorspractice)), na.rm = TRUE),

    Integrity_of_contract_l = mean(c_across(c(Q12Certificate, Q23Subcontracting, Q45Additional10,
                                              Q45Renegotiation10, Q58Paymentbylaw, Q58eLatePaymentinterest)), na.rm = TRUE),
    Integrity_of_contract_p = mean(c_across(c(Q13, abuse_COMP_subcontractors, Q55AdditionalWorksProcedur,
                                              abuse_COMP_renegotiation, Q58c, Q58f)), na.rm = TRUE),

    laws = sum(c_across(c(Transparency_l, Competition_l, Limits_to_Exclusion_l, Integrity_of_contract_l)), na.rm = TRUE),
    practices = sum(c_across(c(Transparency_p, Competition_p, Limits_to_Exclusion_p, Integrity_of_contract_p)), na.rm = TRUE)
  ) %>%
  ungroup()


# outcome variables -------------------------------------------------------
# quality
procurement <- procurement |>
  mutate(
    across(
      c(Time, Overrun, Low_quality),
      scale,
      .names = "{col}_z"
    ),
    across(
      c(Favoritism, Corruption, Collusion, No_competition),
      scale,
      .names = "{col}_z"
    )
  ) |>
  rowwise() |>
  mutate(
    quality = mean(c_across(c(Time_z, Overrun_z, Low_quality_z)), na.rm = TRUE),
    quality = 1 - quality,
    integrity = mean(c_across(c(Favoritism_z, Corruption_z, Collusion_z, No_competition_z)), na.rm = TRUE),
    integrity = -integrity
  ) |>
  ungroup() |>
  filter(
    Economy != ""
  )

# write-out ---------------------------------------------------------------
# trim out excess
procurement <- procurement |>
  clean_names() |>
  select(
    economy,
    country_code = countrycode,
    loggdp,
    transparency_l,
    transparency_p,
    competition_l,
    competition_p,
    integrity_of_contract_l,
    integrity_of_contract_p,
    limits_to_exclusion_l,
    limits_to_exclusion_p,
    laws,
    practices,
    quality,
    integrity
  )

usethis::use_data(procurement, overwrite = TRUE)
