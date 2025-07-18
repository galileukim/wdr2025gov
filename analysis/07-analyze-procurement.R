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
    color = 'deepskyblue4',
    fill = 'slategray2'
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

# correlation between standards and practices
procurement |>
  ggplot(
    aes(
      transparency_p,
      transparency_l
    )
  ) +
  geom_point() +
  geom_smooth(
    method = "lm",
    formula = y ~ x + I(x^2),
    se = TRUE,
    color = 'deepskyblue4',
    fill = 'slategray2'
  ) +
  labs(
    x = "Procurement Standards",
    y = "Procurement Practice"
  )

ggsave(
  here("figs", "procurement", "03-correlation_procurement_law_practices.png"),
  width = 8,
  height = 6,
  dpi = 300
)

# correlation between standards and efficiency
procurement |>
  ggplot(
    aes(
      laws,
      quality
    )
  ) +
  geom_point() +
  geom_smooth(
    method = "lm",
    formula = y ~ x + I(x^2),
    se = TRUE,
    color = 'deepskyblue4',
    fill = 'slategray2'
  ) +
  labs(
    x = "Procurement Standards",
    y = "Procurement Quality"
  )

ggsave(
  here("figs", "procurement", "04-correlation_procurement_law_quality.png"),
  width = 8,
  height = 6,
  dpi = 300
)

# correlation between standards, practice, and quality
procurement |>
  select(
    Standards = laws,
    Practices = practices,
    Quality = quality
  ) |>
  pivot_longer(
    c(Standards, Practices)
  ) |>
  ggplot(
    aes(
      value,
      Quality,
      color = name
    )
  ) +
  geom_smooth(
    method = "lm",
    formula = y ~ x + I(x^2),
    se = TRUE,
    # color = 'deepskyblue4',
    fill = 'slategray2'
  ) +
  scale_color_colorblind(
    name = ""
  ) +
  labs(
    x = "Score",
    y = "Procurement Quality"
  )

ggsave(
  here("figs", "procurement", "05-correlation_procurement_law_practices_quality.png"),
  width = 8,
  height = 6,
  dpi = 300
)

# correlation between standards, practice, and integrity
procurement |>
  select(
    Standards = laws,
    Practices = practices,
    Integrity = integrity
  ) |>
  pivot_longer(
    c(Standards, Practices)
  ) |>
  ggplot(
    aes(
      value,
      Integrity,
      color = name
    )
  ) +
  geom_point(
    shape = 1
  ) +
  geom_smooth(
    method = "lm",
    formula = y ~ x + I(x^2),
    se = TRUE,
    # color = 'deepskyblue4',
    fill = 'slategray2'
  ) +
  scale_color_colorblind(
    name = ""
  ) +
  labs(
    x = "Score",
    y = "Procurement Integrity"
  )

# correlation between integrity and quality
procurement |>
  ggplot(
    aes(
      integrity,
      quality
    )
  ) +
  geom_point() +
  geom_smooth(
    method = "lm",
    formula = y ~ x + I(x^2),
    se = TRUE,
    color = 'deepskyblue4',
    fill = 'slategray2'
  ) +
  labs(
    x = "Procurement Integrity",
    y = "Procurement Quality"
  )

# compliance gap: laws minus practices
procurement |>
  mutate(
    compliance_gap = scale(practices) - scale(laws)
  ) |>
  ggplot(
    aes(
      compliance_gap,
      quality
    )
  ) +
  geom_point() +
  geom_smooth(
    method = "lm",
    formula = y ~ x + I(x^2),
    se = TRUE,
    color = 'deepskyblue4',
    fill = 'slategray2'
  ) +
  labs(
    x = "Compliance Gap (Practices - Standards)",
    y = "Procurement Quality"
  )

ggsave(
  here("figs", "procurement", "06-compliance_gap_procurement.png"),
  width = 8,
  height = 6,
  dpi = 300
)

# regression between standards and practices
procurement %>%
  lm(practices ~ laws + I(laws^2) + loggdp, data = .) |>
  summary()

# regression between quality (y) on laws and practices (x)
procurement %>%
  lm(quality ~ laws + practices + loggdp, data = .) |>
  summary()

# regression between quality (y) on laws and practices (x)
procurement %>%
  lm(integrity ~ laws + practices + loggdp, data = .) |>
  summary()

