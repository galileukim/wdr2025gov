# set-up ------------------------------------------------------------------
library(ggplot2)
library(ggthemes)

theme_set(
  theme_classic(
    base_size = 24
  )
)

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

ggplot_line <- function(data, x, y, ...){
  data |>
    ggplot(
      aes({{x}}, {{y}}, ...)
    ) +
    geom_point() +
    geom_line()
}

# visualize ---------------------------------------------------------------
constitution |>
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
  here("figs", "share_countries_merit.png"),
  height = 12,
  width = 16,
  bg = "white"
)

# absolute number
constitution |>
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
  here("figs", "number_countries_merit.png"),
  height = 12,
  width = 16,
  bg = "white"
)

# absolute number by region
constitution |>
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
  here("figs", "number_countries_merit_by_region.png"),
  height = 16,
  width = 12,
  bg = "white"
)

# share of countries
constitution |>
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
  here("figs", "share_countries_merit_by_region.png"),
  height = 16,
  width = 12,
  bg = "white"
)
