#' Reproduce analysis for WDR 2025, Chapter 7: Standards for Better Governance
#'
#' This function sources and runs an R script to reproduce all figures contained in Chapter 7 of the WDR 2025.
#' It executes the script in a local environment so that objects created in the
#' script do not pollute the global environment.
#'
#' @param reproducibility_file A character string specifying the path to the R script
#'   to source. Defaults to `"analysis/analyze-wdr2025gov.R"`.
#'
#' @return The function is called for its side effects (e.g., generating plots).
#'
#' @examples
#' \dontrun{
#' # Run the default analysis script
#' reproduce_analysis()
#'
#' # Run a custom analysis script
#' reproduce_analysis("scripts/my_analysis.R")
#' }
#'
#' @export
reproduce_analysis <- function(reproducibility_file = "analysis/analyze-wdr2025gov.R"){
  source(reproducibility_file, local = TRUE)
}
