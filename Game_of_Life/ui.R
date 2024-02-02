#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)
library(shinyWidgets)
library(gganimate)
library(reshape2)
library(tidyverse)
library(plotly)
library(htmlwidgets)


fluidPage(
    setBackgroundColor(
        color = "dimgray",
        shinydashboard = FALSE
    ),
     # Application title
    titlePanel(h1("Conway's Game of Life", align ="center",
                  style= "color:white")),
    

    # Sidebar with a slider input for number of bins
    fluidRow(column(3, wellPanel(style = "background: gray; color:white",
                           sliderInput("habitat_size",
                                       "Habitat Size",
                                       min = 10,
                                       max = 50,
                                       value = 25),
                           sliderInput("iterations",
                                       "Number of Generations",
                                       min = 1,
                                       max = 100,
                                       value = 50),
                           sliderInput("prob_life",
                                       "Probability of starting life",
                                       min = 0.05,
                                       max = 0.5,
                                       value = 0.15))),
            column(3, wellPanel(style = "background: gray; color:white",
                            numericInput("B_R", "Rebirth by reproduction if neighbours are exactly equal to:", value = 3, min = 0, max = 8),
                            numericInput("D_U", "Death by under population if neighbours are less than:", value = 2, min = 0, max = 8),
                            numericInput("D_O", "Death by overpopulation if neighbours are greater than:", value = 3, min = 0, max = 8),
                           actionButton("run", "Start", icon = icon("bolt"), 
                                        style="background: black; color: white")
                        ))),
            
    fluidRow(column(4, wellPanel(style = "background: gray; color:white",
                                 plotlyOutput("plot1"))), 
             column(4, wellPanel(style = "background: gray; color:white",
                                 plotlyOutput("plot2"))))
   
    
)
