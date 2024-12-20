library(dplyr)

# reading files
dir <- system.file(package = "japanbiodiversitydashboard", "extdata")

files <- list.files(dir, pattern = ".txt")

purrr::walk(files, \(f) {
  assign(
    x = tools::file_path_sans_ext(f)
    ,value = readr::read_delim(file.path(dir, f)) |> as_tibble()
    ,envir = .GlobalEnv
  )
})

# selecting desired columns
occurrence_selected_col_names <-
  c(
    "gbifID", "scientificName", "kingdom",
    "family", "vernacularName", "individualCount",
    "lifeStage", "sex", "decimalLongitude", "decimalLatitude",
    "locality", "eventDate", "eventTime"
  )

multimedia_selected_col_names <- c("id" = "gbifID", "url" = "identifier")

occurrence <- occurrence |> select(all_of(occurrence_selected_col_names))
multimedia <- multimedia |> select(all_of(multimedia_selected_col_names))

# preprocessing
occurrence <-
  occurrence |>
  janitor::clean_names() |>
  mutate(
    vernacular_name = ifelse(is.na(vernacular_name), "", vernacular_name)
    ,name = ifelse(vernacular_name %in% "", scientific_name, paste0(scientific_name, " - ", vernacular_name))
    ,day = event_date |> lubridate::as_date()
    ,time = ifelse(is.na(event_time), "-", event_time)
    ,year = day |> lubridate::floor_date("year")
    ,kingdom = ifelse(kingdom %in% "", "Other", kingdom)
    ,sex = ifelse(is.na(sex), "Unknown", sex |> stringr::str_to_title())
  ) |>
  select(
    id = gbif_id, day, time, year, name, scientific_name, vernacular_name, kingdom, family,
    individual_count, life_stage, sex, lat = decimal_latitude, lng = decimal_longitude, locality
  )

# joining multimedia with occurence to get species
media <-
  multimedia |>
  left_join(
    occurrence |> select(id, scientific_name)
    ,by = "id"
  ) |>
  filter(!is.na(scientific_name)) |>
  slice_head(n = 1, by = scientific_name) |>
  select(scientific_name, url)

# adding url column to occurence data and dropping id column
occurrence <-
  occurrence |>
  left_join(media, by = "scientific_name") |>
  select(-id)

# saving final rds
occurrence |>
  saveRDS(
    file = "./inst/extdata/data.rds"
  )
