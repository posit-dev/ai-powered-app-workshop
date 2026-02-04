# 1. Run querychat_app() and experiment with the output

library(querychat)

georgia_mortality <- read.csv("data/georgia_mortality.csv")

querychat_app(georgia_mortality)