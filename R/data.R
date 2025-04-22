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
#'   \item{\code{category}}{character Category name}
#'   \item{\code{year}}{double Year}
#'   \item{\code{region}}{character World Bank region}
#'   \item{\code{income_group}}{character World Bank income group}
#'   \item{\code{respondent_group}}{character Respondent group}
#'   \item{\code{topic_group}}{character Topic grouping}
#'   \item{\code{indicator}}{character Indicator}
#'   \item{\code{indicator_group}}{character Indicator grouping}
#'   \item{\code{question_text}}{character Survey question}
#'   \item{\code{mean}}{double Average for the group. See scale}
#'   \item{\code{lower_ci}}{double Lower bound for the average}
#'   \item{\code{upper_ci}}{double Upper bound for the average}
#'   \item{\code{scale}}{character Scale for the average}
#'   \item{\code{response_rate}}{double Response rate for the group}
#'}
#' @source <https://www.globalsurveyofpublicservants.org/data-downloads>
"gsps"

#' @title Worldwide Bureaucracy Indicators
#' @description The Worldwide Bureaucracy Indicators (WWBI) are a unique cross-national dataset on public sector employment and wages developed by the World Bank's `Bureaucracy Lab'. They aim to help researchers, development practitioners, and policymakers gain a better understanding of the personnel dimensions of state capability, the footprint of the public sector within the overall labor market, and the fiscal implications of the public sector wage bill.
#' @source <https://prosperitydata360.worldbank.org/en/indicator/WB+WWBI+BI+EMP+TOTL+PB+ZS>
#'
#' @format A data frame with 1050 rows and 6 variables:
#' \describe{
#'   \item{\code{country_code}}{character World Bank country code}
#'   \item{\code{year}}{double Year}
#'   \item{\code{share_public_sector}}{double Public sector employment, as a share of total employment}
#'   \item{\code{economy}}{character Economy name}
#'   \item{\code{region}}{character World Bank region}
#'   \item{\code{income_group}}{character World Bank income group}
#'}
"wwbi"

#' @title Worldwide Bureaucracy Indicators: Occupational Breakdown
#' @description A breakdown of the occupational composition of each public sector, by country. Occupational classifications are based on the International Standard Classification of Occupations (ISCO).
#' @format A data frame with 125 rows and 5 variables:
#' \describe{
#'   \item{\code{country_code}}{character World Bank country code}
#'   \item{\code{professional_and_technical}}{double Share of public sector employment in professional and technical occupations}
#'   \item{\code{managerial}}{double Share of public sector employmentmanagerial occupations}
#'   \item{\code{clerical}}{double Share of public sector employment in clerical occupations}
#'   \item{\code{other}}{double Share of public sector employment in other occupations}
#'}
#' @source Shared by the Bureaucracy Lab.
"wwbi_occupation"

#' @title Labor statistics
#' @description A combination of labor statistics from the UN SDG and the Education Statistics
#' @source Prosperity Data 360
#' @format A data frame with 6170 rows and 4 variables:
#' \describe{
#'   \item{\code{country_code}}{character World Bank country code}
#'   \item{\code{year}}{double Year}
#'   \item{\code{total_labor_force}}{double Labor force, Total. Source: Education Statistics}
#'   \item{\code{unemployment_rate}}{double Unemployment, total (% of total labor force) (national estimate). Source: UN SDG.}
#'}
#' @details URLs: https://prosperitydata360.worldbank.org/en/indicator/WB+EDSTATS+SL+TLF+TOTL+IN; https://prosperitydata360.worldbank.org/en/indicator/UN+SDG+SL+UEM+TOTL+NE+ZS
"labor"

#' @title Varieties of Democracy
#' @description V-Dem provides a multidimensional and disaggregated dataset that reflects the complexity of the concept of democracy as a system of rule that goes beyond the simple presence of elections.
#' @format A data frame with 6204 rows and 4 variables:
#' \describe{
#'   \item{\code{country_code}}{character World Bank country code}
#'   \item{\code{year}}{double Year}
#'   \item{\code{merit_criteria}}{double Criteria for appointment decisions in the state administration. Question: To what extent are appointment decisions in the state administration based on personal and political connections, as opposed to skills and merit?}
#'   \item{\code{impartial}}{double Rigorous and impartial public administration. Question: Are public officials rigorous and impartial in the performance of their duties}
#'}
#' @details DETAILS
"vdem"

#' @title Cash Surplus as Percentage of GDP
#' @description Cash surplus or deficit is revenue (including grants) minus expense, minus net acquisition of nonfinancial assets. In the 1986 GFS manual nonfinancial assets were included under revenue and expenditure in gross terms. This cash surplus or deficit is closest to the earlier overall budget balance (still missing is lending minus repayments, which are now a financing item under net acquisition of financial assets).
#' @format A data frame with 2284 rows and 3 variables:
#' \describe{
#'   \item{\code{country_code}}{character World Bank country code}
#'   \item{\code{year}}{double Year}
#'   \item{\code{cash_surplus_pct_gdp}}{double Cash Surplus/Deficit as Percentage of GDP}
#'}
#' @details DETAILS
"cash_surplus"

#' @title Open Budget Survey: Legislature and Super Audit Institution Oversight Score
#' @description The role that legislatures and supreme audit institutions play in the budget process and the extent to which they are able to provide robust oversight of the budget.
#' @format A data frame with 500 rows and 3 variables:
#' \describe{
#'   \item{\code{country_code}}{character World Bank country code}
#'   \item{\code{year}}{character Year}
#'   \item{\code{oversight_score}}{double Legislature and Super Audit Institution Oversight Score}
#'}
#' @details DETAILS
"open_budget"

#' @title Budget Execution Rate
#' @description Primary government expenditures as a proportion of original approved budget (%)
#' @source <https://data360.worldbank.org/en/indicator/WB_WDI_GF_XPD_BUDG_ZS>
#' @format A data frame with 3154 rows and 3 variables:
#' \describe{
#'   \item{\code{country_code}}{character World Bank country code}
#'   \item{\code{year}}{character Year}
#'   \item{\code{budget_execution_rate}}{double Primary government expenditure (%)}
#'}
"budget_execution"
