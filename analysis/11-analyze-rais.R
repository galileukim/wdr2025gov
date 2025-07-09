# set-up ------------------------------------------------------------------
library(ggplot2)
library(dplyr)
library(broom)
library(here)
library(stringr)

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
# plot electoral cycles in hiring at the municipal level
rais_mun |>
  group_by(ano) |>
  summarise(
    share_new_hire = mean(share_new_hire, na.rm = TRUE),
  )

lm(
  share_new_hire ~ as.factor(ano),
  data = rais_mun |> filter(ano != 2023)
  # excluding measurement error in 2023,
  # where only 589 (out of 5000) municipalities are available
) |>
  tidy() |> glimpse()
  mutate(
    term = case_when(
      term == "(Intercept)" ~ 2003,
      TRUE ~ as.numeric(str_extract(term, "\\d{4}"))
    )
  ) |>
  # drop intercept
  filter(
    !(term %in% c("2003"))
  ) |>
  # plot coefficients and confidence intervals per year
  ggplot(
    aes(x = term, y = estimate)
  ) +
  geom_point() +
  geom_pointrange(
    aes(
      ymin = estimate - 1.96*std.error,
      ymax = estimate + 1.96*std.error
    )
  ) +
  geom_vline(
    xintercept = seq(2005, 2021, 4),
    linetype = "dashed"
  )

# share of new hires
rais_mun |>
  filter(ano <= 2022) |>
  group_by(ano) |>
  summarise(
    share_new_hires_weighted_avg = weighted.mean(
      share_new_hire,
      total_headcount,
      na.rm = TRUE
    ),
    .groups = "drop"
  ) |>
  ggplot(
    aes(x = ano, y = share_new_hires_weighted_avg)
  ) +
  geom_point(
    color = 'deepskyblue4'
  ) +
  geom_line(
    color = 'deepskyblue4'
  ) +
  geom_vline(
    xintercept = seq(2005, 2021, 4),
    linetype = "dashed",
    color = 'slategray3'
  ) +
  annotate(
    geom = "text",
    x = 2005.5,
    y = 0.14,
    label = c("Start of new \nmayoral term"),
    color = 'slategray3',
    hjust = 0,
    size = 5
  ) +
  scale_y_continuous(
    labels = scales::percent_format()
  ) +
  coord_cartesian(
    ylim = c(0, 0.15)
  ) +
  labs(
    x = "Year",
    y = "New hires (% of municipal headcount)"
  )

ggsave(
  here("figs", "rais", "rais_mun_hiring_cycles.png"),
  dpi = 300,
  height = 6,
  width = 8
)
