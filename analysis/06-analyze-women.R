# set-up ------------------------------------------------------------------
library(ggplot2)
library(ggthemes)
library(scales)
library(ggrepel)
library(forcats)
library(tidytext)

theme_set(
  theme_few(
    base_size = 18
  )
)

# analysis ----------------------------------------------------------------
women_ministry |>
  left_join(
    countryclass,
    by = c("country_code")
  ) |>
  filter(
    !(region %in% c("North America") | is.na(region))
  ) |>
  na.omit() |>
  group_by(country_code) |>
  slice_max(
    n = 1, order_by = year
  ) |>
  ungroup() |>
  mutate(
    country_code = reorder_within(
      country_code,
      by = prop_women_ministry,
      within = region
    )
  ) |>
  ggplot(
    aes(
      x = prop_women_ministry,
      y = country_code,
      fill = region
    )
  ) +
  geom_col() +
  geom_vline(
    xintercept = 50,
    linetype = 'dashed'
  ) +
  facet_wrap(
    vars(region),
    scales = "free_y"
  ) +
  scale_x_continuous(
    breaks = seq(0, 60, by = 10)
  ) +
  scale_y_reordered() +
  theme(
    legend.position = "none"
  ) +
  labs(
    x = "Share of women in ministry-level position (%)",
    y = "Country"
  ) +
  scale_fill_colorblind()

ggsave(
  here("figs", "women-ministry", "01-fig_share_women_ministry.png"),
  width = 18,
  height = 16,
  bg = "white"
)
