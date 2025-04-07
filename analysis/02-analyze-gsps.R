# set-up ------------------------------------------------------------------
library(ggplot2)
library(ggthemes)
library(forcats)

theme_set(
  theme_few(
    base_size = 18
  )
)

# read-in data ------------------------------------------------------------
gsps_national <- gsps |>
  filter(
    respondent_group == "All"
  )

gsps_institutional <- gsps |>
  filter(
    respondent_group == "Institution"
  )

gsps_regional <- gsps |>
  filter(
    respondent_group == "Region"
  )

# analysis ----------------------------------------------------------------
# recruitment standards
gsps_national_merit <- gsps_national |>
  filter(
    indicator_group == "Recruitment standard: written examination" &
      country_code != "ROU"
  ) |>
  mutate(
    economy_fct = fct_reorder(economy, mean)
  )

gsps_national_merit |>
  ggplot_pointrange(
    mean, economy,
    color = economy_fct
  ) +
  theme(
    legend.position = "none"
  ) +
  scale_color_expand(n_group = 11)

ggsave(
  here("figs", "gsps", "01-fig_share_merit.png"),
  width = 12,
  height = 8,
  bg = "white"
)

gsps_institutional |>
  filter(
    indicator_group == "Recruitment standard: written examination" &
      country_code != "ROU"
  ) |>
  left_join_national(gsps_national_merit) |>
  ggplot_boxplot(
    mean, economy,
    color = economy_fct
  ) +
  geom_jitter(
    aes(
      x = mean, y = economy,
      color = economy_fct
    ),
    alpha = 0.6
  ) +
  scale_color_expand(n_group = 11) +
  theme(
    legend.position = "none"
  )

ggsave(
  here("figs", "gsps", "02-fig_share_merit_institution.png"),
  width = 12,
  height = 8,
  bg = "white"
)

# performance management standards
gsps_national_performance <- gsps_national |>
  filter(
    indicator_group == "Performance standard: evaluation" &
      scale == "0--1"
  ) |>
  mutate(
    economy_fct = fct_reorder(economy, mean)
  )

gsps_national_performance |>
  ggplot_pointrange(
    mean, economy,
    color = economy_fct
  ) +
  theme(
    legend.position = "none"
  ) +
  scale_x_continuous(
    limits = c(0, 1),
    labels = scales::percent_format()
  ) +
  scale_color_expand(6)

ggsave(
  here("figs", "gsps", "03-fig_share_performance_eval.png"),
  width = 12,
  height = 8,
  bg = "white"
)

gsps_institutional |>
  filter(
    indicator_group == "Performance standard: evaluation" &
      scale == "0--1"
  ) |>
  left_join_national(
    gsps_national_performance
  ) |>
  ggplot_boxplot(
    mean, economy,
    color = economy_fct
  ) +
  geom_jitter(
    aes(
      x = mean, y = economy,
      color = economy_fct
    ),
    alpha = 0.6
  ) +
  scale_color_expand(6) +
  theme(
    legend.position = "none"
  )

ggsave(
  here("figs", "gsps", "04-fig_share_performance_eval_institution.png"),
  width = 12,
  height = 8,
  bg = "white"
)

# correlation between performance evaluation and performance-based promotion


