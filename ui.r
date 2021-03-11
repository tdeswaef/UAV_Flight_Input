### User Interface function for the Shiny application
shinyUI(fluidPage(

    # Application title
    titlePanel("New Flight"),

    # Input fields
    dateInput("Datum", "Kies een datum", format = "yyyy-mm-dd"),
    selectInput("Piloot", "Kies een piloot",
                Piloten,
                selected = "Thomas Vanderstocken"),
    selectInput("Spotter", "Kies een spotter",
                Spotters),
    selectInput("Project", "Kies een project", 
                Projecten),
    selectInput("Soort", "Kies een soort", 
                Gewassen),
    selectInput("Veld", "Kies een veld", 
                Velden),
    selectInput("VluchtNo", "Geef aan de hoeveelste vlucht dit was op dit perceel op deze dag",
                1:10),
    selectInput("Bewolking", "Schat de bewolkingsgraad in", 
                c("Default", "1/8", "2/8", "3/8", "5/8", "6/8", "7/8", "8/8"), 
                selected = "Default"),
    selectInput("Drone", "Kies een drone",
                Drones),
    checkboxGroupInput("Sensor", "Duid de sensoren aan",
                        Sensoren),
    textAreaInput("Opmerking", "Opmerkingen"),
    actionButton("Folder_1", "Create folder"),
    textOutput("Succes")
))
