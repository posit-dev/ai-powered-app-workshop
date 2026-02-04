# Georgia County Mortality Rate Choropleth Map Function
# This function creates an interactive map showing average annual mortality rates
# per 100,000 population for Georgia counties

# Load required packages
library(tidyverse)
library(leaflet)
library(sf)
library(tigris)

# Enable caching for faster subsequent runs (optional but recommended)
options(tigris_use_cache = TRUE)

#' Create Mortality Rate Choropleth Map
#'
#' Creates an interactive leaflet map showing mortality rates per 100,000 population
#' for Georgia counties. Suitable for use in Shiny applications.
#'
#' @param mortality_data A data frame with columns: County, Year, n (deaths)
#' @param population_data A data frame with columns: County, Population
#' @param state_fips The FIPS code for the state (default: "13" for Georgia)
#' @param palette Color palette for the map (default: "YlOrRd")
#' 
#' @return A leaflet map object that can be rendered in Shiny with leafletOutput/renderLeaflet
#' 
#' @examples
#' # In a Shiny app:
#' # ui <- fluidPage(leafletOutput("map"))
#' # server <- function(input, output) {
#' #   output$map <- renderLeaflet({
#' #     create_mortality_map(georgia_mortality, georgia_population)
#' #   })
#' # }
create_mortality_map <- function(mortality_data, 
                                  population_data, 
                                  state_fips = "13",
                                  palette = "YlOrRd") {
  
  
  # Step 1: Compute total deaths (n) for each county for each year
  county_year_totals <- mortality_data |>
    group_by(County, Year) |>
    summarise(n = sum(n, na.rm = TRUE), .groups = "drop")
  
  # Step 2: Compute average number of deaths per year for each county
  county_avg_deaths <- county_year_totals |>
    group_by(County) |>
    summarise(avg_deaths = mean(n, na.rm = TRUE), .groups = "drop")
  
  # Step 3: Merge with population and calculate rate per 100,000
  county_avg_rate <- county_avg_deaths |>
    left_join(population_data, by = "County") |>
    mutate(Rate = (avg_deaths / Population) * 100000)
  
  # Step 4: Get county geographic boundaries using tigris
  # Get directly from U.S. Census Bureau and transform to WGS84 for leaflet
  counties_geo <- counties(state = state_fips, cb = TRUE, year = 2021) |>
    st_transform(4326) |>  # Transform to WGS84 (EPSG:4326) to avoid datum warning
    mutate(County = paste(NAME, "County"))
  
  # Step 5: Merge geographic data with mortality rates
  map_data <- counties_geo |>
    left_join(county_avg_rate, by = "County") |>
    mutate(Rate = replace_na(Rate, 0))  # Replace NA with 0
  
  # Step 6: Create color palette for the rates
  pal <- colorNumeric(
    palette = palette,
    domain = map_data$Rate,
    na.color = "#808080"
  )
  
  # Step 7: Create the interactive choropleth map
  map <- leaflet(map_data) |>
    addTiles() |>
    addPolygons(
      fillColor = ~pal(Rate),
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
      label = ~paste0(County, ": ", round(Rate, 1), " per 100,000"),
      labelOptions = labelOptions(
        style = list("font-weight" = "normal", padding = "3px 8px"),
        textsize = "15px",
        direction = "auto"
      )
    ) |>
    addLegend(
      pal = pal,
      values = ~Rate,
      opacity = 0.7,
      title = "Mortality Rate<br>per 100,000",
      position = "bottomright"
    )
  
  # Return the map object (ready for Shiny)
  return(map)
}
