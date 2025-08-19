# set-up ------------------------------------------------------------------
library(ggplot2)
library(ggthemes)
library(scales)
library(ggrepel)
library(gghighlight)
library(dplyr)
library(forcats)
library(stringr)
library(tidyr)
library(ggbreak)
library(sf)
library(here)
library(wdr2025gov)

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

# fig 7.1. budget execution rate ------------------------------------------
budget_execution |>
  left_join(
    countryclass,
    by = c("country_code")
  ) |>
  left_join(
    wdi_gdp_pc |> mutate(year = as.character(year)),
    by = c("country_code", "year")
  ) |>
  filter(
    year == 2021
  ) |>
  ggplot(
    aes(
      gdp_per_capita_ppp_2017,
      budget_execution_rate
    )
  ) +
  geom_point() +
  geom_smooth(
    method = "lm",
    formula = y ~ x + I(x^2),
    se = FALSE,
    color='deepskyblue4'
  ) +
  geom_hline(
    yintercept = 100,
    linetype = "dashed"
  ) +
  scale_x_continuous(
    trans = "log10",
    labels = scales::comma
  ) +
  coord_cartesian(
    ylim = c(50, 150)
  ) +
  labs(
    x = "GDP per capita (PPP, in 2017 USD)",
    y = "Budget Execution Rate (% of original approved budget)"
  )

ggsave(
  here("figs", "replication", "fig_7_01_cor_gdp_vs_budgetexecution.png"),
  width = 8,
  height = 6,
  dpi = 300
)

ggsave(
  here("figs", "replication", "fig_7_01_cor_gdp_vs_budgetexecution.eps"),
  width = 8,
  height = 6,
  dpi = 300
)

# fig b.1. management quality firms ---------------------------------------
enterprise_surveys |>
  left_join(
    wdi_gdp_pc,
    by = c("country_code", "year")
  ) |>
  ggplot(
    aes(
      x = gdp_per_capita_ppp_2017,
      y = management_practices_index
    )
  ) +
  geom_smooth(
    method = "lm",
    formula = y ~ x + I(x^2),
    se = FALSE,
    color='deepskyblue4'
  ) +
  geom_point() +
  labs(
    x = "GDP per Capita (PPP, USD 2017)",
    y = "Management Practices Index"
  ) +
  scale_x_continuous(
    transform = "log10",
    labels = scales::comma
  )

ggsave(
  here("figs", "replication", "fig_7_b1_correlation_gdp_management.png"),
  dpi = 300,
  height = 6,
  width = 8
)

ggsave(
  here("figs", "replication", "fig_7_b1_correlation_gdp_management.eps"),
  dpi = 300,
  height = 6,
  width = 8
)

