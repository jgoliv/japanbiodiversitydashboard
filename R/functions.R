f.ranking <- function(x) {
  x |>
    summarise(observations = sum(individual_count), .by = "name") |>
    slice_max(n = 5, order_by = observations) |>
    filter(!is.na(name))
}

f.timeline <- function(x, years) {

  x |>
    summarise(observations = sum(individual_count), .by = "year") |>
    complete(year = years, fill = list(observations = 0)) ->
    res

  colnames(res) <- tools::toTitleCase(colnames(res))

  res
}

f.metrics <- function(x) {

  total_observations <- sum(x$individual_count) |> as.character()
  observed_period <- paste("from", format(min(x$day), "%m/%Y"), "to", format(max(x$day), "%m/%Y"))

  life_stage <- utils.get_max_obs(x, "life_stage")
  most_observed_life_stage <- paste(life_stage$life_stage, glue("({life_stage$pct}%)"))

  sex <- utils.get_max_obs(x, "sex")
  most_observed_sex <- paste(sex$sex, glue("({sex$pct}%)"))

  locality <- utils.get_max_obs(x, "locality")
  most_frequent_locality <- paste(locality$locality, glue("({locality$pct}%)"))

  tribble(
    ~name, ~value,
    "Observations:", total_observations,
    "Observed period:", observed_period,
    "Most observed life stage:", most_observed_life_stage,
    "Most observed sex:", most_observed_sex,
    "Most frequent locality:", most_frequent_locality
  )
}

f.scientific_info <- function(x) {
  tribble(
    ~name, ~value,
    "Scientific name:", unique(x$scientific_name),
    "Vernacular name:", unique(x$vernacular_name),
    "Kingdom:", unique(x$kingdom),
    "Family:", unique(x$family)
  )
}

f.distribution <- \(x) x |> summarise(Count = sum(individual_count), .by = "year")
