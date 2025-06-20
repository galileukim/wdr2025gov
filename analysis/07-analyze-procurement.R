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

# visualize data ----------------------------------------------------------
# transparency laws
procurement |>
  mutate(
    gdp_per_capita = exp(loggdp)
  ) |>
  ggplot(
    aes(
      gdp_per_capita,
      transparency_l
    )
  ) +
  geom_smooth(
    method = "lm",
    formula = y ~ x + I(x^2),
    se = TRUE,
    color='deepskyblue4',
    fill='slategray2'
  ) +
  scale_x_continuous(
    trans = "log10",
    labels = scales::comma
  ) +
  labs(
    x = "GDP per capita (PPP, in 2017 USD)",
    y = "Procurement Transparency Standards"
  )

ggsave(
  here("figs", "procurement", "01-procurement_transparency_standards.png"),
  width = 8,
  height = 6,
  dpi = 300
)

# practices
procurement |>
  mutate(
    gdp_per_capita = exp(loggdp)
  ) |>
  ggplot(
    aes(
      gdp_per_capita,
      practices
    )
  ) +
  geom_smooth(
    method = "lm",
    formula = y ~ x + I(x^2),
    se = TRUE,
    color='deepskyblue4',
    fill='slategray2'
  ) +
  scale_x_continuous(
    trans = "log10",
    labels = scales::comma
  ) +
  labs(
    x = "GDP per capita (PPP, in 2017 USD)",
    y = "Procurement Practice"
  )

ggsave(
  here("figs", "procurement", "02-procurement_practices.png"),
  width = 8,
  height = 6,
  dpi = 300
)
