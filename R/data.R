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
#'   \item{\code{budget_transparency_score}}{double Budget transparency score Budget transparency score (previously known as the Open Budget Index): assesses the public availability of the eight key budget documents, which taken together provide a complete view of how public resources have been raised, planned, and spent during the budget year. To be considered "publicly available", documents must be published online, in a timely manner, and must include information that is comprehensive and useful. A score of 61 or above indicates a country is likely publishing enough material to support informed public debate on the budget.}
#'   \item{\code{oversight_score}}{double Legislature and Super Audit Institution Oversight Score: The role that legislatures and supreme audit institutions play in the budget process and the extent to which they are able to provide robust oversight of the budget.}
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

#' @title Gender Statistics
#' @description Women in ministerial level positions is the proportion of women in ministerial or equivalent positions (including deputy prime ministers) in the government. Prime Ministers/Heads of Government are included when they hold ministerial portfolios. Vice-Presidents and heads of governmental or public agencies are excluded.
#' @format A data frame with 5035 rows and 3 variables:
#' \describe{
#'   \item{\code{country_code}}{character World Bank country code}
#'   \item{\code{year}}{double Year}
#'   \item{\code{prop_women_ministry}}{double Proportion of women in ministerial level positions}
#'}
#' @source <https://data360.worldbank.org/en/indicator/WB_GS_SG_GEN_MNST_ZS>
"women_ministry"

#' @title Global dataset of public procurement laws, practice, and outcomes
#' @description All data received through surveys used in this paper was validated/reconciled through extensive readings of the relevant laws, as well as multiple follow-ups conducted by phone and/or through country visits. The data was collected by a team led by one of the authors as part of the World Bank Doing Business 2020 data collection cycle.
#' @format A data frame with 187 rows and 15 variables:
#' \describe{
#'   \item{\code{economy}}{character Economy}
#'   \item{\code{country_code}}{character World Bank country code}
#'   \item{\code{loggdp}}{double Logged GDP per Capita}
#'   \item{\code{transparency_l}}{double Transparency Index (Law)}
#'   \item{\code{transparency_p}}{double Transparency Index (Practice)}
#'   \item{\code{competition_l}}{double Competition (Law)}
#'   \item{\code{competition_p}}{double Competition (Practice)}
#'   \item{\code{integrity_of_contract_l}}{double Integrity of Contract (Law)}
#'   \item{\code{integrity_of_contract_p}}{double Integrity of Contract (Practice)}
#'   \item{\code{limits_to_exclusion_l}}{double Limits to Exclusion (Law)}
#'   \item{\code{limits_to_exclusion_p}}{double Limits to Exclusion (Practice)}
#'   \item{\code{laws}}{double Laws Index}
#'   \item{\code{practices}}{double Practices Index}
#'   \item{\code{quality}}{double Quality Index}
#'   \item{\code{integrity}}{double Integrity Index}
#'}
#' @source https://www.openicpsr.org/openicpsr/project/153181/version/V1/view
"procurement"

#' @title GovTech Dataset (2022)
#' @description The WBG launched the GovTech Maturity Index (GTMI) in 2020 as a composite index that uses 48 key indicators to measure critical aspects of four GovTech focus areas in 198 economies: supporting core government systems, enhancing service delivery, mainstreaming citizen engagement, and fostering GovTech enablers.
#' @format A data frame with 198 rows and 4 variables:
#' \describe{
#'   \item{\code{country_code}}{character World Bank country code}
#'   \item{\code{hrmis_year_est}}{double Year of the Human Resource Management Information System (HRMIS) launch}
#'   \item{\code{egp_year_est}}{double Year of the e-Government Procurement Management Information System (eGP) launch}
#'   \item{\code{fmis_year_est}}{double Year of the Financial Management Information System (FMIS) launch}
#'}
#' @source https://datacatalog.worldbank.org/int/search/dataset/0037889/govtech-dataset
"gtmi"

#' @title Enterprise Surveys
#' @description World Bank Enterprise Surveys (WBES) are nationally representative firm-level surveys with top managers and owners of businesses in over 160 economies, reaching 180 in upcoming years, that provide insight into many business environment topics such as access to finance, corruption, infrastructure, and performance, among others.
#' @format A data frame with 116 rows and 3 variables:
#' \describe{
#'   \item{\code{country_code}}{character World Bank country code}
#'   \item{\code{year}}{double Year}
#'   \item{\code{management_practices_index}}{double Management Practices Index is a composite metric combining eight individual management practices indicators that assess various aspects of organizational behavior, including decision-making processes, goal-setting, and personnel evaluation.}
#'}
#' @details Considers management practices in the economy as a whole
"enterprise_surveys"

