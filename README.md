README
================
2024-02-13

## Introduction

This is an implementation of Conway’s Game of Life using R and Plotly.
This was an exercise in using R, Plotly and Shiny for implementing the
Game of Life. The implementation of the game can be found at:
<https://xcstat99.shinyapps.io/Game_of_Life/>

Once ‘Start’ is pressed all generations of the habitat are calculated
prior to plotting, this combined with the use of Plotly, does lead to
some limitations with the performance of the system. Most of the
calculation time is used for generating the habitat plot. However, this
approach of creating the whole lifespan of the game and plotting with
Plotly does offer some nice features. For example, being able to
interactively zoom in on certain areas of the habitat, rewind and pause
generations. Allowing the birth and death of different patterns to be
observed.

## Background

## Control

Using the side panel the size of the ‘habitat’ and the number of
generations (iterations) can be adjusted. Also adjustable is the
‘Probability of starting life’, this corresponds to p in the binomial
distribution which is used for randomly assigning the starting state.

<img width="1114" alt="Game" src="https://github.com/XCStat99/Game-of-Life/assets/120208086/50d6b0df-cef7-4119-9da5-559106b1b08e">


It is also possible to adjust the rules of the Game of Life by adjusting
the text entry boxes, the default values being set to the original of
Conway’s Game of Life:

      *1. Any live cell with fewer than two live neighbours dies, as if
by underpopulation.*

      *2. Any live cell with two or three live neighbours lives on to
the next generation.*

      *3. Any live cell with more than three live neighbours dies, as if
by overpopulation.*

      *4. Any dead cell with exactly three live neighbours becomes a
live cell, as if by reproduction.*

Adjusting these leads to interesting scenarios and helps to explain why
the rules above were chosen. The population changes during the lifespan
of the game can be viewed in the line plot above and changes in the
rules of the game can be observed to have significant effects on the
population of the habitat.

## Perfomance Considerations
