library(gganimate)
library(reshape2)
library(tidyverse)
library(plotly)
theme_set(theme_bw())
#define 'habitat' size
game_size <- 50
#game_size + 2 is used to create a boundary
# around the habitat this will be kept as zeros
n <- game_size +2
#define evolution iterations
frame_tot=10
#initate starting conditions in a matrix, 
#set.seed(2565)
M<-matrix(rbinom(n^2,1,0.1),nrow=n)

#Alive = 1
#Dead = 0

#set boundaries to zero
M[1,] <- M[1,]*0
M[nrow(M),] <- M[nrow(M),]*0
M[,1] <- M[,1]*0
M[,ncol(M)] <- M[,ncol(M)]*0

#create 3D matrix to store animation frames

M3<-array(M, dim = c(dim(M),frame_tot))


#intialize temp matrix to form next step into
M_temp <- M

for (p in 1:frame_tot){
    for (i in 2:(n-1)){
        for (j in 2:(n-1)){
            live_neighbour <- sum(M[(i-1):(i+1),(j-1):(j+1)]) -M[i,j]
            if (M[i,j] == 1){
                if(live_neighbour < 2){
                    M_temp[i,j] <- 0
                }else if(live_neighbour >= 2 & live_neighbour <= 3){
                    M_temp[i,j] <- 1
                }else if(live_neighbour >3){
                    M_temp[i,j] <- 0
                }
            }else if (M[i,j] == 0 & live_neighbour == 3){
                M_temp[i,j] <- 1
            }
        }
    }

    M <- M_temp
    #populate 3D matrix for animation
    M3[,,p] <- M_temp

}


#melt 3D matrix to dataframe to allow plotting
M3_df <-  melt(M3)
colnames(M3_df) <- c('X', 'Y', 'Iteration', 'Z')

#set axis attributes
ax_att <-  list(title="", 
                ticks ="",
                showticklabels=FALSE,
                zeroline =FALSE, 
                showline =FALSE,
                showgrid=FALSE, 
                showspikes = FALSE)

#plot using heatmap
fig <- M3_df %>% 
    plot_ly(x =~X, y=~Y, z = ~Z, frame = ~Iteration, type = "heatmap", showscale = FALSE) %>%
    layout(showlegend = FALSE, xaxis =ax_att, yaxis=ax_att) %>%
    style(hoverinfo = 'none')

fig
