utils.get_max_obs <- function(x, col) {
  x |>
    count(.data[[col]]) |>
    mutate(
      sum = sum(n)
      ,pct = (n/sum * 100) |> round(digits = 1)
    ) |>
    slice_max(n, with_ties = FALSE)
}
