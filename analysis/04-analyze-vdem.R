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
vdem |>
  left_join(
    wdi_gdp_pc,
    by = c("country_code", "year")
  ) |>
  left_join(
    countryclass,
    by = c("country_code")
  ) |>
  filter(
    !is.na(region)
  ) |>
  mutate(
    decade = year - year %% 10
  ) |>
  group_by(region, country_code, decade) |>
  summarise(
    merit_criteria = mean(merit_criteria, na.rm = TRUE),
    impartial = mean(impartial, na.rm = TRUE),
    gdp_per_capita_ppp_2017 = mean(gdp_per_capita_ppp_2017, na.rm = TRUE),
    .groups = "drop"
  ) |>
  ggplot(
    aes(
      merit_criteria,
      gdp_per_capita_ppp_2017
    )
  ) +
  geom_point(
    aes(
      color = region
    )
  ) +
  geom_smooth(
    method = "lm",
    se = FALSE,
    linetype = "dashed",
    color = "grey15"
  ) +
  labs(
    x = "Meritocratic criteria for appointment",
    y = "GDP per capita (PPP, in 2017 USD)"
  ) +
  scale_y_continuous(
    trans = "log10",
    label = scales::comma
  ) +
  scale_color_colorblind(
    name = "Region"
  ) +
  theme(
    legend.position = "bottom"
  ) +
  facet_wrap(
    vars(decade)
  )

ggsave(
  here("figs", "vdem", "01-fig_cor_merit_gdp.png"),
  width = 12,
  height = 8,
  bg = "white"
)

vdem |>
  left_join(
    wdi_gdp_pc,
    by = c("country_code", "year")
  ) |>
  left_join(
    countryclass,
    by = c("country_code")
  ) |>
  filter(
    !is.na(region)
  ) |>
  mutate(
    decade = year - year %% 10
  ) |>
  group_by(region, country_code, decade) |>
  summarise(
    merit_criteria = mean(merit_criteria, na.rm = TRUE),
    impartial = mean(impartial, na.rm = TRUE),
    gdp_per_capita_ppp_2017 = mean(gdp_per_capita_ppp_2017, na.rm = TRUE),
    .groups = "drop"
  ) |>
  filter(
    gdp_per_capita_ppp_2017 > 0
  ) |>
  ggplot(
    aes(
      impartial,
      gdp_per_capita_ppp_2017
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
    se = FALSE,
    linetype = "dashed",
    color = "grey15"
  ) +
  labs(
    x = "Rigorous and impartial administration",
    y = "GDP per capita (PPP, in 2017 USD)"
  ) +
  scale_y_continuous(
    trans = "log10",
    label = scales::comma
  ) +
  scale_color_colorblind(
    name = "Region"
  ) +
  theme(
    legend.position = "bottom"
  ) +
  facet_wrap(
    vars(decade)
  )

ggsave(
  here("figs", "vdem", "02-fig_cor_impartial_gdp.png"),
  width = 12,
  height = 8,
  bg = "white"
)
