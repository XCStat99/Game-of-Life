#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)

# Define UI for application that draws a histogram
fluidPage(
    
     # Application title
    titlePanel("Conway's Game of Life"),

    # Sidebar with a slider input for number of bins
    fluidRow(
        column(4,
               wellPanel(
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
                           actionButton("run", "Run!"),
                        )
               ),
        splitLayout(cellWidths = c("50%", "50%"), plotlyOutput("plot1"), plotlyOutput("plot2")),
               
        
               
        
    )
    
)
