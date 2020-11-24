# UAV_Flight_Input
An R Shiny application to automate the creation of standardized folders for UAV data at ILVO  
Made for Windows 10

## Files
Shiny application function:
- [run.r](run.r): installs required packages, sets the correct paths, calls the Shiny server ([server.r](server.r)) and UI ([ui.r](ui.r)) functions
- [server.r](server.r): defines the Shiny server function
- [ui.r](ui.r): defines the Shiny User Interface function

Files containing base metadata:
- [InputFiles](InputFiles): contains six .csv files in which possible choices are defined:
    - [Gewas.csv](InputFiles/Gewas.csv)
    - [Piloot.csv](InputFiles/Piloot.csv)
    - [Project.csv](InputFiles/Project.csv)
    - [Sensor.csv](InputFiles/Sensor.csv)
    - [Spotter.csv](InputFiles/Spotter.csv)
    - [Veld.csv](InputFiles/Veld.csv)

ShortCut to run the app:
- [UAV_input.bat](UAV_input.bat)


## Installation
- Make sure that [R](https://cran.r-project.org/bin/windows/base/) is installed
- Download the files and save them in a single folder
- In the [run.r](run.r) file set the PATH variable to the data location (default: Q-drive)
- In the [UAV_input.bat](UAV_input.bat) file modify two paths:
    - Path to the Rscript.exe file on your PC
    - Path to the run.r file on your PC
- Copy the UAV_input.bat from the folder on your PC to your desktop (Bureaublad)
