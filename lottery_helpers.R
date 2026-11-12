library(tidyverse)
library(leaflet)
library(sf)
library(tigris)

options(tigris_use_cache = TRUE)


#' Create an interactive lottery sales choropleth map
#'
#' Builds a leaflet choropleth map showing lottery ticket sales aggregated
#' by county. Optionally displays per-capita spending (dollars per wage-earning
#' adult) instead of total sales.
#'
#' @param data A data frame containing at least the columns `county`, `sales`,
#'   and (when `per_capita = TRUE`) `n`, the number of wage-earning adults.
#' @param per_capita Logical. If `TRUE`, display average dollars spent per
#'   wage-earning adult per county. If `FALSE` (default), display total sales.
#' @param state_fips Character. The two-digit FIPS code for the state whose
#'   county boundaries are fetched via [tigris::counties()]. Defaults to
#'   `"13"` (Georgia).
#' @param palette Character. A ColorBrewer palette name passed to
#'   [leaflet::colorNumeric()]. Defaults to `"YlOrRd"`.
#'
#' @return A `leaflet` map widget.
create_lottery_map <- function(
  data,
  per_capita = FALSE,
  state_fips = "13",
  palette = "YlOrRd"
) {
  county_totals <-
    if (per_capita) {
      data |>
        group_by(county) |>
        summarise(
          dollars = sum(sales, na.rm = TRUE) / sum(n, na.rm = TRUE),
          .groups = "drop"
        )
    } else {
      data |>
        group_by(county) |>
        summarise(dollars = sum(sales, na.rm = TRUE), .groups = "drop")
    }

  counties_geo <- counties(
    state = state_fips,
    cb = TRUE,
    year = 2021,
    progress_bar = FALSE
  ) |>
    st_transform(4326) |> # Transform to WGS84 (EPSG:4326) to avoid datum warning
    mutate(county = NAME)

  map_data <- counties_geo |>
    left_join(county_totals, by = "county") |>
    mutate(dollars = replace_na(dollars, 0))

  pal <- colorNumeric(
    palette = palette,
    domain = map_data$dollars,
    na.color = "#808080"
  )

  leaflet(map_data) |>
    addTiles() |>
    addPolygons(
      fillColor = ~ pal(dollars),
      fillOpacity = 0.7,
      color = "#FFFFFF",
      weight = 1,
      smoothFactor = 0.5,
      highlightOptions = highlightOptions(
        weight = 2,
        color = "#666",
        fillOpacity = 0.9,
        bringToFront = TRUE
      ),
      label = ~ paste0(
        county,
        ": $",
        format(round(dollars, 2), nsmall = 2, big.mark = ",")
      ),
      labelOptions = labelOptions(
        style = list("font-weight" = "normal", padding = "3px 8px"),
        textsize = "15px",
        direction = "auto"
      )
    ) |>
    addLegend(
      pal = pal,
      values = ~dollars,
      opacity = 0.7,
      title = "Dollars",
      position = "bottomright"
    )
}

#' Plot per-capita lottery spending by a demographic variable
#'
#' Creates a bar chart showing average lottery spending (dollars per
#' wage-earning adult) broken down by a grouping variable. Supports
#' tidy evaluation, so the grouping column can be passed unquoted.
#'
#' @param data A data frame containing at least `sales`, `n` (number of
#'   wage-earning adults), and the column referenced by `var`.
#' @param var \<[`data-masking`][rlang::args_data_masking]\> Unquoted name of
#'   the column to group by (e.g., `age_group`, `gender`).
#' @param color Character. Fill color for the bars. Defaults to
#'   `"steelblue"`.
#'
#' @return A `ggplot` object.
