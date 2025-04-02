#' Generate merit statistics
#'
#' @param data A data frame
#' @param group_var Grouping variable
#' @param agg_fun Type of statistics. Defaults to sum.
#'
#' @return A summary statistics of the data on merit
#' @export
summarise_merit <- function(data, group_var, agg_fun = "sum"){
  switch_function <- switch(
    agg_fun,
    mean = {base::mean},
    sum = {base::sum}
  )

  data |>
    group_by(
      across(
        all_of(group_var)
      )
    ) |>
    summarise(
      merit = switch_function(merit == "yes", na.rm = T)
    )
}

#' Generate ggplot point and line
#'
#' @param data A data frame
#' @param x X-axis variable
#' @param y Y-axis variable
#' @param ...
#'
#' @return A plot
#' @export
ggplot_line <- function(data, x, y, ...){
  data |>
    ggplot(
      aes({{x}}, {{y}}, ...)
    ) +
    geom_point() +
    geom_line()
}
