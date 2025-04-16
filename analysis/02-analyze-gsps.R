# set-up ------------------------------------------------------------------
library(ggplot2)
library(ggthemes)
library(forcats)
library(tidyr)
library(broom)
library(stringr)

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

# recruitment standards
gsps_national_merit <- gsps_national |>
  filter(
    indicator_group == "Recruitment standard: written examination" &
      country_code != "ROU"
  ) |>
  mutate(
    economy_fct = fct_reorder(economy, mean)
  )

# performance
gsps_national_performance <- gsps_national |>
  filter(
    indicator_group == "Performance standard: evaluation" &
      scale == "0--1"
  ) |>
  mutate(
    economy_fct = fct_reorder(economy, mean)
  )

gsps_national_performance_comp <- gsps_national |>
  filter(
    indicator_group == "Performance standard: compensation"
  ) |>
  mutate(
    economy_fct = fct_reorder(economy, mean)
  )

gsps_national_performance_promotion <- gsps_national |>
  filter(
    indicator_group == "Performance standard: promotion"
  ) |>
  filter(
    # only present one value for country. exceptions: Uruguay, Armenia, and Chile for similarly
    # worded questions
    !(economy %in% c("Chile", "Uruguay", "Armenia")) |
      (
        (economy == "Chile" & str_detect(question_text, "A positive evaluation")) |
          (economy == "Uruguay" & str_detect(question_text, "On a scale of 1 to 5")) |
          (economy == "Armenia" & str_detect(question_text, "What do you think"))
      )
  ) |>
  mutate(
    economy_fct = fct_reorder(economy, mean)
  )

gsps_institutional_performance <- gsps_institutional |>
  filter(
    indicator_group == "Performance standard: promotion"
  ) |>
  filter(
    # only present one value for country. exceptions: Uruguay and Chile for similarly
    # worded questions
    !(economy %in% c("Chile", "Uruguay", "Armenia")) |
      (
        (economy == "Chile" & str_detect(question_text, "A positive evaluation")) |
          (economy == "Uruguay" & str_detect(question_text, "On a scale of 1 to 5")) |
          (economy == "Armenia" & str_detect(question_text, "What do you think"))
      )
  ) |>
  bind_rows(
    gsps_institutional |>
      filter(
        indicator_group == "Performance standard: compensation" |
          indicator == "Work motivation" |
          indicator == "Clear link between work and mission"
      )
  ) |>
  mutate(
    indicator_group = case_when(
      indicator == "Work motivation" ~ "Work motivation",
      indicator == "Clear link between work and mission" ~ "Mission orientation",
      T ~ indicator_group
    )
  ) |>
  select(
    country_code, category, economy, year,
    indicator_group, mean
  ) |>
  pivot_wider(
    names_from = indicator_group,
    values_from = mean
  )

# analysis ----------------------------------------------------------------
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


# recruitment -------------------------------------------------------------
gsps_national |>
  filter(
    (indicator_group == "Recruitment standard: written examination" |
      indicator == "Work motivation") &
      country_code != "ROU" &
    # there seems to be a coding error for Ghana w.r.t. interview
    country_code != "GHA"
  ) |>
  mutate(
    indicator_group = if_else(
      indicator == "Work motivation",
      "Work motivation",
      indicator_group
    )
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
      `Work motivation`,
      label = economy,
      color = economy
    )
  ) +
  scale_color_expand(16) +
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
  here("figs", "gsps", "04-cor_exam_interview_institution.png"),
  width = 10,
  height = 10,
  bg = "white"
)

# performance -------------------------------------------------------------
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
  scale_color_expand(6) +
  # ggtitle(
  #   "The implementation of performance-based pays is uneven across countries"
  # ) +
  labs(
    caption = "Source: Global Survey of Public Servants"
  )

ggsave(
  here("figs", "gsps", "05-fig_share_performance.png"),
  width = 12,
  height = 8,
  bg = "white"
)

gsps_institutional |>
  filter(
    indicator_group == "Performance standard: evaluation" &
      scale == "0--1"
  ) |>
  left_join_national(gsps_national_performance) |>
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
  theme(
    legend.position = "none"
  ) +
  scale_x_continuous(
    limits = c(0, 1),
    labels = scales::percent_format()
  ) +
  scale_color_expand(6) +
  # ggtitle(
  #   "The implementation of performance-based pays is uneven across countries"
  # ) +
  labs(
    caption = "Source: Global Survey of Public Servants"
  )

ggsave(
  here("figs", "gsps", "06-fig_share_performance_institution.png"),
  width = 12,
  height = 8,
  bg = "white"
)

# performance related pay
gsps_national_performance_comp |>
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
  scale_color_expand(13) +
  labs(
    caption = "Source: Global Survey of Public Servants"
  )

ggsave(
  here("figs", "gsps", "07-fig_share_performance_comp.png"),
  width = 12,
  height = 8,
  bg = "white"
)

