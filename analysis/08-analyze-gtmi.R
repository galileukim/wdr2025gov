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

# visualize ---------------------------------------------------------------
gtmi_cumulative <- gtmi |>
  pivot_longer(
    cols = c(ends_with("est")),
    values_to = "year",
    names_to = "system"
  ) |>
  mutate(
    system = recode(
      system,
      "hrmis_year_est" = "Human Resource MIS",
      "egp_year_est" = "eGP",
      "fmis_year_est" = "Financial MIS"
    )
  ) %>%
  count(
    system, year
  ) |>
  arrange(system, year) |>
  complete(
    system,
    year = 1984:2023,
    fill = list(n = 0)
  ) |>
  fill(system) |>
  group_by(system) |>
  mutate(
    cumulative_sum = cumsum(n)/198
  ) |>
  ungroup() |>
  filter(year >= 1984) |>
  rename(
    `Management Information System` = system
  )

gtmi_cumulative |>
  ggplot(
    aes(year, cumulative_sum, color = `Management Information System`)
  ) +
  geom_point(
    size = 3
  ) +
  geom_line(
    linewidth = 1
  ) +
  geom_label_repel(
    data = gtmi_cumulative %>%
      group_by(`Management Information System`) %>%
      slice_max(year, n = 1),
    aes(
      label = `Management Information System`
    ),
    nudge_x = 6
  ) +
  scale_x_continuous(
    breaks = seq(1990, 2020, 10),
    labels = seq(1990, 2020, 10),
    expand = expansion(mult = c(0, 0.2))
  ) +
  scale_y_continuous(
    labels = scales::percent_format()
  ) +
  scale_color_brewer(palette = "Paired") +
  coord_cartesian(
    clip = "off"
  ) +
  theme(
    legend.position = "none"
  ) +
  labs(
    x = "Year",
    y = "Cumulative Share of Countries"
  )

ggsave(
  here("figs", "gtmi", "01-gtmi_diffusion_mis.png"),
  width = 8,
  height = 6,
  dpi = 300
)
