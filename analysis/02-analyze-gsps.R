# set-up ------------------------------------------------------------------
library(ggplot2)
library(hrbrthemes)

theme_set(
  theme_ipsum()
)

# read-in data ------------------------------------------------------------
gsps_national <- gsps |>
  filter(group == "All")

gsps_institutional <- gsps |>
  filter(
    group == "Institution"
  )

gsps_regional <- gsps |>
  filter(
    group == "Region"
  )

# analysis ----------------------------------------------------------------
gsps_national |>
  ggplot() +
  geom_point
