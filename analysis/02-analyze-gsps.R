gsps_national <- gsps |>
  filter(group == "All")

gsps_institutional <- gsps |>
  filter(
    group == "Institution"
  )

gsps_national |>
  glimpse()
