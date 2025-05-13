#' Classify country according to income group
#'
#' @param data A dataset containing country codes
#'
#' @import dplyr
#' @returns A dataset with income group classification
#' @export
#'
classify_income_group <- function(data){
  data |>
    left_join(
      countryclass |> select(country_code, income_group),
      by = c("country_code")
    ) |>
    mutate(
      income_group = fct_relevel(
      income_group,
      c("Low income", "Lower middle income", "Upper middle income", "High income")
      )
    )
}
