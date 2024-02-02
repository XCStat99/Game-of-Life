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


# Define UI for application that draws a histogram
fluidPage(
    setBackgroundColor(
        color = "dimgray",
        shinydashboard = FALSE
    ),
     # Application title
    titlePanel(h1("Conway's Game of Life!",
                  style= "color:white")),
    

    # Sidebar with a slider input for number of bins
    fluidRow(
        column(4,
               wellPanel(style = "background: gray; color:white",
                         
                           sliderInput("habitat_size",
                                       "Habitat Size",
                                       min = 10,
                                       max = 50,
                                       value = 25),
                           sliderInput("iterations",
                                       "Number of Generations",
                                       min = 1,
                                       max = 150,
                                       value = 50),
                           sliderInput("prob_life",
                                       "Probability of starting life",
                                       min = 0.05,
                                       max = 0.5,
                                       value = 0.15),
                           actionButton("run", "Start", icon = icon("bolt"), 
                                        style="background: black; color: white"),
                        )
               ),
            ),
    fluidRow(column(4, plotlyOutput("plot1")), column(4, plotlyOutput("plot2"))),
    
)
