#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)
library(gganimate)
library(reshape2)
library(tidyverse)
library(plotly)
library(htmlwidgets)

# Define server logic required to draw a histogram
function(input, output, session) {

    n <- eventReactive(input$run, {
     input$habitat_size 
      })
    frame_tot <- eventReactive(input$run, {
        input$iterations
    })
    prob_life <-  eventReactive(input$run, {
        input$prob_life
    })
    observe({
        #reassign variables to save on typing
        #define 'habitat' size
        n <- n()
        #define evolution iterations
        frame_tot <- frame_tot()
        #initate starting conditions in a matrix, 
        M<-matrix(rbinom(n^2,1,prob_life()),nrow=n)
        
        #Alive and dead cells are assigned 1 or 0:
        #Alive = 1
        #Dead = 0
        
        #create 3D matrix to store animation frames
        M_all<-array(M, dim = c(dim(M),frame_tot))
        #create data frame to store population stats
        M_pop <- data.frame(Rel_pop = double(), Iteration = integer())
        
        for (i in 1:frame_tot){
            # make shifted copies of the original M matrix
            M1 = cbind( rep(0,n) , M[,-n] )
            M2 = rbind(rep(0,n),cbind(rep(0,n-1),M[-n,-n]))
            M3 = rbind(rep(0,n),M[-n,])
            M4 = rbind(rep(0,n),cbind(M[-n,-1],rep(0,n-1)))
            M5 = cbind(M[,-1],rep(0,n))
            M6 = rbind(cbind(M[-1,-1],rep(0,n-1)),rep(0,n))
            M7 = rbind(M[-1,],rep(0,n))
            M8 = rbind(cbind(rep(0,n-1),M[-1,-n]),rep(0,n))
            
            # summation of the shifted matrices
            M_tot <- M1 + M2 + M3 + M4 + M5 + M6 + M7 + M8
            
            # apply the rules of Conway's Game of Life
            M_temp <- M
            # Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.
            M_temp[M==0 & M_tot==3] <- 1
            # Any live cell with fewer than two live neighbours dies, as if by underpopulation.
            M_temp[M==1 & M_tot<2] <- 0
            # Any live cell with more than three live neighbours dies, as if by overpopulation.
            M_temp[M==1 & M_tot>3] <- 0
            #populate 3D matrix for animation
            M_all[,,i] <- M_temp
            M <- M_temp
            #check relative population  and store to vector
            rel_pop <- sum(M_temp)*100/(n^2)
            M_pop[nrow(M_pop)+1,] <- c(rel_pop,i)
            #check if mass extinction has occured
            if(rel_pop ==0){
                M_all <- M_all[,,1:i]
                break
            }
            
        }
        
        
        #melt 3D matrix to dataframe to allow plotting
        M_all_df <-  melt(M_all)
        colnames(M_all_df) <- c('X', 'Y', 'Iteration', 'Z')
        #accumulate data to allow trace scatter to be created
        M_pop <- lapply(seq_along(M_pop$Iteration), function(x) {
            cbind(M_pop[M_pop$Iteration %in% M_pop$Iteration[seq(1, x)], ], frame = M_pop$Iteration[[x]])})
        M_pop <- bind_rows(M_pop)

            output$plot1 <- renderPlotly({
                #set axis attributes
                ax_att <-  list(title="", 
                                ticks ="",
                                showticklabels=FALSE,
                                zeroline =FALSE, 
                                showline =FALSE,
                                showgrid=FALSE, 
                                showspikes = FALSE)
                #plot using heatmap
                fig1 <- M_all_df %>% 
                    plot_ly(x =~X, y=~Y, z = ~Z, frame = ~Iteration, type = "heatmap", showscale = FALSE) %>%
                    layout(showlegend = FALSE, xaxis =ax_att, yaxis=ax_att, paper_bgcolor = "dimgray") %>%
                    style(hoverinfo = 'none') %>% onRender("function(el,x) {Plotly.animate(el);}") %>% animation_slider(
                        currentvalue = list(prefix = "Iteration ", color = "white"), font = list(color="white")) %>% animation_button(bgcolor = "black", font = list(color="white"))
                
                fig2 <- M_pop %>% plot_ly(x=~Iteration, y=~Rel_pop,frame = ~frame, type = 'scatter', mode = 'lines', line = list(simplyfy = F))  %>%
                    layout(title = "Relative Population / %", yaxis = list(title = "Relative Population / %"), xaxis = list(title = "Life Cycle Iteration")) %>%
                    onRender("function(el,x) {Plotly.animate(el);}") 
                fig <- subplot(fig1, fig2) %>% 
                    layout(title = 'Side By Side Subplots') %>% animation_slider(
                        currentvalue = list(prefix = "Iteration ", color = "white"), font = list(color="white"))
                fig
        
            })
            output$plot2 <- renderPlotly({
                fig2 <- M_pop %>% plot_ly(x=~Iteration, y=~Rel_pop,frame = ~frame, type = 'scatter', mode = 'lines', line = list(simplyfy = F))  %>%
                    layout(title = "Relative Population / %", yaxis = list(title = "Relative Population / %"), xaxis = list(title = "Life Cycle Iteration")) %>%
                    onRender("function(el,x) {Plotly.animate(el);}") %>% animation_opts(redraw = TRUE)
            })
    })

}