# fig 7.2. 50 largest public sectors --------------------------------------
wwbi_public_sector <- wwbi |>
  left_join(
    labor,
    by = c("country_code", "year")
  ) |>
  left_join(
    countryclass |> select(country_code, economy),
    by = "country_code"
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
  filter(
    !is.na(income_group) &
      total_public_employees > 1
  ) |>
  # extract most recent year by country
  group_by(economy) |>
  slice_max(
    order_by = year,
    n = 1
  ) |>
  ungroup() |>
  slice_max(
    n = 50,
    order_by = total_public_employees
  ) |>
  ggplot(
    aes(
      total_public_employees/1e6,
      reorder(economy, total_public_employees)
    )
  ) +
  geom_col(
    aes(
      fill = income_group
    )
  ) +
  scale_x_break(
    c(40, 100),
    ticklabels = seq(0, 130, by = 10)
  ) +
  labs(
    y = "Economy",
    x = "Total public sector employees (Millions)",
  ) +
  scale_fill_tableau(
    name = "Income Group"
  ) +
  guides(
    fill = guide_legend(
      nrow = 2,
      byrow = TRUE
    )
  ) +
  theme(
    legend.position = "bottom"
  )

ggsave(
  here("figs", "replication", "fig_7_02_total_public_sector_income_group.png"),
  width = 12,
  height = 10,
  bg = "white"
)

ggsave(
  here("figs", "replication", "fig_7_02_total_public_sector_income_group.eps"),
  width = 12,
  height = 10,
  bg = "white"
)

# fig 7.3. correlation economic development public sector -----------------
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
  geom_point() +
  geom_smooth(
    method = "lm",
    formula = y ~ x + I(x^2),
    se = FALSE,
    color = 'deepskyblue4'
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
  theme(
    legend.position = "bottom"
  )

ggsave(
  here("figs", "replication", "fig_7_03_public_sector_gdp.png"),
  width = 12,
  height = 8,
  bg = "white",
  dpi = 300
)

ggsave(
  here("figs", "replication", "fig_7_03_public_sector_gdp.eps"),
  width = 12,
  height = 8,
  bg = "white"
)

# fig 7.4. institutional variation exam -----------------------------------
gsps_institutional <- gsps |>
  filter(
    respondent_group == "Institution"
  )

gsps_national_merit <- gsps |>
  filter(
    respondent_group == "All"
  ) |>
  filter(
    indicator_group == "Recruitment standard: written examination" &
      country_code != "ROU"
  ) |>
  mutate(
    economy_fct = fct_reorder(economy, mean)
  )

gsps_institutional |>
  filter(
    indicator_group == "Recruitment standard: written examination" &
      country_code != "ROU"
  ) |>
  left_join_national(gsps_national_merit) |>
  group_by(economy) |>
  mutate(
    average = mean(mean),
    upper = max(mean),
    lower = min(mean)
  ) |>
  ggplot(
    aes(y = reorder(economy, average), color = economy)
  ) +
  geom_linerange(
    aes(
      xmin = lower,
      xmax = upper
    )
  ) +
  geom_point(
    aes(x = upper),
    size = 5
  ) +
  geom_point(
    aes(x = lower),
    size = 5
  ) +
  geom_point(
    aes(x = average),
    shape = 15,
    size = 5
  ) +
  geom_jitter(
    aes(
      x = mean
    ),
    height = 0.2,
    shape = 1
  ) +
  labs(x = "Share of Public Servants", y = "") +
  scale_color_expand(n_group = 11) +
  scale_x_continuous(
    labels = scales::percent_format()
  ) +
  theme(
    legend.position = "none"
  )

ggsave(
  here("figs", "replication", "fig_7_04_share_merit_institution.png"),
  width = 8,
  height = 6,
  dpi = 300
)

ggsave(
  here("figs", "replication", "fig_7_04_share_merit_institution.eps"),
  width = 8,
  height = 6
)

# fig 7.6.a. merit-based recruitment --------------------------------------
constitution_subset <- constitution |>
  filter(
    year >= 1960 & !is.na(country_code)
  ) |>
  classify_income_group()

# by income group: latest year
constitution_subset |>
  filter(
    !is.na(country_code) &
      !is.na(income_group)
  ) |>
  summarise_merit(
    c("year", "income_group"),
    agg_fun = "mean"
  ) |>
  ungroup() |>
  filter(
    year == max(year)
  ) |>
  ggplot() +
  geom_col(
    aes(
      income_group, merit
    ),
    width = 0.5
  ) +
  labs(
    x = "Income Group",
    y = "Share of Countries"
  ) +
  scale_y_continuous(
    labels = scales::percent_format()
  )

ggsave(
  here("figs", "replication",  "fig_7_06a_share_countries_merit_by_income_latest.png"),
  height = 6,
  width = 8,
  dpi = 300
)

ggsave(
  here("figs", "replication",  "fig_7_06a_share_countries_merit_by_income_latest.eps"),
  height = 6,
  width = 8
)

# fig 7.6.b. correlation economic dev and procurement law -----------------
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
    se = FALSE,
    color = 'deepskyblue4'
  ) +
  geom_point(
    aes(
      mean_gdp,
      mean_transparency
    ),
    data = procurement |>
      mutate(
        gdp_per_capita = exp(loggdp),
        gdp_bin = cut_number(gdp_per_capita, n = 20)  # averages across 20 bins
      ) |>
      group_by(gdp_bin) |>
      summarise(
        mean_gdp = mean(gdp_per_capita, na.rm = TRUE),
        mean_transparency = mean(transparency_l, na.rm = TRUE),
        .groups = "drop"
      )
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
  here("figs", "replication", "fig_7_06b_procurement_transparency_standards.png"),
  width = 8,
  height = 6,
  dpi = 300
)

ggsave(
  here("figs", "replication", "fig_7_06b_procurement_transparency_standards.eps"),
  width = 8,
  height = 6
)


# fig 7.7. budget transparency --------------------------------------------
wdi_gdp_pc |>
  left_join(
    open_budget |> mutate(year = year - 1),
    by = c("country_code", "year")
  ) |>
  filter(
    year == 2022
  ) |>
  left_join(
    countryclass,
    by = c("country_code")
  ) |>
  ggplot(
    aes(
      x = gdp_per_capita_ppp_2017,
      y = budget_transparency_score
    )
  ) +
  geom_point() +
  geom_smooth(
    method = "lm",
    formula = y ~ x + I(x^2),
    se = FALSE,
    color = 'deepskyblue4'
  ) +
  labs(
    x = "GDP per Capita (PPP, USD 2017)",
    y = "Budget Transparency Score"
  ) +
  scale_x_continuous(
    transform = "log10",
    labels = scales::comma
  ) +
  scale_color_brewer(
    palette = "Paired"
  ) +
  theme(
    legend.position = "bottom"
  )

ggsave(
  here("figs", "replication", "fig_7_07_cor_budget_transparency_vs_gdp_per_capita.png"),
  width = 8,
  height = 6,
  dpi = 300
)

ggsave(
  here("figs", "replication", "fig_7_07_cor_budget_transparency_vs_gdp_per_capita.eps"),
  width = 8,
  height = 6
)

# fig 7.8. correlation merit vs. economic dev -----------------------------
vdem |>
  inner_join(
    wdi_gdp_pc,
    by = c("country_code", "year")
  ) |>
  left_join(
    countryclass,
    by = c("country_code")
  ) |>
  filter(
    !is.na(region) &
      year == max(year)
  ) |>
  ggplot(
    aes(
      gdp_per_capita_ppp_2017,
      merit_criteria
    )
  ) +
  geom_point() +
  geom_smooth(
    method = "lm",
    formula = y ~ x + I(x^2),
    se = FALSE,
    color = 'deepskyblue4'
  ) +
  labs(
    y = "Meritocratic appointment",
    x = "GDP per capita (PPP, in 2017 USD)"
  ) +
  scale_x_continuous(
    trans = "log10",
    label = scales::comma
  )

ggsave(
  here("figs", "replication", "fig_7_08_cor_merit_gdp.png"),
  width = 8,
  height = 6,
  dpi = 300
)

ggsave(
  here("figs", "replication", "fig_7_08_cor_merit_gdp.eps"),
  width = 8,
  height = 6,
  dpi = 300
)

# fig 7.9. procurement compliance gap -------------------------------------
procurement |>
  left_join(
    countryclass,
    by = c("country_code")
  ) |>
  # remove country observations missing an income group
  filter(
    !is.na(income_group)
  ) |>
  mutate(
    compliance_gap = scale(practices) - scale(laws)
  ) |>
  ggplot(
    aes(
      compliance_gap,
      quality
    )
  ) +
  geom_point(
    aes(
      color = income_group
    )
  ) +
  geom_smooth(
    method = "lm",
    formula = y ~ x + I(x^2),
    se = FALSE,
    color = 'deepskyblue4'
  ) +
  scale_color_tableau(
    name = "Income Group"
  ) +
  guides(
    color = guide_legend(
      nrow = 2,
      byrow = TRUE
    )
  ) +
  theme(
    legend.position = "bottom"
  ) +
  labs(
    x = "Compliance Gap (Practices - Standards)",
    y = "Procurement Quality"
  )

ggsave(
  here("figs", "procurement", "fig_7_09_compliance_gap_procurement.png"),
  width = 8,
  height = 6,
  dpi = 300
)

ggsave(
  here("figs", "procurement", "fig_7_09_compliance_gap_procurement.eps"),
  width = 8,
  height = 6
)

# fig 7.10. hiring pattern ------------------------------------------------
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
  here("figs", "replication", "fig_7_11_rais_mun_hiring_cycles.png"),
  dpi = 300,
  height = 6,
  width = 8
)

