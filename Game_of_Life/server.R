function(input, output, session) {
    #use eventReactive so that computation is only undertaken when the user presses run
    #this prevents an wanted build up of tasks if the user plays with the sliders
    n <- eventReactive(input$run, {
     input$habitat_size 
      })
    frame_tot <- eventReactive(input$run, {
        input$generations
    })
    prob_life <-  eventReactive(input$run, {
        input$prob_life
    })
    B_R <-  eventReactive(input$run, {
        input$B_R
    })
    D_U <-  eventReactive(input$run, {
        input$D_U
    })
    D_O <-  eventReactive(input$run, {
        input$D_O
    })
    observe({
        # a pop notification is created to warn the user that the system is
        # working on the calculations
        if(input$run > 0) {
          showNotification("Please Wait...", type = "message")
       }

        # reassign variables to save on typing
        # define 'habitat' size
        # number of rows given by n
        n <- n()
        # number of columns is a arbitrary fixed ratio of the rows, this makes plotting easier
        m <- as.integer(1.25*n())
        # define evolution iterations
        frame_tot <- frame_tot()
        # initiate starting conditions in a matrix, 
        M<-matrix(rbinom(n*m,1,prob_life()),nrow=n)
        
        # alive and dead cells are assigned 1 or 0:
        # alive = 1
        # dead = 0
        
        # create 3D matrix to store animation frames
        M_all<-array(M, dim = c(dim(M),frame_tot))
        # create data frame to store population stats
        M_pop <- data.frame(Rel_pop = double(), Generation = integer())
        # calculate initial population
        M_pop_t0 <- sum(M)
        
        for (i in 1:frame_tot){
            # make shifted copies of the original M matrix
            M1 = cbind( rep(0,n) , M[,-m] )
            M2 = rbind(rep(0,m),cbind(rep(0,n-1),M[-n,-m]))
            M3 = rbind(rep(0,m),M[-n,])
            M4 = rbind(rep(0,m),cbind(M[-n,-1],rep(0,n-1)))
            M5 = cbind(M[,-1],rep(0,n))
            M6 = rbind(cbind(M[-1,-1],rep(0,n-1)),rep(0,m))
            M7 = rbind(M[-1,],rep(0,m))
            M8 = rbind(cbind(rep(0,n-1),M[-1,-n]),rep(0,m))
            
            # summation of the shifted matrices
            M_tot <- M1 + M2 + M3 + M4 + M5 + M6 + M7 + M8
            #copy the matrix
            M_temp <- M
            # apply the rules of Conway's Game of Life:
            # any live cell with fewer than two live neighbours dies, as if by under population.
            M_temp[M==1 & M_tot<D_U()] <- 0
            # any live cell with more than three live neighbours dies, as if by overpopulation.
            M_temp[M==1 & M_tot>D_O()] <- 0
            # any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.
            M_temp[M==0 & M_tot==B_R()] <- 1
            # populate 3D matrix for animation
            M_all[,,i] <- M_temp
            # here the starting value for the population change is set as zero to allow for nicer plotting
            if (i==1){
                M_pop[nrow(M_pop)+1,] <- c(0,1)
            }
            # check relative population to starting population and store to vector
            rel_pop <- (sum(M_temp) - M_pop_t0)*100/M_pop_t0
            M_pop[nrow(M_pop)+1,] <- c(rel_pop,i+1)
            M <- M_temp
            # check if mass extinction has occurred
            if(sum(M_temp) ==0){
                M_all <- M_all[,,1:i]
                break
            }
            
            
        }
        
        
        # melt 3D matrix to a dataframe to allow plotting with plotly
        M_all_df <-  melt(M_all)
        colnames(M_all_df) <- c('X', 'Y', 'Generation', 'Z')
        # accumulate data to allow trace line graph of relative population changes to be created
        M_pop <- lapply(seq_along(M_pop$Generation), function(x) {
            cbind(M_pop[M_pop$Generation %in% M_pop$Generation[seq(1, x)], ], frame = M_pop$Generation[[x]])})
        M_pop <- bind_rows(M_pop)
        # here the relative population changes are plotted to plot2 in the ui
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
                                    plot_ly(
                                        x =~X, 
                                        y=~Y, 
                                        z = ~Z, 
                                        frame = ~Generation, 
                                        type = "heatmap", 
                                        showscale = FALSE) %>%
                                    layout(
                                        showlegend = FALSE, 
                                        xaxis =ax_att, 
                                        yaxis=ax_att, 
                                        plot_bgcolor = "gray", 
                                        paper_bgcolor = "gray") %>%
                                    style(hoverinfo = 'none') %>% 
                                    # onRender added to start the animation as soon as the calculations are complete
                                    onRender("function(el,x) {Plotly.animate(el);}") %>% 
                                    animation_slider(
                                    currentvalue = list(
                                                        prefix = "Generation ", 
                                                        color = "white"), 
                                                        font = list(
                                                            color="white"), 
                                                            tickcolor ="white") %>% 
                                    animation_button(
                                        bgcolor = "black", 
                                        font = list(color="white"))
                        })
        # here the relative population changes are plotted to plot2 in the ui
        output$plot2 <- renderPlotly({
                            fig2 <- M_pop %>% 
                                    plot_ly(
                                            x=~Generation, 
                                            y=~Rel_pop,
                                            frame = ~frame, 
                                            type = 'scatter', 
                                            mode = 'lines', 
                                            line = list(
                                                simplyfy = TRUE,
                                                color="yellow"))  %>%
                                    layout(
                                        paper_bgcolor = "gray", 
                                        plot_bgcolor = "gray", 
                                        yaxis = list(
                                                title = list(
                                                        text ="Relative Population Change/ %",
                                                        font= list(color ="white")), 
                                                tickfont = list(
                                                        color = "white"),
                                                linecolor = "white",
                                                tickcolor = "white",
                                                gridcolor = "white"), 
                                        xaxis = list(
                                                title = list(
                                                        text ="Life Cycle Generation", 
                                                        font= list(color="white")), 
                                                tickfont = list(
                                                        color = "white"),
                                                linecolor = "white",
                                                tickcolor = "white",
                                                gridcolor = "white",
                                                range = c(0,frame_tot))) %>%
                                    # onRender added to start the animation as soon as the calculations are complete
                                    onRender("function(el,x) {Plotly.animate(el);}") %>%
                                    animation_slider(
                                        currentvalue = list(
                                            prefix = "Generation ", 
                                            color = "white"), 
                                        font = list(
                                            color="white"), 
                                        tickcolor ="white") %>% 
                                    animation_button(
                                        bgcolor = "black", 
                                        font = list(color="white"))
                
                        })
            
    })

}
