library(dplyr)
library(stringr)
library(bsicons)

pick_color <- function(high){

    # Hot temps
    if (high > 90)      bslib::value_box_theme(bg = "#fb721dff", fg = "#ffffffff") 
    else if (high > 85) bslib::value_box_theme(bg = "#fb8d39ff", fg = "#4e1e03ff") 
    else if (high > 80) bslib::value_box_theme(bg = "#f8a86aff", fg = "#4e1e03ff")
    else if (high > 75) bslib::value_box_theme(bg = "#fabf84ff", fg = "#4e1e03ff")
  
    # comfortable temps
    else if (high > 70) bslib::value_box_theme(bg = "#fff2d4ff", fg = "#000000ff")
    else if (high > 65) bslib::value_box_theme(bg = "#fffad4ff", fg = "#000000ff")
    else if (high > 60) bslib::value_box_theme(bg = "#f0f0f0ff", fg = "#000000ff")
    else if (high > 55) bslib::value_box_theme(bg = "#dcdcdcff", fg = "#000000ff")
   
    # cold temps
    else if (high > 50) bslib::value_box_theme(bg = "#e6f2fd", fg = "#0B538E")
    else if (high > 45) bslib::value_box_theme(bg = "#cde5fcff", fg = "#0B538E")
    else if (high > 40) bslib::value_box_theme(bg = "#afd6faff", fg = "#0B538E")
    else if (high > 35) bslib::value_box_theme(bg = "#91c6f7ff", fg = "#0B538E")
    else                bslib::value_box_theme(bg = "#6bb3f7ff", fg = "#0B538E")

}


pick_icon <- function(skies){
  skies <- paste(unique(skies), collapse = " ")

  if (stringr::str_detect(skies, "Storm")) bsicons::bs_icon("cloud-lightning-rain")
  else if (stringr::str_detect(skies, "Rain")) bsicons::bs_icon("cloud-rain-heavy")
  else if (stringr::str_detect(skies, "Snow")) bsicons::bs_icon("snow")
  else if (stringr::str_detect(skies, "Wind")) bsicons::bs_icon("wind")
  else if (stringr::str_detect(skies, "Cloudy")) bsicons::bs_icon("cloud-sun")
  else  bsicons::bs_icon("sun")

}