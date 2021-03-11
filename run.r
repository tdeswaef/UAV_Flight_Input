### Install and load required libraries using pacman
if (!require("pacman")) install.packages("pacman")
pacman::p_load(shiny, tidyverse, readr, stringr, XLConnect)

### Set the PATH to the folder in which UAV data are stored (Q-drive)
#PATH <- "//clo.be/dfs/Data/iSense/Vluchtfotos/"
PATH <- "C:/Users/tdeswaef/Documents/Applications/"
Excelfile <- "Stitch_monitor.xlsx"

### Set the folder address where the app files are located on your desktop
folder_address = "C://Users//tdeswaef//Documents//Applications//UAVDataApp//UAV_Flight_Input"

### DON'T CHANGE
### Set the working directory, read the metadata base files (.csv)
setwd(dir = folder_address)
Piloten <- read_csv("./InputFiles/Piloot.csv", col_names = F)[[1]] %>% as.vector()
Velden <- read_csv("./InputFiles/Veld.csv", col_names = F)[[1]] %>% as.vector()
Projecten <- read_csv("./InputFiles/Project.csv", col_names = F)[[1]] %>% as.vector()
Sensoren <- read_csv("./InputFiles/Sensor.csv", col_names = F)[[1]] %>% as.vector()
Gewassen <- read_csv("./InputFiles/Gewas.csv", col_names = F)[[1]] %>% as.vector()
Spotters <- read_csv("./InputFiles/Spotter.csv", col_names = F)[[1]] %>% as.vector()
Drones <- read_csv("./InputFiles/Drone.csv", col_names = F)[[1]] %>% as.vector()

### Run the application in your standard browser
runApp(folder_address, launch.browser=TRUE)

