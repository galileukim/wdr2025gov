# merge municipal shape files with mides ----------------------------------
library(dplyr)
library(sf)
library(ggplot2)

# join data ---------------------------------------------------------------
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

# plot --------------------------------------------------------------------
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
    fill = "Weighted average delay (days)"
  ) +
  coord_sf(
    xlim = c(-60, -40),
    expand = FALSE  # prevents extra white space
  ) +
  theme_void() +
  theme(legend.position = "bottom")

ggsave(
  here("figs", "mides", "01-maps_delays.png"),
  width = 10,
  height = 10,
  dpi = 300,
  bg = "white"
)
