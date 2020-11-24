if (!require("pacman")) install.packages("pacman")
pacman::p_load(shiny, tidyverse, readr, stringr, XLConnect)
# library(shiny)
# library(tidyverse)
# library(readr)

folder_address = 'C://Users//tdeswaef//Documents//Applications//UAVDataApp'
setwd(dir = folder_address)
Piloten <- read_csv("./InputFiles/Piloot.csv", col_names = F)[[1]] %>% as.vector()
Velden <- read_csv("./InputFiles/Veld.csv", col_names = F)[[1]] %>% as.vector()
Projecten <- read_csv("./InputFiles/Project.csv", col_names = F)[[1]] %>% as.vector()
Sensoren <- read_csv("./InputFiles/Sensor.csv", col_names = F)[[1]] %>% as.vector()
Gewassen <- read_csv("./InputFiles/Gewas.csv", col_names = F)[[1]] %>% as.vector()
Spotters <- read_csv("./InputFiles/Spotter.csv", col_names = F)[[1]] %>% as.vector()
#PATH <- "//clo.be/dfs/Data/iSense/Vluchtfotos/"
PATH <- "C:/users/tdeswaef/Documents/00_DATA/"

runApp(folder_address, launch.browser=TRUE)