#' @title Microdados de Despesas de Entes Subnacionais (MiDES)
#' @description This dataset contains annual panel data on public procurement and public expenditure of Brazilian municipalities.
#' @format A data frame with 43,298 rows and 10 variables:
#' \describe{
#'   \item{\code{state}}{character. Two-letter abbreviation of the Brazilian state (UF) to which the municipality belongs.}
#'   \item{\code{year}}{double. Year of observation.}
#'   \item{\code{municipality_code}}{double. IBGE 7-digit code identifying each municipality.}
#'   \item{\code{weighted_average_delay}}{double. Average years of schooling delay among enrolled students, weighted by enrollment size.}
#'   \item{\code{population}}{double. Total resident population of the municipality in the given year.}
#'   \item{\code{gdp}}{double. Gross Domestic Product of the municipality, in constant BRL.}
#'   \item{\code{gdp_per_capita}}{double. GDP per capita, calculated as GDP divided by total population.}
#'   \item{\code{total_students}}{double. Total number of students enrolled in basic education (public and private).}
#'   \item{\code{formal_market_workers}}{double. Number of formally employed workers (i.e., with a signed labor contract) in the municipality.}
#'   \item{\code{idhm}}{double. Municipal Human Development Index (Índice de Desenvolvimento Humano Municipal), a composite measure of education, income, and longevity.}
#'}
#' @details The dataset was constructed by merging data from multiple official sources, including the IBGE (Brazilian Institute of Geography and Statistics), INEP (National Institute of Educational Studies), and RAIS (Annual Report of Social Information). All monetary values are adjusted to constant prices. Data is cleaned and harmonized to ensure consistency across years and municipalities.
"mides"

#' @title RAIS Municipal Dataset
#' @description Summary statistics on headcount, hiring and dismissals at the municipality-year level
#' @format A data frame with 107076 rows and 7 variables:
#' \describe{
#'   \item{\code{id_municipio}}{character Municipality identifier (IBGE code)}
#'   \item{\code{ano}}{integer Year}
#'   \item{\code{total_headcount}}{integer Total headcount}
#'   \item{\code{total_new_hire}}{double Total new hires}
#'   \item{\code{total_dismissed}}{double Total dismissals}
#'   \item{\code{share_new_hire}}{double Share of new hires}
#'   \item{\code{share_dismissed}}{double Share of dismissals}
#'}
#' @details Data extracted from the Base dos Dados
#' @source: https://basedosdados.org/dataset/3e7c4d58-96ba-448e-b053-d385a829ef00?table=dabe5ea8-3bb5-4a3e-9d5a-3c7003cd4a60
"rais_mun"

#' @title Brazilian Municipality Shapefiles
#' @description Shapesfiles for municipal boundaries in Brazil (IBGE)
#' @format A data frame with 5573 rows and 16 variables:
#' \describe{
#'   \item{\code{municipality_code}}{character Municipality code (IBGE)}
#'   \item{\code{nm_mun}}{character Municipality name}
#'   \item{\code{cd_rgi}}{character Region code}
#'   \item{\code{nm_rgi}}{character Region name}
#'   \item{\code{cd_rgint}}{character COLUMN_DESCRIPTION}
#'   \item{\code{nm_rgint}}{character COLUMN_DESCRIPTION}
#'   \item{\code{cd_uf}}{character State code}
#'   \item{\code{nm_uf}}{character State name}
#'   \item{\code{sigla_uf}}{character State acronym}
#'   \item{\code{cd_regia}}{character COLUMN_DESCRIPTION}
#'   \item{\code{nm_regia}}{character COLUMN_DESCRIPTION}
#'   \item{\code{sigla_rg}}{character COLUMN_DESCRIPTION}
#'   \item{\code{cd_concu}}{character COLUMN_DESCRIPTION}
#'   \item{\code{nm_concu}}{character COLUMN_DESCRIPTION}
#'   \item{\code{area_km2}}{double COLUMN_DESCRIPTION}
#'   \item{\code{geometry}}{list COLUMN_DESCRIPTION}
#'}
#' @details DETAILS
"brazil_mun_shp"
