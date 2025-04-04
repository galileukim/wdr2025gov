#' Comparative Constitutions Project
#'
#' The Comparative Constitutions Project produces comprehensive data about the world’s constitutions.
#'
#' @format ## `constitution`
#' A data frame with 16,717 rows and 13 columns:
#' \describe{
#'   \item{country_code}{World Bank country code}
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
#'   \item{country_code}{World Bank country code}
#'   \item{economy}{Country name}
#'   \item{region}{World Bank region}
#'   \item{income_group}{World Bank income classification}
#'   ...
#' }
#' @source <https://comparativeconstitutionsproject.org/download-data/#>
"countryclass"

#' @title Global Survey of Public Servants
#' @description This dataset is a set of surveys of public servants produced by the Bureaucracy Lab at the World Bank and partnering academic institutions.
#' @format A data frame with 229467 rows and 10 variables:
#' \describe{
#'   \item{\code{country_code}}{World Bank country code}
#'   \item{\code{economy}}{character Country name}
#'   \item{\code{year}}{double Year}
#'   \item{\code{region}}{character World Bank region}
#'   \item{\code{group}}{character Group of respondents}
#'   \item{\code{mean}}{double Average for the group. See scale}
#'   \item{\code{lower_ci}}{double Lower bound for the average}
#'   \item{\code{upper_ci}}{double Upper bound for the average}
#'   \item{\code{scale}}{character Scale for the average}
#'   \item{\code{response_rate}}{double Response rate for the group}
#'}
#' @source <https://www.globalsurveyofpublicservants.org/data-downloads>
"gsps"
