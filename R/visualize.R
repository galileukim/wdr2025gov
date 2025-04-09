#' Generate merit statistics
#'
#' @param data A data frame
#' @param group_var Grouping variable
#' @param agg_fun Type of statistics. Defaults to sum.
#'
#' @import dplyr ggplot2
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
      merit = switch_function(.data[["merit"]] == "yes", na.rm = T),
      total_obs = n()
    )
}

#' Classify a change in merit
#'
#' @param data
#'
#' @import dplyr
#'
#' @return A classified dataset
#' @export
classify_merit_change <- function(data){
  data |>
    group_by(country_code) |>
    mutate(
      merit_lag = lag(merit, order_by = year),
      merit_change = case_when(
        merit == "yes" & (merit_lag == "no" | (is.na(merit_lag) & !min(year))) ~ "meritocratic reform",
        (merit == "no" | is.na(merit)) & merit_lag == "yes" ~ "meritocratic reversal",
        T ~ "no change"
      )
    ) |>
    ungroup()
}

#' Aggregate merit reversals by group
#'
#' @param data
#' @param group_var
#'
#' @import dplyr
#'
#' @return A summarised dataset with the change in merit-systems
#' @export
summarise_merit_reversal <- function(data, group_var){
  data |>
    distinct(
      country, merit,
      .keep_all = TRUE
    ) |>
    arrange(
      country, year
    ) |>
    classify_merit_change() |>
    filter(
      !is.na(merit_change)
    ) |>
    group_by(
      across(
        all_of(group_var)
      )
    ) |>
    summarise(
      sum_merit_reform = sum(merit_change == "meritocratic reform"),
      sum_merit_reversal = sum(merit_change == "meritocratic reversal"),
      .groups = "drop"
    ) |>
    mutate(
      `Meritocratic Reforms` = cumsum(sum_merit_reform),
      `Meritocratic Reversals` = cumsum(sum_merit_reversal)
    )
}

invert_merit_reversal <- function(data, vars = "year"){
  data |>
    select(
      all_of(vars),
      `Meritocratic Reforms`,
      `Meritocratic Reversals`
    ) |>
    pivot_longer(
      cols = -c(all_of(vars))
    ) |>
    mutate(
      value = if_else(
        name == "Meritocratic Reforms",
        value,
        -1 * value
      )
    )
}

left_join_national <- function(data, national_data){
  data |>
    left_join(
      {{national_data}} |>
          select(country_code, economy_fct, country_mean = mean),
      by = c("country_code")
    ) |>
    group_by(
      country_code
    ) |>
    mutate(
      upper_ci = max(mean),
      lower_ci = min(mean)
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
  plot <- data |>
    ggplot(
      aes({{x}}, {{y}}, ...)
    ) +
    geom_point() +
    geom_line()
}

#' Generate ggplot point-range
#'
#' @param data Data
#' @param x X-axis variable
#' @param y Y-axis variable
#' @param ... Any other arguments that can be placed in aes()
#'
#' @import ggplot2
#' @return A plot
#' @export
ggplot_pointrange <- function(data, x, y, ...){
  ggplot(data) +
    geom_pointrange(
      aes(
        x = {{x}},
        y = fct_reorder({{y}}, {{x}}),
        xmin = lower_ci,
        xmax = upper_ci,
        ...
      )
    ) +
    scale_x_continuous(
      labels = scales::percent_format()
    ) +
    labs(
      x = "Share of Public Servants",
      y = "Economy"
    )
}

#' Generate ggplot boxplot
#'
#' @param data Data
#' @param x X-axis variable
#' @param y Y-axis variable
#' @param ... Any other arguments that can be placed in aes()
#'
#' @import ggplot2
#' @return A plot
#' @export
ggplot_boxplot <- function(data, x, y, ...){
  ggplot(data) +
    geom_boxplot(
      aes(
        x = {{x}},
        y = fct_reorder({{y}}, {{x}}),
        ...
      ),
      width = 0.25,
      linewidth = 0.75
    ) +
    scale_x_continuous(
      labels = scales::percent_format()
    ) +
    labs(
      x = "Share of Public Servants",
      y = "Economy"
    )
}

#' Generate ggplot scatterplot
#'
#' @param data Data
#' @param x X-axis variable
#' @param y Y-axis variable
#' @param ... Any other arguments that can be placed in aes()
#'
#' @import ggplot2
#' @return A plot
#' @export
ggplot_scatter <- function(data, x, y, ...){
  ggplot(data) +
    geom_point(
      aes(
        x = {{x}},
        y = {{y}},
        ...
      )
    ) +
    scale_x_continuous(
      labels = scales::percent_format()
    )
}

#' Expands color palette to number of groups
#'
#' @param plot Plot, must be a ggplot
#' @param n_group Number of discrete groups
#'
#' @import ggplot2 RColorBrewer
#' @return An expanded scale
#' @export
scale_color_expand <- function(n_group){
  scale_color_manual(
    values = colorRampPalette(
      colorblind_pal()(8)
    )(n_group)
  )
}