ggsave(
  here("figs", "replication", "fig_7_11_rais_mun_hiring_cycles.eps"),
  height = 6,
  width = 8
)

# map 7.1. procurement delays ---------------------------------------------
mides_2018 <- mides |>
  filter(year == 2018 & weighted_average_delay != "") |>
  select(municipality_code, weighted_average_delay)

mides_mun_shp <- brazil_mun_shp |>
  filter(
    sigla_rg %in% c("SE", "S")
  )

mides_shp <- mides_mun_shp |>
  left_join(
    mides_2018 |> mutate(municipality_code = as.character(municipality_code)),
    by = "municipality_code"
  )

mides_shp |>
  ggplot() +
  geom_sf(
    aes(fill = weighted_average_delay),
    color = NA
  ) +
  scale_fill_distiller(
    palette = "RdYlBu",
    na.value = "grey95"
  ) +
  labs(
    fill = "Procurement payment delays, weighted average (days)"
  ) +
  coord_sf(
    xlim = c(-60, -40),
    expand = FALSE  # prevents extra white space
  ) +
  theme_void() +
  theme(legend.position = "bottom")

ggsave(
  here("figs", "replication", "map_7_1_brazil_mun_procurement_delays.png"),
  width = 10,
  height = 10,
  dpi = 300,
  bg = "white"
)

ggsave(
  here("figs", "replication", "map_7_1_brazil_mun_procurement_delays.eps"),
  width = 10,
  height = 10,
  bg = "white"
)


# fig 7.12. correlation performance vs. work motivation -------------------
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

gsps_institutional_performance |>
  group_by(economy) |>
  mutate(
    `Performance standard: promotion` = scale(`Performance standard: compensation`),
    `Work motivation` = scale(`Work motivation`)
  ) |>
  ggplot(
    aes(
      x = `Performance standard: promotion`,
      y = `Work motivation`
    )
  ) +
  geom_point() +
  geom_smooth(
    color = "deepskyblue4",
    method = "lm",
    formula = y ~ x + I(x^2),
    se = TRUE,
    fill ='slategray2'
  ) +
  labs(x = "Performance-related promotion", y = "Work motivation")

ggsave(
  here("figs", "replication", "fig_7_12_performance_motivation_mission.png"),
  width = 8,
  height = 6,
  dpi = 300
)

ggsave(
  here("figs", "replication", "fig_7_12_performance_motivation_mission.eps"),
  width = 8,
  height = 6
)

# fig 7.13. diffusion mis -------------------------------------------------
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
  here("figs", "replication", "fig_7_13_gtmi_diffusion_mis.png"),
  width = 8,
  height = 6,
  dpi = 300
)

ggsave(
  here("figs", "replication", "fig_7_13_gtmi_diffusion_mis.eps"),
  width = 8,
  height = 6
)
