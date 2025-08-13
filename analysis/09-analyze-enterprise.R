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
  here("figs", "enterprise-surveys", "correlation_gdp_management.png"),
  dpi = 300,
  height = 6,
  width = 8
)

ggsave(
  here("figs", "enterprise-surveys", "correlation_gdp_management.eps"),
  dpi = 300,
  height = 6,
  width = 8
)
