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
     # application title and formatting 
    titlePanel(windowTitle = "Conway's Game of Life", 
               h1(strong("Conway's Game of Life"), align ="center",
                  style= "color:white")
               ),

    # set input sliders and numeric inputs into a separate well panel 
    fluidRow(column(2, wellPanel(style = "background: gray; color:white",
                            # create slider for defining the size of the game
                           sliderInput("habitat_size",
                                       "Habitat size",
                                       min = 10,
                                       max = 80,
                                       value = 50),
                            # create slider for defining the number of generations
                           sliderInput("generations",
                                       "Number of generations",
                                       min = 2,
                                       max = 100,
                                       value = 50),
                           # create slider for defining probability of starting life
                           # this is the p value in the binomial distribution used to 
                           # create the starting state
                           sliderInput("prob_life",
                                       "Probability of starting life",
                                       min = 0.05,
                                       max = 0.5,
                                       value = 0.15),
                           # create number inputs for changing the rules of the game of life
                           numericInput("D_U", "Death by underpopulation if neighbours are less than:", 
                                        value = 2, min = 0, max = 8),
                           numericInput("D_O", "Death by overpopulation if neighbours are greater than:", 
                                        value = 3, min = 0, max = 8),
                           numericInput("B_R", "Rebirth by reproduction if neighbours are exactly equal to:", 
                                        value = 3, min = 0, max = 8),
                           actionButton("run", "Start", icon = icon("bolt"), 
                                        style="background: black; color: white; width: 100%"))
            ),
            # create a wellpanel and plot the heatmap which shows the game's life patterns
            # evolving. The wrapped up div calls with dimensions are to allow the heatmap 
            # to be plotted square and centrally in the wellpanel
            column(6, wellPanel(style = "background: gray; color:white",
                        div(style="width: 100%; height: 0; padding-top: 100%; position:relative;",
                            div(style="position: absolute; top: 0; left: 0; width: 100%; height: 100%;",
                                plotlyOutput("plot1", height ="100%"))))), 
            # create a second wellpanel to plot the relative population data
             column(4, wellPanel(style = "background: gray; color:white",
                                 plotlyOutput("plot2")),
                    # a well panel in the bottom right is created to give an introduction to the app
                    # for the user and to link to the appropriate code on github and the README.
                        wellPanel(style = "background: gray; color: white",
                            p("This is an implementation of Conway’s Game of Life using R and Plotly. 
                              This was an exercise in using R, Plotly and Shiny for implementing the Game of Life."),
                            p("Once ‘Start’ is pressed all generations of the habitat are calculated prior to plotting, 
                            this combined with the use of Plotly, does lead to some limitations with the performance 
                            of the system. Most of the calculation time is used for generating the habitat plot. 
                            However, this approach of creating the whole lifespan of the game and plotting with Plotly 
                            does offer some nice features. For example, being able to interactively zoom in on certain areas 
                            of the habitat, rewind and pause generations. Allowing the birth and death of different patterns to be observed. "),
                            p("More details can be found ", a("here", href = "https://github.com/XCStat99/Game-of-Life"))
                    )
             )
   
        )
)