gsps_institutional |>
  filter(
    indicator_group == "Performance standard: compensation"
  ) |>
  left_join_national(
    gsps_national_performance_comp
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
  scale_color_expand(13) +
  theme(
    legend.position = "none"
  )

ggsave(
  here("figs", "gsps", "08-fig_share_performance_comp_institution.png"),
  width = 12,
  height = 8,
  bg = "white"
)

# performance related promotion
gsps_national_performance_promotion |>
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
  scale_color_expand(16) +
  labs(
    caption = "Source: Global Survey of Public Servants"
  )

ggsave(
  here("figs", "gsps", "09-fig_share_performance_promotion.png"),
  width = 12,
  height = 8,
  bg = "white"
)

gsps_institutional |>
  filter(
    indicator_group == "Performance standard: promotion"
  ) |>
  left_join_national(
    gsps_national_performance_promotion
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
  scale_color_expand(16) +
  theme(
    legend.position = "none"
  )

ggsave(
  here("figs", "gsps", "08-fig_share_performance_comp_institution.png"),
  width = 12,
  height = 8,
  bg = "white"
)

# correlation between performance evaluation and performance-based promotion
gsps_national |>
  filter(
    (indicator_group == "Performance standard: evaluation" |
       indicator_group == "Performance standard: compensation")
    & country_code != "URY"
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
      `Performance standard: evaluation`,
      `Performance standard: compensation`,
      label = economy,
      color = economy
    )
  ) +
  # scale_color_expand(12) +
  scale_x_continuous(
    labels = scales::percent_format()
  ) +
  scale_y_continuous(
    labels = scales::percent_format()
  ) +
  theme(
    legend.position = "none"
  ) +
  # ggtitle(
  #   "Countries apply both written exams\n and interviews",
  #   subtitle = "Share of Public Servants"
  # ) +
  labs(
    caption = "Source: Global Survey of Public Servants"
  )

gsps_institutional_performance |>
  ggplot(
    aes(
      `Performance standard: compensation`,
      `Work motivation`
    )
  ) +
  geom_point(
    aes(
      color = economy
    ),
    alpha = 0.6
  ) +
  # scale_color_expand(12) +
  scale_x_continuous(
    labels = scales::percent_format()
  ) +
  scale_y_continuous(
    labels = scales::percent_format()
  ) +
  theme(
    legend.position = "none"
  ) +
  geom_smooth(
    method = "lm"
  ) +
  # ggtitle(
  #   "Countries apply both written exams\n and interviews",
  #   subtitle = "Share of Public Servants"
  # ) +
  labs(
    caption = "Source: Global Survey of Public Servants"
  )

gsps_institutional_performance |>
  ggplot(
    aes(
      `Performance standard: promotion`,
      `Work motivation`,
    )
  ) +
  geom_point(
    aes(
      color = economy
    ),
    alpha = 0.6
  ) +
  geom_smooth(
    method = "lm"
  ) +
  # scale_color_expand(12) +
  scale_x_continuous(
    labels = scales::percent_format()
  ) +
  scale_y_continuous(
    labels = scales::percent_format()
  ) +
  theme(
    legend.position = "none"
  ) +
  labs(
    caption = "Source: Global Survey of Public Servants"
  )

# regression analysis -----------------------------------------------------
lm_performance_promotion_motivation <- lm(
  `Work motivation` ~ `Performance standard: promotion` + as.factor(economy),
  data = gsps_institutional_performance
) |>
  tidy(conf.int = TRUE)

lm_performance_promotion_mission <-  lm(
  `Mission orientation` ~ `Performance standard: promotion` + as.factor(economy),
  data = gsps_institutional_performance
) |>
  tidy(conf.int = TRUE)

lm_performance_compensation_motivation <- lm(
  `Work motivation` ~ `Performance standard: compensation` + as.factor(economy),
  data = gsps_institutional_performance
) |>
  tidy(conf.int = TRUE)

lm_performance_compensation_mission <-  lm(
  `Mission orientation` ~ `Performance standard: compensation` + as.factor(economy),
  data = gsps_institutional_performance
) |>
  tidy(conf.int = TRUE)

list(
  "Work motivation" = lm_performance_promotion_motivation,
  "Work motivation" = lm_performance_compensation_motivation,
  "Mission orientation" = lm_performance_promotion_mission,
  "Mission orientation" = lm_performance_compensation_mission
  ) |>
  bind_rows(
    .id = "model"
  ) |>
  filter(
    str_detect(term, "Performance")
  ) |>
  mutate(
    term = str_replace_all(term, "`" , "")
  ) |>
  ggplot(
    aes(term, estimate, color = model)
  ) +
  geom_pointrange(
    aes(ymin = conf.low, ymax = conf.high),
    position = position_dodge(width = 0.5)

  ) +
  geom_hline(
    yintercept = 0,
    linetype = "dashed"
  ) +
  scale_color_colorblind(
    name = "Outcome"
  ) +
  coord_cartesian(
    ylim = c(-0.05, 0.2)
  ) +
  theme(
    legend.position = "bottom"
  ) +
  labs(
    x = "", y = "Coefficient"
  )

ggsave(
  here("figs", "gsps", "10-fig_reg_performance_institution.png"),
  width = 12,
  height = 8,
  bg = "white"
)
