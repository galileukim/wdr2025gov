# set-up ------------------------------------------------------------------
library(ggplot2)
library(ggthemes)
library(scales)
library(ggrepel)
library(dplyr)
library(here)

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
vdem |>
  inner_join(
    wdi_gdp_pc,
    by = c("country_code", "year")
  ) |>
  left_join(
    countryclass,
    by = c("country_code")
  ) |>
  filter(
    !is.na(region) &
      year == max(year)
  ) |>
  ggplot(
    aes(
      gdp_per_capita_ppp_2017,
      merit_criteria
    )
  ) +
  geom_point() +
  geom_smooth(
    method = "lm",
    formula = y ~ x + I(x^2),
    se = FALSE,
    color = 'deepskyblue4'
  ) +
  labs(
    y = "Meritocratic appointment",
    x = "GDP per capita (PPP, in 2017 USD)"
  ) +
  scale_x_continuous(
    trans = "log10",
    label = scales::comma
  )

ggsave(
  here("figs", "vdem", "01-fig_cor_merit_gdp.png"),
  width = 8,
  height = 6,
  dpi = 300
)

ggsave(
  here("figs", "vdem", "01-fig_cor_merit_gdp.eps"),
  width = 8,
  height = 6,
  dpi = 300
)

# vdem |>
#   left_join(
#     wdi_gdp_pc,
#     by = c("country_code", "year")
#   ) |>
#   left_join(
#     countryclass,
#     by = c("country_code")
#   ) |>
#   filter(
#     !is.na(region)
#   ) |>
#   mutate(
#     decade = year - year %% 10
#   ) |>
#   group_by(region, country_code, decade) |>
#   summarise(
#     merit_criteria = mean(merit_criteria, na.rm = TRUE),
#     impartial = mean(impartial, na.rm = TRUE),
#     gdp_per_capita_ppp_2017 = mean(gdp_per_capita_ppp_2017, na.rm = TRUE),
#     .groups = "drop"
#   ) |>
#   filter(
#     gdp_per_capita_ppp_2017 > 0
#   ) |>
#   ggplot(
#     aes(
#       impartial,
#       gdp_per_capita_ppp_2017
#     )
#   ) +
#   geom_text(
#     aes(
#       label = country_code,
#       color = region
#     )
#   ) +
#   geom_smooth(
#     method = "lm",
#     se = FALSE,
#     linetype = "dashed",
#     color = "grey15"
#   ) +
#   labs(
#     x = "Rigorous and impartial administration",
#     y = "GDP per capita (PPP, in 2017 USD)"
#   ) +
#   scale_y_continuous(
#     trans = "log10",
#     label = scales::comma
#   ) +
#   scale_color_colorblind(
#     name = "Region"
#   ) +
#   theme(
#     legend.position = "bottom"
#   ) +
#   facet_wrap(
#     vars(decade)
#   )
#
# ggsave(
#   here("figs", "vdem", "02-fig_cor_impartial_gdp.png"),
#   width = 12,
#   height = 8,
#   bg = "white"
# )
#
# # countries that enshrine meritocratic recruitment into their constitution
# # score better in meritocratic appointment?
# vdem |>
#   filter(year == 2023 & !is.na(country_code)) |>
#   inner_join(
#     constitution |> filter(year == 2023),
#     by = c("country_code", "year")
#   ) |>
#   ggplot(
#     aes(
#       merit_criteria,
#       constitution_meritocratic_recruitment
#     )
#   )
