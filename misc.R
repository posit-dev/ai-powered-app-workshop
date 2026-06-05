# Our goal is to build an app around these pieces of code

library(tidyverse)
library(leaflet)
library(sf)
library(tigris)
library(DT)

peachtree_lottery <- readRDS("peachtree_lottery.RDS")

source("lottery_helpers.R")

create_lottery_map(peachtree_lottery, per_capita = TRUE)
datatable(peachtree_lottery)
plot_per_capita_spend(peachtree_lottery, income)