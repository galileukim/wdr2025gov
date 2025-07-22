# set-up ------------------------------------------------------------------
library(ggplot2)
library(ggthemes)
library(scales)
library(ggrepel)
library(gghighlight)

theme_set(
  theme(
    panel.grid = element_blank(),
    panel.background = element_rect(fill = "white",color='black'),
    plot.title = element_text(hjust = 0.5),
    legend.position='bottom',
    legend.key = element_rect(fill = "white",color='white'),
    text = element_text(size = 14),
    legend.text=element_text(size=14)
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
  filter(
    year == 2021
  ) |>
  ggplot(
    aes(
      gdp_per_capita_ppp_2017,
      budget_execution_rate
    )
  ) +
  geom_point() +
  geom_smooth(
    method = "lm",
    formula = y ~ x + I(x^2),
    se = TRUE,
    color='deepskyblue4',
    fill='slategray2'
  ) +
  geom_hline(
    yintercept = 100,
    linetype = "dashed"
  ) +
  scale_x_continuous(
    trans = "log10",
    labels = scales::comma
  ) +
  coord_cartesian(
    ylim = c(50, 150)
  ) +
  labs(
    x = "GDP per capita (PPP, in 2017 USD)",
    y = "Budget Execution Rate (% of original approved budget)"
  )

ggsave(
  here("figs", "budget", "01-fig_cor_gdp_vs_budgetexecution.png"),
  width = 8,
  height = 6,
  dpi = 300
)

# correlation between budget transparency and cash surplus
cash_surplus |>
  left_join(
    open_budget,
    by = c("country_code", "year")
  ) |>
  left_join(
    countryclass,
    by = c("country_code")
  ) |>
  ggplot(
    aes(
      budget_transparency_score,
      cash_surplus_pct_gdp
    )
  ) +
  geom_point(
    aes(color = region)
  ) +
  coord_cartesian(
    ylim = c(-25, 25)
  ) +
  geom_hline(
    yintercept = 0,
    linetype = "dashed"
  ) +
  labs(
    x = "Budget Transparency Score",
    y = "Cash Surplus as Percentage of GDP"
  ) +
  scale_color_brewer(
    palette = "Paired"
  ) +
  theme(
    legend.position = "bottom"
  )

ggsave(
  here("figs", "budget", "02-fig_cor_budget_transparency_vs_cash_surplus.png"),
  width = 12,
  height = 8,
  bg = "white"
)

# correlation between budget oversight and cash surplus
cash_surplus |>
  left_join(
    open_budget |> mutate(year = year - 1),
    by = c("country_code", "year")
  ) |>
  left_join(
    countryclass,
    by = c("country_code")
  ) |>
  filter(
    year == 2020
  ) |>
  ggplot(
    aes(
      supreme_audit_oversight_score,
      cash_surplus_pct_gdp
    )
  ) +
  geom_point(
    aes(label = country_code, color = region)
  ) +
  gghighlight(
    label_key = economy,
    unhighlighted_params = list(colour = NULL),
    country_code %in% c("GNQ", "SWZ", "SAU", "FJI", "ARG", "MYS", "IND", "ZAF")
  ) +
  coord_cartesian(
    ylim = c(-50, 50)
  ) +
  geom_hline(
    yintercept = 0,
    linetype = "dashed"
  ) +
  labs(
    x = "Supreme Audit Oversight Score",
    y = "Cash Surplus as Percentage of GDP"
  ) +
  scale_color_brewer(
    palette = "Paired"
  ) +
  theme(
    legend.position = "bottom"
  )

ggsave(
  here("figs", "budget", "03-fig_cor_budget_oversight_vs_cash_surplus.png"),
)

# correlation between budget transparency and GDP
set.seed(052025)

wdi_gdp_pc |>
  left_join(
    open_budget |> mutate(year = year - 1),
    by = c("country_code", "year")
  ) |>
  filter(
    year == 2022
  ) |>
  left_join(
    countryclass,
    by = c("country_code")
  ) |>
  ggplot(
    aes(
      x = gdp_per_capita_ppp_2017,
      y = budget_transparency_score
    )
  ) +
  geom_point() +
  geom_smooth(
    method = "lm",
    formula = y ~ x + I(x^2),
    se = TRUE,
    color='deepskyblue4',
    fill='slategray2'
  ) +
  labs(
    x = "GDP per Capita (PPP, USD 2017)",
    y = "Budget Transparency Score"
  ) +
  scale_x_continuous(
    transform = "log10",
    labels = scales::comma
  ) +
  scale_color_brewer(
    palette = "Paired"
  ) +
  theme(
    legend.position = "bottom"
  )

ggsave(
  here("figs", "budget", "04-fig_cor_budget_transparency_vs_gdp_per_capita.png"),
  width = 8,
  height = 6,
  dpi = 300
)

# correlation between budget execution and budget transparency
budget_execution |>
  mutate(
    year = as.numeric(year)
  ) |>
  left_join(
    open_budget |> mutate(year = year - 1),
    by = c("country_code", "year")
  ) |>
  filter(
    year == 2022
  ) |>
  left_join(
    countryclass,
    by = c("country_code")
  ) |>
  ggplot(
    aes(
      budget_transparency_score,
      budget_execution_rate
    )
  ) +
  geom_text(
    aes(
      label = country_code,
      color = region
    )
  ) +
  geom_hline(
    yintercept = 100,
    linetype = 'dashed'
  ) +
  labs(
    x = "Budget Transparency Score",
    y = "Budget Execution Rate"
  ) +
  scale_color_brewer(
    palette = "Paired"
  ) +
  theme(
    legend.position = "bottom"
  )
