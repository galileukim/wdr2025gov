# set-up ------------------------------------------------------------------
library(ggplot2)
library(ggthemes)
library(scales)
library(ggrepel)
library(tidyr)
library(forcats)
library(tidytext)

theme_set(
  theme_few(
    base_size = 18
  )
)

# analysis ----------------------------------------------------------------
wwbi_public_sector <- wwbi |>
  filter(
    region != "North America"
  ) |>
  left_join(
    labor,
    by = c("country_code", "year")
  ) |>
  filter(
    year <= 2018
  ) |>
  mutate(
    # multiply the share of public sector paid employees with
    # the total labor force, subtracting unemployment rate
    total_public_employees = (share_public_sector) *((100 - unemployment_rate)/100 * total_labor_force)
  )

wwbi_public_sector |>
  filter(country_code != "CHN") |>
  group_by(year) |>
  summarise(
    average_size_government = mean(total_public_employees, na.rm = TRUE),
    min_size = min(total_public_employees, na.rm = TRUE),
    max_size = max(total_public_employees, na.rm = TRUE),
    se_average_size = sd(total_public_employees, na.rm = TRUE)/sqrt(sum(!is.na(total_public_employees))),
    upper_ci = average_size_government + 1.96 * se_average_size,
    lower_ci = average_size_government - 1.96 * se_average_size
  ) |>
  ggplot() +
  geom_pointrange(
    aes(
      year,
      average_size_government,
      ymin = lower_ci,
      ymax = upper_ci
    )
  ) +
  labs(
    x = "Year",
    y = "Average Number of Public Sector Employees",
    caption = "Source: Worldwide Bureaucracy Indicators"
  )

ggsave(
  here("figs", "wwbi", "01-fig_mean_public_sector_annual.png"),
  width = 12,
  height = 8,
  bg = "white"
)

wwbi_public_sector |>
  # extract most recent year by country
  group_by(country_code) |>
  slice_max(
    order_by = year,
    n = 1
  ) |>
  ungroup() |>
  group_by(region) |>
  mutate(
    avg_share = mean(total_public_employees, na.rm = T),
    max_share = max(total_public_employees, na.rm = T),
    min_share = min(total_public_employees, na.rm = T)
  ) |>
  ggplot(
    aes(
      total_public_employees,
      region,
      color = region
    )
  ) +
  geom_pointrange(
    aes(
      xmin = min_share,
      xmax = max_share
    )
  ) +
  geom_text_repel(
    aes(
      y = region,
      x = total_public_employees,
      label = country_code
    ),
    size = 3, # Font size
    # nudge_x = -0.2, # Left aligned
    segment.color = NA,   # Delete connectors or arrows
    box.padding = 0.15, # Min Space between tags
    max.overlaps = 40
  ) +
  # facet_wrap(vars(region), scales = 'free') +
  labs(
    y = "Region",
    x = "Total public sector employees"
  ) +
  scale_x_continuous(
    labels = label_number(scale_cut = cut_short_scale())
  ) +
  scale_color_colorblind(
    name = "Region"
  ) +
  theme(
    legend.position = "none"
  )

ggsave(
  here("figs", "wwbi", "02-fig_total_public_sector_region.png"),
  width = 12,
  height = 8,
  bg = "white"
)

# correlation between public sector and economic development
wwbi_public_sector |>
  # extract most recent year by country
  group_by(country_code) |>
  slice_max(
    order_by = year,
    n = 1
  ) |>
  ungroup() |>
  left_join(
    wdi_gdp_pc,
    by = c("country_code", "year")
  ) |>
  ggplot(
    aes(
      gdp_per_capita_ppp_2017,
      share_public_sector
    )
  ) +
  geom_text(
    aes(
      label = country_code,
      color = region
    )
  ) +
  geom_smooth(
    method = "lm",
    se = FALSE,
    linetype = "dashed",
    color = "grey15"
  ) +
  labs(
    y = "Public sector employees (Share of total employment)",
    x = "GDP per capita (PPP, in 2017 USD)"
  ) +
  scale_x_continuous(
    trans = "log10",
    label = comma
  ) +
  scale_y_continuous(
    labels = scales::percent_format()
  ) +
  scale_color_colorblind(
    name = "Region"
  ) +
  theme(
    legend.position = "bottom"
  )

