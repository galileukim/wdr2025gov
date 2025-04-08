#' Fetch data from Prosperity Data 360 API
#'
#' @param dataset_id Dataset ID
#' @param indicator_ids Indicator IDs
#'
#' @import dplyr jsonlite httr
#'
#' @return A dataset from the Prosperity Data 360 API
#' @export
#'
fetch_prosperitydata360_data <- function(dataset_id, indicator_ids) {
  base_url <- "https://datacatalogapi.worldbank.org/dexapps/efi/data"
  count_url <- paste0(base_url, "?datasetId=", dataset_id, "&indicatorIds=", paste(indicator_ids, collapse = ","), "&top=0&skip=0")

  # Get count of total rows
  count_response <- GET(count_url)

  # Check for HTTP errors
  if (http_error(count_response)) {
    print(paste("Error fetching data for dataset", dataset_id, ":", content(count_response, "text")))
    return(NULL)
  }

  count_data <- content(count_response, "text")
  count_data <- fromJSON(count_data)
  total_count <- count_data$count

  # Fetch data in chunks if total count > 1000
  if(total_count > 1000) {
    all_data <- data.frame()
    for (i in seq(0, total_count, 1000)) {
      fetch_url <- paste0(base_url, "?datasetId=", dataset_id, "&indicatorIds=", paste(indicator_ids, collapse = ","), "&top=1000&skip=", i)
      response <- GET(fetch_url)

      # Check for HTTP errors
      if (http_error(response)) {
        print(paste("Error fetching data for dataset", dataset_id, "at skip", i, ":", content(response, "text")))
        return(NULL)
      }

      data <- content(response, "text")
      data <- fromJSON(data)
      all_data <- bind_rows(all_data, data$value)
    }
    return(all_data)
  } else {
    # Fetch all data at once
    fetch_url <- paste0(base_url, "?datasetId=", dataset_id, "&indicatorIds=", paste(indicator_ids, collapse = ","), "&top=", total_count)
    response <- GET(fetch_url)

    # Check for HTTP errors
    if (http_error(response)) {
      print(paste("Error fetching data for dataset", dataset_id, ":", content(response, "text")))
      return(NULL)
    }

    data <- content(response, "text")
    data <- fromJSON(data)
    return(data$value)
  }
}

#' Fetch dataset metadata from Prosperity Data360 API
#'
#' @param dataset_ids
#'
#' @import dplyr jsonlite httr
#'
#' @return A metadata dataset
#' @export
fetch_dataset_metadata <- function(dataset_ids) {
  dataset_metadata <- list()
  for (dataset_id in dataset_ids) {
    url <- paste0("https://datacatalogapi.worldbank.org/dexapps/efi/metadata/datasets?datasetId=", dataset_id)
    response <- GET(url)

    # Check for HTTP errors
    if (http_error(response)) {
      print(paste("Error fetching dataset metadata for dataset", dataset_id, ":", content(response, "text")))
      return(NULL)
    }

    metadata <- content(response, "text")
    metadata <- fromJSON(metadata)
    dataset_metadata[[dataset_id]] <- metadata$value
  }
  return(dataset_metadata)
}

#' Fetch indicator metadata from Prosperity Data360 API
#'
#' @param dataset_ids A dataset ID
#' @param indicator_ids_list A list of indicators
#'
#' @import dplyr jsonlite httr
#'
#' @return A metadata dataset
#' @export
fetch_indicator_metadata <- function(dataset_ids, indicator_ids_list) {
  indicator_metadata <- list()
  for (i in seq_along(dataset_ids)) {
    dataset_id <- dataset_ids[i]
    indicator_ids <- indicator_ids_list[[i]]
    for (indicator_id in indicator_ids) {
      url <- paste0("https://datacatalogapi.worldbank.org/dexapps/efi/metadata/indicators?datasetId=", dataset_id, "&indicatorId=", indicator_id)
      response <- GET(url)

      # Check for HTTP errors
      if (http_error(response)) {
        print(paste("Error fetching indicator metadata for dataset", dataset_id, "and indicator", indicator_id, ":", content(response, "text")))
        return(NULL)
      }


      metadata <- content(response, "text")
      metadata <- fromJSON(metadata)
      indicator_metadata[[indicator_id]] <- metadata$value
    }
  }
  return(indicator_metadata)
}

#' Fetch data and metadata for multiple datasets
#'
#' @param dataset_ids A character vector of dataset ID
#' @param indicator_ids_list A list of indicator IDs
#'
#' @import dplyr jsonlite httr
#'
#' @return A dataset
#' @export
fetch_and_merge_world_bank_data <- function(dataset_ids, indicator_ids_list) {
  # Initialize empty dataframes for merged data and metadata
  merged_data <- data.frame()
  merged_dataset_metadata <- data.frame()
  merged_indicator_metadata <- data.frame()

  # Loop through each dataset ID and fetch data and metadata
  for (i in seq_along(dataset_ids)) {
    dataset_id <- dataset_ids[i]
    indicator_ids <- indicator_ids_list[[i]]

    # Fetch data
    data <- fetch_prosperitydata360_data(dataset_id, indicator_ids)

    # If data fetch failed, skip to next dataset
    data <- fetch_prosperitydata360_data(dataset_id, indicator_ids)
    if (is.null(data)) {
      next
    }

    # Fetch dataset metadata
    dataset_metadata <- fetch_dataset_metadata(dataset_id)

    # If dataset metadata fetch failed, skip to next dataset
    indicator_metadata <- fetch_indicator_metadata(list(dataset_id), list(indicator_ids))
    if (is.null(dataset_metadata)) {
      next
    }

    # Fetch indicator metadata
    indicator_metadata <- fetch_indicator_metadata(list(dataset_id), list(indicator_ids))

    # If indicator metadata fetch failed, skip to next dataset
    indicator_metadata_df <- do.call(rbind, indicator_metadata)
    if (is.null(indicator_metadata)) {
      next
    }


    # Merge data into single dataframe
    merged_data <- bind_rows(merged_data, data)

    # Merge dataset metadata into single dataframe
    dataset_metadata_df <- as.data.frame(dataset_metadata[[dataset_id]])
    merged_dataset_metadata <- bind_rows(merged_dataset_metadata, dataset_metadata_df)

    # Merge indicator metadata into single dataframe
    indicator_metadata_df <- do.call(rbind, indicator_metadata)
    merged_indicator_metadata <- bind_rows(merged_indicator_metadata, indicator_metadata_df)
  }
  # Return merged data and metadata
  return(list(data = merged_data, dataset_metadata = merged_dataset_metadata, indicator_metadata = merged_indicator_metadata))
}
