# set-up ------------------------------------------------------------------
library(ggplot2)
library(ggthemes)
library(tidyr)
library(forcats)

theme_set(
  theme_few(
    base_size = 24
  )
)

constitution_subset <- constitution |>
  filter(
    year >= 1960 & !is.na(country_code)
  ) |>
  left_join(
    wdi_gdp_pc,
    by = c("country_code", "year")
  )

# visualize ---------------------------------------------------------------
constitution_subset |>
  summarise_merit(
    group_var = c("year"),
    agg_fun = "mean"
  ) |>
  mutate(
    decade = year - year %% 10
  ) |>
  # group_by(decade) |>
  # mutate(
  #   total_obs_decade = total_obs[year == decade]
  # ) |>
  # ungroup() |>
  ggplot_line(
    year, merit
  ) +
  # geom_text(
  #   aes(
  #     x = decade,
  #     y = 0.35,
  #     label = total_obs_decade
  #   )
  # ) +
  scale_y_continuous(
    labels = scales::percent_format()
  ) +
  scale_x_continuous(
    breaks = seq(1960, 2020, 10),
    labels = seq(1960, 2020, 10)
  ) +
  labs(
    x = "Year",
    y = "Percentage",
    title = "Constitutional Mandate for Merit-Based Recruitment",
    subtitle = "Share of Countries",
    caption = "Source: Comparative Constitutions Project"
  )

ggsave(
  here("figs", "constitution",  "01-share_countries_merit.png"),
  height = 12,
  width = 16,
  bg = "white"
)

# absolute number
constitution_subset |>
  summarise_merit(
    "year",
    agg_fun = "sum"
  ) |>
  ggplot_line(
    year, merit
  ) +
  geom_line(
    aes(year, total_obs),
    linetype = "dashed"
  ) +
  annotate(
    "text",
    size = 8,
    x = 2018,
    y = 175,
    label = "Countries with Data\n Available"
  ) +
  annotate(
    "text",
    size = 8,
    x = 2016,
    y = 75,
    label = "Countries with Merit-Based \nRecruitment in Constitution"
  ) +
  scale_x_continuous(
    breaks = seq(1960, 2020, 10),
    labels = seq(1960, 2020, 10)
  ) +
  labs(
    x = "Year",
    y = "Number of Countries",
    # title = "Constitutional Mandate for Merit-Based Recruitment",
    # subtitle = "Number of Countries",
    caption = "Source: Comparative Constitutions Project"
  )

ggsave(
  here("figs", "constitution",  "02-number_countries_merit.png"),
  height = 12,
  width = 16,
  bg = "white"
)

# absolute number by region
constitution_subset |>
  filter(
    !is.na(region) &
      region != "North America"
  ) |>
  summarise_merit(
    c("year", "region"),
    agg_fun = "sum"
  ) |>
  ggplot_line(
    year, merit,
    color = region
  ) +
  geom_line(
    aes(year, total_obs),
    linetype = "dashed"
  ) +
  facet_wrap(
    vars(region),
    nrow = 3
  ) +
  labs(
    x = "Year",
    y = "Number of Countries"
    # title = "Constitutional Mandate for Merit-Based Recruitment",
    # subtitle = "Number of Countries by Region",
    # caption = "Source: Comparative Constitutions Project"
  ) +
  theme(
    legend.position = "bottom"
  ) +
  scale_colour_colorblind(
    name = ""
  )

ggsave(
  here("figs", "constitution",  "03-number_countries_merit_by_region.png"),
  height = 14,
  width = 16,
  bg = "white"
)

# share of countries
constitution_subset |>
  filter(
    !is.na(region) &
      region != "North America"
  ) |>
  summarise_merit(
    c("year", "region"),
    agg_fun = "mean"
  ) |>
  ggplot_line(
    year, merit,
    color = region
  ) +
  facet_wrap(
    vars(region),
    nrow = 3
  ) +
  scale_y_continuous(
    labels = scales::percent_format()
  ) +
  labs(
    x = "Year",
    y = "Share of Countries",
    title = "Constitutional Mandate for Merit-Based Recruitment",
    subtitle = "Share of Countries by Region",
    caption = "Source: Comparative Constitutions Project"
  ) +
  theme(
    legend.position = "bottom"
  ) +
  scale_color_colorblind()

ggsave(
  here("figs", "constitution", "04-share_countries_merit_by_region.png"),
  height = 16,
  width = 14,
  bg = "white"
)

