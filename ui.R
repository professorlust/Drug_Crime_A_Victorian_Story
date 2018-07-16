install.packages("highcharter")
install.packages("wordcloud")
install.packages("RColorBrewer")
library(leaflet)
library(shiny)
library(highcharter)

# Used Navigation bar for creating multiple page tabs
ui <- fluidPage(navbarPage("Drug Crime Analysis",
                          # First page tab
                         tabPanel("Trend Analysis",
                                  fluidRow(
                                            HTML("<center><h2>General Victorian Crime Wave for the past 10 Years</h2><center><br>
                                              <center><p>A day in this world does not go-by without seeing a crime of some sort. And law
                                              enforcement agencies around the world have been finding ways to tackle this. Victorian
Police is one such agency responsible for law enforcement in the Victorian state of Australia. The trend in crime wave in victoria is shocking and can be seen below</p>
                                                  <center>
                                                 ")


                                          ),
                                  fluidRow(
                                            # Displaying the interactive trend graphs for crime
                                            withTags({
                                                      highchartOutput("crimeTrend")
                                                    })

                                          ),
                                  
                                  fluidRow(
                                            HTML(" <center><h1>General Crime Divisions</h1></center><br>
                                              <center><p>As per the Victorian police, crime has been divided into multiple divisions and yearly incident rate have been recorded for
                                              each of these divisions.</p></center><br>
                                                <center><p>The crime divisions are as follows:</p></center>
                                                  <center>
                                                   <b>A Crime against Person</b><br>
                                                   <b>B Property and deception offences</b><br>
                                                   <b>C Drug offences</b><br> 
                                                   <b>D Public order and security offences</b><br>
                                                   <b>E Justice procedure offences</b><br>
                                                   <b>F Other Offences</b><br>
                                                 </center>
                                                 ")
                                          ),
                                  fluidRow(
                                            # Displaying the interactive trend graphs for multiple crime divisions
                                            withTags({
                                                      highchartOutput("divisionTrend")
                                                    })
                                          ),
                                  fluidRow(
                                            HTML("
                                                  <br><center><h3 style=\"color:red\">What interests most is sudden surge in <b>Drug Crimes</b> between <b>2016</b> and <b>2017</b>.</h3></center>
                                                ")
                                        )
                                  ),
                         # Second page tab
                         tabPanel(
                                  "Illicit Drug - A Story",
                                  fluidRow(
                                          HTML("<center><h2>Illicit Drug Crime across the World</h2></center><br>
                                                <center> <p>Price for drugs varies across countries. The price of the illicit drugs
                                                can be used to identify the demand for that particular drug in the market.
                                                </p></center>
                                                <center><p>Some of the major illicit drugs present in the market are:</p></center>
                                                <center>
                                                   <b>Heroine</b><br>
                                                   <b>Cocaine</b><br>
                                                   <b>Marijuana</b><br> 
                                                   <b>Meth</b><br>
                                                </center>
                                                <center>
                                                    <p>Looking into the prices of each of the major illicit drugs for each country 
                                                        involved in the black market.
                                                    </p>
                                                </center>
                                               ")
                                        ),
                                  fluidRow(
                                              # Displaying the Distribution gragh for drug prices
                                              # for all countries
                                              withTags({
                                                highchartOutput("drugDist")
                                              })
                                          ),
                                  fluidRow(
                                    HTML("<br><center><p>Aggregating all the major drug prices, we shall see a word cloud representing the
                                          top few countries leading in terms of drug prices.</p>
                                         </center>"),
                                    # Slider input for choosing the top N countries
                                    sidebarLayout(
                                      sidebarPanel(sliderInput(inputId = "countrySlide",
                                                                           label = " Number of Countries to display",
                                                                           min = 3,
                                                                           max = 20,
                                                                           value = 14,
                                                                           step = 1
                                                              )
                                                  ),
                                        # Displaying the word cloud for countries based on aggregated drug prices
                                        mainPanel(
                                          plotOutput("wordcloud")
                                        )
                                      ),
                                              HTML("<center><h1>Drug Crimes in Victoria, Australia</h1></center><br>
                                                  <center><p>It is shocking to know that Australia lies in the top 10 highest prices for drugs like
<b>Cocaine, Heroin, Marijuana and Meth</b>, which only shows the growing demand for these
                                                drugs. The prices for drugs are high in australia and it only means that Australia has high demand for
                                                drugs and that it is a consumer rather than a producer. We shall zoom into <b>Victoria</b> to see the year wise pattern in drug crimes and identify the <b>Top 20 Suburbs</b></p></center><br>
                                                   ")

                                  ),
                                  fluidRow(
                                    # Slider input for choosing a range of year
                                    sidebarLayout(
                                      sidebarPanel(sliderInput(inputId = "drugYear",
                                                               label = " Year",
                                                               min = 2008,
                                                               max = 2017,
                                                               value = c(2011,2014),
                                                               step = 1
                                                              )
                                      ),
                                      # Displaying the leaflet map with markers, occupying the whole width of the row 
                                      mainPanel(leafletOutput("crimeMap", width = "100%"))
                                    ),
                                    HTML("<br><center><h1>Year wise Drug Crimes across Victoria</h1></center><br>")
                                  ),
                                  fluidRow(
                                    # Checkbox input for choosing the drug offence types
                                    sidebarLayout(
                                      sidebarPanel(
                                                    # Input for choosing the drug offence to be analysed
                                                    checkboxGroupInput(inputId = "drugOffence", 
                                                                       label = "Choose Drug Offence Type:",
                                                                       choiceNames = c("C12 Drug trafficking", 
                                                                                       "C11 Drug dealing", 
                                                                                       "C23 Possess drug manufacturing equipment", 
                                                                                       "C21 Cultivate drugs", 
                                                                                       "C22 Manufacture drugs",
                                                                                       "C32 Drug possession",
                                                                                       "C31 Drug use"),
                                                                       choiceValues = c("C12 Drug trafficking", 
                                                                                        "C11 Drug dealing", 
                                                                                        "C23 Possess drug manufacturing equipment", 
                                                                                        "C21 Cultivate drugs", 
                                                                                        "C22 Manufacture drugs",
                                                                                        "C32 Drug possession",
                                                                                        "C31 Drug use"),
                                                                       selected = c("C12 Drug trafficking", 
                                                                                    "C11 Drug dealing", 
                                                                                    "C23 Possess drug manufacturing equipment", 
                                                                                    "C21 Cultivate drugs", 
                                                                                    "C22 Manufacture drugs",
                                                                                    "C32 Drug possession",
                                                                                    "C31 Drug use")
                                                                      ),
                                                    # Slider for selecting a range of year.
                                                    sliderInput(inputId = "year",
                                                                label = " Year",
                                                                min = 2008,
                                                                max = 2017,
                                                                value = c(2011,2014),
                                                                step = 1
                                                                )
                                                  ),
                                                mainPanel(
                                                            # Dispalying the drig offence distribution bar chart
                                                            withTags({
                                                              highchartOutput("drugOffDist")
                                                            })
                                                          )
                                                ),
                                    HTML("<center><h2>Conclusion</h2></center>
                                          <center> It can be noticed that the suburbs involved in drug crime
                                         varies between years. And the year wise change in the types of drug crime
                                        can further strengthen analysis so that the authorities can mark their target appropriately.
                                         </center><br><br>")
                                      )
                                  ),
                             tabPanel(
                               "Dataset",
                               HTML("<center><h2>General Crime Data - By Crime Statistics Agency</h2></center>"),
                               verbatimTextOutput("crimeDatasetSummary"),
                               HTML("<center><h2>Black Market Data for Drugs</h2></center>"),
                               verbatimTextOutput("blackMarketSummary"),
                               HTML("<center><h2>Suburb Wise illicit Drug Data</h2></center>"),
                               verbatimTextOutput("drugDatasetSummary")
                             )
                          ),
                # For setting the text and background colour for the navigation bar
                tags$style(type = 'text/css', '.navbar { background-color: #262626;
                           font-family: Arial;
                           font-size: 13px;
                           color: #FF0000; }',
                           
                           '.navbar-dropdown { background-color: #262626;
                           font-family: Arial;
                           font-size: 13px;
                           color: #FF0000; }',
                           
                           '.navbar-default .navbar-brand {
                           color: #cc3f3f;
                           }'

                )
                )