library(leaflet)
library(shiny)
library(ggplot2)
library(plyr)
library(dplyr)
library(highcharter)
library(wordcloud)

server <- function(input, output){
  
  # Loading all the data from the csv files
  crime <- read.csv(file="drugSubgroupRate.csv", header=TRUE, sep=",")
  allDrugs <- read.csv(file="drugMarket.csv", header=TRUE, sep=",")
  finalSuburbwiseDrug <- read.csv(file="FinalSuburbWiseDrugData.csv", header=TRUE, sep=",")
  
  # Converting the Rate column into numeric
  crime$Rate <- as.numeric(crime$Rate)
  
  # Converting the Incidents recorded column into numeric
  crime$IncidentsRecorded <- as.numeric(crime$IncidentsRecorded)
  
  # Converting the Incidents recorded column into numeric
  finalSuburbwiseDrug$IncidentsRecorded <- as.numeric(finalSuburbwiseDrug$IncidentsRecorded)
  
  # Grouping the Crime data by year and summarising Rate with mean
  by_year <- crime %>% group_by(Year) %>% dplyr::summarise(mean = mean(Rate, na.rm = TRUE))
  
  # Grouping the Crime data by year and OffenceDivision and summarising Rate with mean
  divisionTrend <- crime %>% group_by(Year, OffenceDivision) %>% dplyr::summarise(mean = mean(Rate, na.rm = TRUE))
  
  # Grouping the Crime data by OffenceSubdivision and summarising IncidentsRecorded with mean
  by_division <- crime %>% group_by(OffenceSubdivision) %>% dplyr::summarise(mean = mean(IncidentsRecorded, na.rm = TRUE))
  
  # Grouping the Drug data by Country and summarising drug price with mean
  drugWord <- allDrugs %>% group_by(Country) %>% dplyr::summarise(mean = mean(DrugPrice, na.rm = TRUE))
  
  # Drawing the trend graph by year 
  output$crimeTrend <- renderHighchart({
    hchart(by_year, 'line', hcaes(x= Year, y= mean), color = 'red')
  })
  
  # Drawing the multiple trend graph by year 
  output$divisionTrend <- renderHighchart({
    
    hchart(divisionTrend, 'line', hcaes(x= Year, y= mean, group = OffenceDivision)) %>%
      hc_tooltip(table=TRUE, sort = TRUE)
  })
  
  # Drawing the multiple trend graph by year
  output$drugDist <- renderHighchart({
    hchart(allDrugs, 'column', hcaes(x= Country, y= DrugPrice, group = DrugType)) %>%
      hc_tooltip(table=TRUE, sort = TRUE)
  })
  
  # Reactive element for updating data to plot bar chart
  updated_DrugOffencedf <- reactive({
    updated_DrugOffencedf <- subset(crime,  OffenceSubgroup %in% input$drugOffence)
    updated_DrugOffencedf <- updated_DrugOffencedf %>% group_by(Year, OffenceSubgroup) %>% dplyr::summarise(mean = mean(IncidentsRecorded, na.rm = TRUE))
    updated_DrugOffencedf <- updated_DrugOffencedf[updated_DrugOffencedf$Year >= input$year[1] & updated_DrugOffencedf$Year <= input$year[2],]
  })
  
  # Plot the word cloud based on Country and the top N selected
  output$wordcloud <- renderPlot({
    
    wordcloud(drugWord$Country, drugWord$mean, max.words=input$countrySlide, scale=c(4,0.5), colors=brewer.pal(8, "Dark2"))
  
    })
  
  # Plot the bargraph
  output$drugOffDist <- renderHighchart({
    validate(
      need(input$drugOffence != "", "Map cannot be shown. Please select atleast 1 offence type")
    )
    
    hchart(updated_DrugOffencedf(), 'bar', hcaes(x= OffenceSubgroup, y= mean), color = 'red') %>%
      hc_tooltip(table=TRUE, sort = TRUE)
  })

  # Reactive element for filtering and grouping data for plotting markers on leaflet
  yearWiseSuburb <- reactive({
            yearWiseSuburb <- finalSuburbwiseDrug %>% group_by(Year,postcode,suburb,lat, lon) %>% dplyr::summarise(mean = mean(IncidentsRecorded, na.rm = TRUE))
            yearWiseSuburb <- yearWiseSuburb[yearWiseSuburb$Year >= input$drugYear[1] & yearWiseSuburb$Year <= input$drugYear[2],]
            yearWiseSuburb[order(yearWiseSuburb$mean, decreasing = T)[1:20],]
  })
  
  # Plotting leaflet that displays the top 20 suburbs
  output$crimeMap <- renderLeaflet({
    
    leaflet(yearWiseSuburb()) %>% 
      setView(lng= mean(yearWiseSuburb()$lon), lat =mean(yearWiseSuburb()$lat), zoom = 6) %>%
      addProviderTiles(providers$CartoDB.Positron) %>%
      addCircleMarkers( ~lon,
                        ~lat,
                        label = ~as.character(suburb),
                        stroke = FALSE,
                        color = 'red',
                        fillOpacity = 0.7,
                        radius = as.numeric(yearWiseSuburb()$mean)/100)
  })
  
  # Printing the summary of crime data
  output$crimeDatasetSummary <- renderPrint({
    summary(crime)
  })
  
  # Printing the summary of World Drug data
  output$blackMarketSummary <- renderPrint({
    summary(allDrugs)
  })
  
  # Printing the summary of suburbwise drug data
  output$drugDatasetSummary <- renderPrint({
    summary(finalSuburbwiseDrug)
  })
  
}