# by income group: share
constitution_subset |>
  inner_join(
    countryclass,
    by = "country_code"
  ) |>
  filter(
    !is.na(country_code) &
      !is.na(income_group)
  ) |>
  mutate(
    income_group = fct_relevel(
      income_group,
      c(
        "High income",
        "Upper middle income",
        "Lower middle income",
        "Low income"
      )
    )
  ) |>
  summarise_merit(
    c("year", "income_group"),
    agg_fun = "mean"
  ) |>
  ggplot_line(
    year, merit,
    color = income_group
  ) +
  facet_wrap(
    vars(income_group),
    nrow = 3
  ) +
  scale_y_continuous(
    labels = scales::percent_format()
  ) +
  labs(
    x = "Year",
    y = "Share of Countries",
    title = "Constitutional Mandate for Merit-Based Recruitment",
    subtitle = "Share of Countries by Income Group",
    caption = "Source: Comparative Constitutions Project"
  ) +
  theme(
    legend.position = "none"
  ) +
  scale_colour_colorblind()

ggsave(
  here("figs", "constitution",  "05-share_countries_merit_by_income.png"),
  height = 12,
  width = 14,
  bg = "white"
)

# by income group: sum
constitution_subset |>
  inner_join(
    countryclass,
    by = "country_code"
  ) |>
  filter(
    !is.na(country_code) &
      !is.na(income_group)
  ) |>
  mutate(
    income_group = fct_relevel(
      income_group,
      c(
        "High income",
        "Upper middle income",
        "Lower middle income",
        "Low income"
      )
    )
  ) |>
  summarise_merit(
    c("year", "income_group"),
    agg_fun = "sum"
  ) |>
  ggplot_line(
    year, merit,
    color = income_group
  ) +
  geom_line(
    aes(year, total_obs),
    linetype = "dashed"
  ) +
  facet_wrap(
    vars(income_group),
    nrow = 3
  ) +
  labs(
    x = "Year",
    y = "Number of Countries",
    title = "Constitutional Mandate for Merit-Based Recruitment",
    subtitle = "Total of Countries by Income Group",
    caption = "Source: Comparative Constitutions Project"
  ) +
  theme(
    legend.position = "none"
  ) +
  scale_colour_colorblind()

ggsave(
  here("figs", "constitution", "06-number_countries_merit_by_income.png"),
  height = 12,
  width = 14,
  bg = "white"
)

# by deciles of logged gdp per capita
constitution_subset |>
  filter(
    year >= 1990 & !is.na(gdp_per_capita_ppp_2017)
  ) |>
  mutate(
    decade = (year - year %% 10),
    bin_gdp_per_capita = cut(
      log(gdp_per_capita_ppp_2017),
      5,
      labels = 1:5,
      include.lowest = TRUE
    )
  ) |>
  summarise_merit(
    c("decade", "bin_gdp_per_capita")
  ) |>
  mutate(
    share_merit = merit/total_obs,
    se = sqrt(share_merit * (1 - share_merit)/total_obs),
    # Wald confidence intervals
    lower_ci = share_merit - qnorm(1 - 0.05/2) * se,
    upper_ci = share_merit + qnorm(1 - 0.05/2) * se
  ) |>
  ungroup() |>
  ggplot() +
  geom_pointrange(
    aes(
      bin_gdp_per_capita, share_merit,
      ymin = lower_ci,
      ymax = upper_ci,
      color = as.character(decade)
    )
  ) +
  facet_wrap(vars(decade)) +
  scale_color_colorblind() +
  scale_y_continuous(
    labels = scales::percent_format()
  ) +
  labs(
    x = "Logged GDP per Capita PPP in 2017USD (decile)",
    y = "Share of Countries"
  ) +
  theme(
    legend.position = "bottom"
  )

# measuring reversals:
# a reversal is defined as a constitutional mandate for merit is either
# overturned or suspended
constitution_subset |>
  summarise_merit_reversal(
    group_var = "year"
  ) |>
  invert_merit_reversal() |>
  ggplot_line(
    year, value,
    color = name
  ) +
  scale_y_continuous(
    labels = abs
  ) +
  theme(
    legend.position = "bottom"
  ) +
  scale_color_solarized(
    name = ""
  ) +
  geom_hline(
    yintercept = 0,
    linetype = "dashed"
  ) +
  labs(
    x = "Year",
    y = "Number of Countries (Cumulative)",
    caption = "Source: Comparative Constitutions Project"
  )

