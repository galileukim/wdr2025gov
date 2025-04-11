# set-up ------------------------------------------------------------------
library(ggplot2)
library(ggthemes)

# analysis ----------------------------------------------------------------
# a balanced panel?
wwbi |>
  filter(
    year <= 2018
  ) |>
  group_by(year, region) |>
  summarise(
    total_public_employees = sum(public_paid_employee),
    .groups = "drop"
  ) |>
  ggplot_line(
      year,
      total_public_employees,
      color = region
  ) +
  scale_color_colorblind()

wwbi |>
  filter(year == 2017) |>
  arrange(desc(public_paid_employee))
