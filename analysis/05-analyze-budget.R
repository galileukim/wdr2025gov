# set-up ------------------------------------------------------------------
library(ggplot2)
library(ggthemes)
library(scales)
library(ggrepel)

theme_set(
  theme_few(
    base_size = 18
  )
)

# analysis ----------------------------------------------------------------
budget_execution |>
  left_join(
    countryclass,
    by = c("country_code")
  ) |>
  left_join(
    wdi_gdp_pc |> mutate(year = as.character(year)),
    by = c("country_code", "year")
  ) |>
  group_by(country_code) |>
  slice_max(
    order_by = year,
    n = 1
  ) |>
  ungroup() |>
  ggplot(
    aes(
      gdp_per_capita_ppp_2017,
      budget_execution_rate
    )
  ) +
  geom_text(
    aes(
      label = country_code,
      color = region
      )
  ) +
  geom_smooth(
    method = "lm",
    se = FALSE
  ) +
  geom_hline(
    yintercept = 100,
    linetype = "dashed"
  ) +
  scale_x_continuous(
    trans = "log10",
    labels = scales::comma
  ) +
  scale_color_colorblind(
    name = "Region"
  ) +
  theme(
    legend.position = "bottom"
  ) +
  coord_cartesian(
    ylim = c(50, 150)
  ) +
  labs(
    x = "GDP per capita (PPP, in 2017 USD)",
    y = "Budget Execution Rate (% of original approved budget)"
  )