ggsave(
  here("figs", "wwbi", "03-fig_public_sector_gdp.png"),
  width = 12,
  height = 8,
  bg = "white"
)

wwbi_occupation |>
  left_join(
    countryclass,
    by = c("country_code")
  ) |>
  filter(
    !is.na(income_group)
  ) |>
  mutate(
    country_code = reorder_within(
      country_code,
      professional_and_technical,
      within = income_group
    )
  ) |>
  pivot_longer(
    cols = c(professional_and_technical, managerial, clerical, other),
    names_to = "occupation",
    values_to = "share"
  ) |>
  mutate(
    occupation = fct_relevel(
      occupation,
      c("professional_and_technical", "managerial", "clerical", "other") |> rev()
    ) |>
      fct_recode(
        "Professional and Technical" = "professional_and_technical",
        "Managerial" = "managerial",
        "Clerical" = "clerical",
        "Other" = "other"
      ),
    income_group = fct_relevel(
      income_group,
      c("Low income", "Lower middle income", "Upper middle income", "High income")
    )
  ) |>
  ggplot(
    aes(share, country_code)
  ) +
  geom_col(
    aes(fill = occupation)
  ) +
  facet_wrap(
    vars(income_group),
    scales = "free_y"
  ) +
  scale_y_reordered() +
  scale_fill_brewer(
    name = "Occupation",
    palette = "Paired"
  ) +
  scale_x_continuous(
    labels = scales::percent_format()
  ) +
  labs(
    x = "Share of Public Sector Employment",
    y = ""
  ) +
  guides(
    fill = guide_legend(reverse = TRUE)
  ) +
  theme(
    legend.position = "bottom"
  )

ggsave(
  here("figs", "wwbi", "04-fig_public_sector_occupation.png"),
  width = 14,
  height = 16,
  bg = "white"
)

wwbi_occupation |>
  left_join(
    wdi_gdp_pc |> group_by(country_code) |> slice_max(year, n = 1) |> ungroup(),
    by = c("country_code")
  ) |>
  left_join(
    countryclass,
    by = c("country_code")
  ) |>
  filter(
    !is.na(income_group)
  ) |>
  pivot_longer(
    cols = c(professional_and_technical, managerial, clerical, other),
    names_to = "occupation",
    values_to = "share"
  ) |>
  mutate(
    occupation = fct_relevel(
      occupation,
      c("professional_and_technical", "managerial", "clerical", "other") |> rev()
    ) |>
      fct_recode(
        "Professional and Technical" = "professional_and_technical",
        "Managerial" = "managerial",
        "Clerical" = "clerical",
        "Other" = "other"
      )
  ) |>
  filter(
    occupation == "Professional and Technical"
  ) |>
  ggplot(
    aes(gdp_per_capita_ppp_2017, share)
  ) +
  geom_text(
    aes(label = country_code, color = region)
  ) +
  geom_smooth(
    method = "lm",
    se = FALSE,
    linetype = "dashed",
    color = "grey15"
  ) +
  scale_color_colorblind(
    name = "Region"
  ) +
  scale_x_continuous(
    trans = "log10",
    label = comma
  ) +
  scale_y_continuous(
    labels = scales::percent_format()
  ) +
  labs(
    x = "GDP per capita (PPP, in 2017 USD)",
    y = "Share of Public Employees (Professional and Technical)"
  ) +
  theme(
    legend.position = "bottom"
  )

ggsave(
  here("figs", "wwbi", "05-fig_public_sector_occupation_gdp.png"),
  width = 12,
  height = 8,
  bg = "white"
)
