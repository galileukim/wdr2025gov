## code to prepare `wdi` dataset goes here
wdi <- fetch_prosperitydata360_data(
  "WB.WDI",
  "WB.WDI.NY.GDP.PCAP.PP.KD"
)

eout <- req_perform(req)

query_json <- resp_body_json(resp = eout)

tibble(json = resp_body_json(resp = eout)[["value"]]) |>
  unnest_wider(col = json)

usethis::use_data(wdi, overwrite = TRUE)
