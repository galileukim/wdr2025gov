# set-up ------------------------------------------------------------------
library(ggplot2)
library(ggthemes)
library(forcats)

theme_set(
  theme_few(
    base_size = 18
  )
)

ggplot_pointrange <- function(data, x, y, ...){
  ggplot(data) +
    geom_pointrange(
      aes(
        x = {{x}},
        y = fct_reorder({{y}}, {{x}}),
        xmin = lower_ci,
        xmax = upper_ci,
        ...
      )
      # color = "firebrick"
    ) +
    scale_x_continuous(
      labels = scales::percent_format()
    ) +
    labs(
      x = "Share of respondents",
      y = "Economy"
    )
}

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
  scale_color_manual(
    values = colorRampPalette(brewer.pal(name = "Paired", n = 8))(11)
  )
  # scale_color_colorblind(
  #   name = "Income group"
  # ) +
  # labs(
  #   x = "Share of respondents",
  #   y = "Economy"
  # )

ggsave(
  here("figs", "fig_share_merit.png"),
  width = 12,
  height = 8,
  bg = "white"
)

gsps_institutional |>
  filter(
    indicator_group == "Recruitment standard: written examination" &
      country_code != "ROU"
  ) |>
  left_join(
    gsps_national_merit |> select(country_code, economy_fct, country_mean = mean),
    by = c("country_code")
  ) |>
  group_by(
    country_code
  ) |>
  mutate(
    upper_ci = max(mean),
    lower_ci = min(mean)
  ) |>
  ggplot_pointrange(
    country_mean, economy,
    color = economy_fct
  ) +
  geom_jitter(
    aes(
      x = mean, y = economy,
      color = economy_fct
    ),
    alpha = 0.6
  ) +
  scale_color_manual(
    values = colorRampPalette(brewer.pal(name = "Paired", n = 8))(11)
  ) +
  theme(
    legend.position = "none"
  )

ggsave(
  here("figs", "fig_share_merit_institution.png"),
  width = 12,
  height = 8,
  bg = "white"
)
