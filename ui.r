### User Interface function for the Shiny application
shinyUI(fluidPage(

    # Application title
    titlePanel("New Flight"),

    # INput fields
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
    checkboxGroupInput("Sensor", "Duidt de sensoren aan",
                        Sensoren),
    actionButton("Folder_1", "Create folder"),
    textOutput("Succes")
))
