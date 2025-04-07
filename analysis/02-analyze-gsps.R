# set-up ------------------------------------------------------------------
library(ggplot2)
library(ggthemes)
library(forcats)
library(tidyr)

theme_set(
  theme_few(
    base_size = 24
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

gsps_national |>
  filter(
    (indicator_group == "Recruitment standard: written examination" |
      indicator_group == "Recruitment standard: interview") &
      country_code != "ROU" &
    # there seems to be a coding error for Ghana w.r.t. interview
    country_code != "GHA"
  ) |>
  select(
    country_code, economy, year,
    indicator_group, mean
  ) |>
  pivot_wider(
    names_from = indicator_group,
    values_from = mean
  ) |>
  ggplot() +
  geom_text(
    aes(
      `Recruitment standard: written examination`,
      `Recruitment standard: interview`,
      label = economy,
      color = economy
    )
  ) +
  scale_color_expand(12) +
  scale_x_continuous(
    labels = scales::percent_format()
  ) +
  scale_y_continuous(
    labels = scales::percent_format()
  ) +
  theme(
    legend.position = "none"
  ) +
  ggtitle(
    "Countries apply both written exams\n and interviews",
    subtitle = "Share of Public Servants"
  ) +
  labs(
    caption = "Source: Global Survey of Public Servants"
  )

ggsave(
  here("figs", "gsps", "03-cor_exam_interview.png"),
  width = 10,
  height = 10,
  bg = "white"
)

gsps_institutional |>
  filter(
    (indicator_group == "Recruitment standard: written examination" |
       indicator_group == "Recruitment standard: interview") &
      country_code != "ROU" &
      # there seems to be a coding error for Ghana w.r.t. interview
      country_code != "GHA" &
      response_rate >= 0.1
  ) |>
  select(
    economy, year,
    category,
    indicator_group,
    mean
  ) |>
  pivot_wider(
    names_from = indicator_group,
    values_from = mean
  ) |>
  ggplot() +
  geom_point(
    aes(
      `Recruitment standard: written examination`,
      `Recruitment standard: interview`,
      color = economy
    )
  ) +
  scale_color_expand(12) +
  scale_x_continuous(
    labels = scales::percent_format()
  ) +
  scale_y_continuous(
    labels = scales::percent_format()
  ) +
  theme(legend.position = "none") +
  ggtitle(
    "Countries apply both written exams\n and interviews",
    subtitle = "Share of Public Servants per Institution"
  ) +
  labs(
    caption = "Source: Global Survey of Public Servants"
  )

ggsave(
  here("figs", "gsps", "03-cor_exam_interview_institution.png"),
  width = 10,
  height = 10,
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

