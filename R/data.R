#' Comparative Constitutions Project
#'
#' The Comparative Constitutions Project produces comprehensive data about the world’s constitutions.
#'
#' @format ## `constitution`
#' A data frame with 16,717 rows and 13 columns:
#' \describe{
#'   \item{country_code}{Country WB code}
#'   \item{year}{Year}
#'   \item{type_constitution}{Title of the constitutional document}
#'   \item{cowcode}{Conflicts of War Code}
#'   \item{country}{Country Name}
#'   \item{systid}{Constitution Unique ID}
#'   \item{systyear}{Year of constitution promulgation}
#'   \item{evntid}{Year of constitutional event}
#'   \item{evnttype}{Type of constitutional event}
#'   \item{merit}{Constitution include provisions for the meritocratic recruitment of civil servants (e.g. exams or credential requirements).}
#'   \item{merit_article}{Article of the constitution where meritocratic recruitment is enshrined}
#'   \item{merit_comments}{Comments on meritocratic recruitment}
#'   \item{region}{WB Region}
#'   ...
#' }
#' @source <https://comparativeconstitutionsproject.org/download-data/#>
"constitution"

#' World Bank Country and Lending Groups
#'
#' This dataset is produced by the World Bank Group to classify countries as to their income levels and other groups.
#'
#' @format ## `countryclass`
#' A data frame with 267 rows and 4 columns:
#' \describe{
#'   \item{country_code}{Country WB code}
#'   \item{economy}{Country name}
#'   \item{region}{WB region}
#'   \item{income_group}{WB income classification}
#'   ...
#' }
#' @source <https://comparativeconstitutionsproject.org/download-data/#>
"countryclass"
