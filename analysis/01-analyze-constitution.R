# set-up ------------------------------------------------------------------
library(ggplot2)
library(ggthemes)
library(forcats)

theme_set(
  theme_classic(
    base_size = 24
  )
)

# visualize ---------------------------------------------------------------
constitution_subset <- constitution |>
  filter(year >= 1960)

constitution_subset |>
  summarise_merit(
    "year",
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
    title = "Share of Countries with Merit-Based Recruitment",
    subtitle = "Enshrined in the Constitution",
    caption = "Source: Comparative Constitutions Project"
  )

ggsave(
  here("figs", "constitution",  "1-share_countries_merit.png"),
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
  labs(
    x = "Year",
    y = "Number of Countries",
    title = "Number of Countries with Merit-Based Recruitment",
    subtitle = "Enshrined in the Constitution",
    caption = "Source: Comparative Constitutions Project"
  )

ggsave(
  here("figs", "constitution",  "2-number_countries_merit.png"),
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
  facet_wrap(
    vars(region),
    nrow = 3
  ) +
  labs(
    x = "Year",
    y = "Number of Countries",
    title = "Number of Countries with Merit-Based Recruitment",
    subtitle = "Enshrined in the Constitution",
    caption = "Source: Comparative Constitutions Project"
  ) +
  theme(
    legend.position = "bottom"
  ) +
  scale_colour_colorblind()

ggsave(
  here("figs", "constitution",  "3-number_countries_merit_by_region.png"),
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
    title = "Share of Countries with Merit-Based Recruitment",
    subtitle = "Enshrined in the Constitution",
    caption = "Source: Comparative Constitutions Project"
  ) +
  theme(
    legend.position = "bottom"
  ) +
  scale_colour_colorblind()

ggsave(
  here("figs", "constitution", "4-share_countries_merit_by_region.png"),
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
    title = "Share of Countries with Merit-Based Recruitment",
    subtitle = "Enshrined in the Constitution",
    caption = "Source: Comparative Constitutions Project"
  ) +
  theme(
    legend.position = "bottom"
  ) +
  scale_colour_colorblind()

ggsave(
  here("figs", "constitution",  "5-share_countries_merit_by_income.png"),
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
  facet_wrap(
    vars(income_group),
    nrow = 3
  ) +
  labs(
    x = "Year",
    y = "Number of Countries",
    title = "Number of Countries with Merit-Based Recruitment",
    subtitle = "Enshrined in the Constitution",
    caption = "Source: Comparative Constitutions Project"
  ) +
  theme(
    legend.position = "bottom"
  ) +
  scale_colour_colorblind()

ggsave(
  here("figs", "constitution", "6-number_countries_merit_by_income.png"),
  height = 12,
  width = 14,
  bg = "white"
)