ggsave(
  here("figs", "constitution", "07-cumulative_merit_reversals.png"),
  height = 8,
  width = 12,
  bg = "white"
)

# reversal by region
constitution_subset |>
  filter(
    region != "North America"
  ) |>
  summarise_merit_reversal(
    group_var = c("year", "region")
  ) |>
  invert_merit_reversal(
    c("year", "region")
  ) |>
  ggplot_line(
    year, value,
    color = name
  ) +
  scale_y_continuous(
    labels = abs
  ) +
  theme(
    legend.position = "bottom"
  ) +
  scale_color_solarized(
    name = ""
  ) +
  geom_hline(
    yintercept = 0,
    linetype = "dashed"
  ) +
  facet_wrap(
    vars(region)
  ) +
  labs(
    x = "Year",
    y = "Number of Countries (Cumulative)",
    caption = "Source: Comparative Constitutions Project"
  )

ggsave(
  here("figs", "constitution", "08-cumulative_merit_reversals_region.png"),
  height = 10,
  width = 12,
  bg = "white"
)

# evolution of GDP per capita with the onset of reform
constitution_subset |>
  filter(
    year >= 1990
  ) |>
  classify_merit_change() |>
  group_by(country_code) |>
  mutate(
    treat = if_else(
      merit_change == "meritocratic reform",
      1, 0
    ),
    treat_status = cumsum(treat)
  ) |>
  arrange(country_code, year) |>
  fill(
    treat,
    .direction = "down"
  ) |>
  mutate(
    cum_year = cumsum(treat_status) - 1
  ) |>
  ungroup() |>
  group_by(cum_year) |>
  summarise(
    mean_gdp_per_capita = mean(gdp_per_capita_ppp_2017, na.rm = T)
  ) |>
  mutate(
    normalized_gdp_per_capita = mean_gdp_per_capita/mean_gdp_per_capita[cum_year == 0] * 100
  ) |>
  filter(cum_year >= 0) |>
  ggplot(
    aes(cum_year, normalized_gdp_per_capita)
  ) +
  geom_point() +
  geom_line() +
  geom_hline(
    yintercept = 100,
    linetype = "dashed"
  ) +
  coord_cartesian(
    xlim = c(0, 20)
  )

# net reforms
constitution_subset |>
  summarise_merit_reversal(
    group_var = c("year")
  ) |>
  select(
    year,
    `Meritocratic Reforms` = sum_merit_reform,
    `Meritocratic Reversals` = sum_merit_reversal
  ) |>
  pivot_longer(
    cols = -c(year)
  ) |>
  mutate(
    value = if_else(
      name == "Meritocratic Reforms",
      value,
      -1 * value
    )
  ) |>
  ggplot(
    aes(year, value, fill = name)
  ) +
  geom_col() +
  geom_hline(
    yintercept = 0
  ) +
  scale_fill_solarized()

# appendix ----------------------------------------------------------------
constitution_subset |>
  filter(
    type_constitution != "Constitution"
  ) |>
  group_by(type_constitution) |>
  slice_sample(n = 5)

constitution_subset |>
  filter(
    !is.na(type_constitution)
  ) |>
  summarise_merit(
    group_var = c("type_constitution", "year"),
    agg_fun = "mean"
  ) |>
  ggplot_line(
    year, merit,
    color = type_constitution
  ) +
  facet_wrap(
    vars(type_constitution)
  ) +
  scale_y_continuous(
    labels = scales::percent_format()
  ) +
  labs(
    x = "Year",
    y = "Percentage",
    title = "Constitutional Mandate for Merit-Based Recruitment",
    subtitle = "Share of Countries by Type of Constitution",
    caption = "Source: Comparative Constitutions Project"
  ) +
  scale_colour_colorblind()

constitution_subset |>
  filter(
    !is.na(type_constitution)
  ) |>
  summarise_merit(
    group_var = c("type_constitution", "year"),
    agg_fun = "sum"
  ) |>
  ggplot_line(
    year, merit,
    color = type_constitution
  ) +
  facet_wrap(
    vars(type_constitution)
  ) +
  labs(
    x = "Year",
    y = "Percentage",
    title = "Constitutional Mandate for Merit-Based Recruitment",
    subtitle = "Number of Countries by Type of Constitution",
    caption = "Source: Comparative Constitutions Project"
  ) +
  theme(legend.position = "none") +
  scale_colour_colorblind()

