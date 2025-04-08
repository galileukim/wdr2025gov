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
  filter(year >= 1960)

# visualize ---------------------------------------------------------------
constitution_subset |>
  summarise_merit(
    group_var = c("year"),
    agg_fun = "mean"
  ) |>
  ggplot_line(
    year, merit
  ) +
  scale_y_continuous(
    labels = scales::percent_format()
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
    aes(year, total_countries),
    linetype = "dashed"
  ) +
  annotate(
    "text",
    x = 2020,
    y = 210,
    label = "Countries with Data Available"
  ) +
  annotate(
    "text",
    x = 2020,
    y = 70,
    label = "Countries with Merit-Based Recruitment\n in Constitution"
  ) +
  labs(
    x = "Year",
    y = "Number of Countries",
    title = "Constitutional Mandate for Merit-Based Recruitment",
    subtitle = "Number of Countries",
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
    aes(year, total_countries),
    linetype = "dashed"
  ) +
  facet_wrap(
    vars(region),
    nrow = 3
  ) +
  labs(
    x = "Year",
    y = "Number of Countries",
    title = "Constitutional Mandate for Merit-Based Recruitment",
    subtitle = "Number of Countries by Region",
    caption = "Source: Comparative Constitutions Project"
  ) +
  theme(
    legend.position = "bottom"
  ) +
  scale_colour_colorblind()

ggsave(
  here("figs", "constitution",  "03-number_countries_merit_by_region.png"),
  height = 16,
  width = 14,
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
  scale_color_sol()

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
    aes(year, total_countries),
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

# measuring reversals:
# a reversal is defined as a constitutional mandate for merit is either
# overturned or suspended
constitution_subset |>
  summarise_merit_reversal(
    group_var = "year"
  ) |>
  pivot_longer(
    cols = c(starts_with("Meritocratic"))
  ) |>
  ggplot_line(
    year, value,
    color = name
  ) +
  theme(
    legend.position = "bottom"
  ) +
  scale_colour_colorblind(
    name = ""
  ) +
  labs(
    x = "Year",
    y = "Total Number of Countries",
    caption = "Source: Comparative Constitutions Project"
  ) +
  ggtitle(
    "Meritocratic reforms and reversals (1960-2023)",
    subtitle = "Cumulative Number of Countries"
  )

ggsave(
  here("figs", "constitution", "07-cumulative_merit_reversals.png"),
  height = 12,
  width = 14,
  bg = "white"
)

# reversal by region
constitution_subset |>
  summarise_merit_reversal(
    group_var = c("year", "region")
  ) |>
  pivot_longer(
    cols = c(starts_with("Meritocratic"))
  ) |>
  ggplot_line(
    year, value,
    color = name
  ) +
  theme(
    legend.position = "bottom"
  ) +
  scale_colour_colorblind(
    name = ""
  ) +
  facet_wrap(
    vars(region)
  ) +
  labs(
    x = "Year",
    y = "Total Number of Countries",
    caption = "Source: Comparative Constitutions Project"
  ) +
  ggtitle(
    "Meritocratic reforms and reversals (1960-2023)",
    subtitle = "Cumulative Number of Countries by Region"
  )

ggsave(
  here("figs", "constitution", "08-cumulative_merit_reversals_region.png"),
  height = 12,
  width = 14,
  bg = "white"
)

#

# net reforms
constitution_subset |>
  summarise_merit_reversal(
    group_var = c("year", "region")
  ) |>
  mutate(
    net_merit = sum_merit_reform - sum_merit_reversal,
    color_net = if_else(net_merit > 0, "positive", "negative")
  ) |>
  ggplot() +
  geom_col(
    aes(year, net_merit, fill = color_net)
  ) +
  geom_hline(
    yintercept = 0
  ) +
  scale_fill_solarized(
    limits = rev
  )

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

