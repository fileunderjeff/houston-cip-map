# map CIP projects by location and total dollar amount
# source data from the City of Houston Open Data Portal:
# 2016-2020 Adopted Capital Improvement Plan - http://data.houstontx.gov/dataset/city-of-houston-capital-improvement-plan/resource/31efe2ef-6cc5-4db4-bd25-aff75842fb9e
# initial prep involved eyeballing addresses and intersections and editing location data as needed
library(leaflet)
library(magrittr)
library(plyr)
library(rMaps)
library(ggmap)
setwd("../cip") # set your own working directory
#
#load the raw data, create a new column for the total, and convert it to a number
#
data <- read.csv(file="edited.csv", header = TRUE)
data$spend <- gsub("[$,]", "", data$Total)
data$spend <- as.numeric(data$spend)
# 
# fetch the lat/lon of each project. only perform once. comment out.
# address <- geocode(as.character(data$Location)) # fetch lat/lon and write to new variable
#
# merge lat/lon to original data table
#
data$lat <- address$lat # merge lat
data$lon <- address$lon # merge lon
#
# write the results to a csv file
# write.csv(data, file="cipfinal.csv")
#
# read results from a csv file - start here if you are editing the csv directly
# data <- read.csv(file="cipfinal.csv", header = TRUE)
#
# draw the map
cipmap <- leaflet() %>% 
  addTiles() %>% 
  addProviderTiles("CartoDB.Positron") %>%
  setView(-95.37, 29.75, zoom = 11) %>% 
  addCircleMarkers(data = data, lng = ~ lon, lat = ~ lat, radius = ~ sqrt(spend) * .005, popup = paste("<strong>",data$Project,"</strong><br/>","CIP#: ",data$CIP.No.,"<br/>",data$Total,"<br/>",data$Project.Description)) # draw the map
cipmap