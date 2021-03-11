### Server function of the Shiny application

shinyServer(function(input, output) {

    observeEvent(input$Folder_1,{
        ## Check for potentially wrong input data
        if(input$Piloot == input$Spotter |
           input$Bewolking == "Default" |
           (input$Drone == "Phantom 4" & any(input$Sensor %in% c("RGB a6000", "RGB A7 III", "RGB_modified", "MS_10 banden", "Thermaal"))) |
           (input$Drone != "Phantom 4" & any(input$Sensor %in% c("RGB Phantom4"))) |
           is.null(input$Sensor)
            ){
            output$Succes <-  renderText(("Fout bij ingeven data"))
            
        }
        else {
        F1 <- paste0(PATH,
                     str_split(as.character(input$Datum), "-")[[1]][1],
                     "/",
                     "Project ",
                     input$Project,
                     "/",
                     paste0(str_remove_all(as.character(input$Datum), "-"),"_",input$Veld,"_", input$Soort, "_", 
                            ifelse(nchar(as.character(input$VluchtNo)) < 2, paste0("0",input$VluchtNo), input$VluchtNo))
                     
        )
        A_list <- list("Coordinatenreferenties", "Stitch_Agisoft", "Stitch_Pix4D", "Waypoints_wpl_gpx_gpscoord")
        Folder_seq <- str_split(F1, "/", simplify = T) %>% as.vector()
        
        
        if(dir.exists(F1)){
            output$Succes <-  renderText(("Deze map bestaat al"))
        } else {
            if(!dir.exists(str_c(Folder_seq[1:(length(Folder_seq)-3)], collapse="/"))) {
                dir.create(str_c(Folder_seq[1:(length(Folder_seq)-3)], collapse="/"))
            }
            if(!dir.exists(str_c(Folder_seq[1:(length(Folder_seq)-2)], collapse="/"))) {
                dir.create(str_c(Folder_seq[1:(length(Folder_seq)-2)], collapse="/"))
            }
            if(!dir.exists(str_c(Folder_seq[1:(length(Folder_seq)-1)], collapse="/"))) {
                dir.create(str_c(Folder_seq[1:(length(Folder_seq)-1)], collapse="/"))
            }
            dir.create(F1, recursive = F)
            lapply(A_list, function(x) {
                dir.create(paste0(F1,"/", x))
            })
            SelectedSensors <- c()
            if("RGB" %in% substr(input$Sensor, 1, 3) & !dir.exists(paste0(F1,"/", "Beelden_RGB"))){
                dir.create(paste0(F1,"/", "Beelden_RGB"))
                dir.create(paste0(F1,"/", "Beelden_RGB/jpg"))
                dir.create(paste0(F1,"/", "Beelden_RGB/raw"))
                SelectedSensors <- append(SelectedSensors, "RGB")
            }
            if("MS" %in% substr(input$Sensor,1,2) & !dir.exists(paste0(F1,"/", "Beelden_MS"))){
                dir.create(paste0(F1,"/", "Beelden_MS"))
                dir.create(paste0(F1,"/", "Beelden_MS/MS blauw"))
                dir.create(paste0(F1,"/", "Beelden_MS/MS rood"))
                SelectedSensors <- append(SelectedSensors, "MS")
            }
            if("Thermaal" %in% input$Sensor & !dir.exists(paste0(F1,"/", "Beelden_Thermaal"))){
                dir.create(paste0(F1,"/", "Beelden_Thermaal"))
                SelectedSensors <- append(SelectedSensors, "Thermaal")
            }
            output$Succes <-  renderText(("Nieuwe map gemaakt!"))
            
            ##Write to excel file stitch monitor
            
            Folders <- dir(F1, include.dirs = T, pattern =  paste0(SelectedSensors, collapse="|"), recursive = T, full.names = T)
           
            Year <- str_split(as.character(input$Datum), "-")[[1]][1]
            wb <- loadWorkbook(filename = paste0(PATH, "/", Year, "/", Excelfile), create = T)
            if(!existsSheet(wb, Year)){
                createSheet(wb, Year)
                writeWorksheet(wb, data = t(c("Link", "Folder", "Project", "Date", "Locatie", "Gewas", "Drone", "Sensor", "Piloot", "Spotter", "Opmerking", 
                                              "LightRoom_Date", "LightRoom_Initials", "PrePro_Date", "PrePro_Initials", "PreProName",
                                            "VIS", "NIR", "Thermaal", "NIR reoptimize",	"stitch afgewerkt?",
                                            "Reference (field/sea)", "Copyright", "DEM", "ORTHO")),
                               sheet = Year, startRow = 1, startCol = 1, header = F)
            }
            #if(!existsCellStyle(wb, "DateStyle")){
            setStyleAction(wb, XLC$"STYLE_ACTION.DATATYPE")
            #cs = createCellStyle(wb, name = "DateStyle")
            #}
            cs = getOrCreateCellStyle(wb, name = "DateStyle")
            setDataFormat(cs, format = "yyyy-mm-dd")
            setCellStyleForType(wb, style = cs, type = XLC$"DATA_TYPE.DATETIME")
            
            setColumnWidth(wb, sheet = Year, column = 1:8, width = c(10000, 10000, 4000, 4000, 4000, 4000, 4000, 4000))
            rowIndex <- getLastRow(wb, Year)+1
            
            # createName(wb, name = input$Project, formula = paste0(input$Project,"!$A$1"))
            
            data2add <- data.frame(Folders = Folders, Project = rep(input$Project, length(Folders)),
                                   Date = rep(input$Datum, length(Folders)), 
                                   Locatie = rep(input$Veld, length(Folders)), Gewas = rep(input$Soort, length(Folders)),
                                   Drone = rep(input$Drone, length(Folders)),
                                   Sensor = sort(input$Sensor),
                                   Piloot = rep(input$Piloot, length(Folders)), Spotter = rep(input$Spotter, length(Folders)))
            
            
            writeWorksheet(wb, data = data2add, sheet = Year, header = F, startCol = 2, startRow = rowIndex)
            for(f in 1:length(Folders)){
                r_Ind = rowIndex-1+f
                Cell_Id = idx2cref(c(r_Ind, 2, r_Ind, 4, r_Ind, 5, r_Ind, 6, r_Ind, 12, r_Ind, 13, r_Ind, 14, r_Ind, 15))
                setCellFormula(wb, Year, col = 1, row = r_Ind,
                               formula = paste0('HYPERLINK(B', r_Ind, ')'))
                setCellFormula(wb, Year, col = 16, row = r_Ind,
                                formula = paste0('YEAR(', Cell_Id[2],')&TEXT(', Cell_Id[2],', "mmdd")&"_"&', Cell_Id[3],
                                                 '&"_"&', Cell_Id[4],'&"_"&', Cell_Id[5], '&"_"&', Cell_Id[6],
                                                 '&"_"&', Cell_Id[7],'&"_"&', Cell_Id[8]))
            }
            
            
            saveWorkbook(wb, file = paste0(PATH, "/", Year, "/", Excelfile))
            
            ##Write to excel file for backup
            wb_bu <- loadWorkbook(filename = paste0(PATH, "/", Year, "/", "Backup_Monitor.xlsx"), create = T)
            if(!existsSheet(wb_bu, Year)){
                createSheet(wb_bu, Year)
                writeWorksheet(wb_bu, data = t(c("Link", "Folder", "Project", "Date", "Locatie", "Gewas", "Drone", "Sensor", "Piloot", "Spotter")),
                               sheet = Year, startRow = 1, startCol = 1, header = F)
            }
            #if(!existsCellStyle(wb, "DateStyle")){
            setStyleAction(wb_bu, XLC$"STYLE_ACTION.DATATYPE")
            #cs = createCellStyle(wb, name = "DateStyle")
            #}
            cs = getOrCreateCellStyle(wb_bu, name = "DateStyle")
            setDataFormat(cs, format = "yyyy-mm-dd")
            setCellStyleForType(wb_bu, style = cs, type = XLC$"DATA_TYPE.DATETIME")
            
            setColumnWidth(wb_bu, sheet = Year, column = 1:8, width = c(10000, 10000, 4000, 4000, 4000, 4000, 4000, 4000))
            rowIndex <- getLastRow(wb_bu, Year)+1
            
            # createName(wb, name = input$Project, formula = paste0(input$Project,"!$A$1"))
            
            writeWorksheet(wb_bu, data = data2add, sheet = Year, header = F, startCol = 2, startRow = rowIndex)
            
            for(f in 1:length(Folders)){
                setCellFormula(wb_bu, Year, col = 1, row = rowIndex-1+f,
                               formula = paste0("HYPERLINK(B", rowIndex-1+f, ")"))
            }
            
            saveWorkbook(wb_bu, file = paste0(PATH, "/", Year, "/", "Backup_Monitor.xlsx"))
            
            ###☻write text file for remarks
            write_file(x = input$Opmerking, path = paste0(F1, "/Opmerkingen.txt"))
        
        
    }}} )
})
