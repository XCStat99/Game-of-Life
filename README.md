README
================
2024-02-13

## Introduction

This is an implementation of Conway’s Game of Life using R and Plotly.
This was an exercise in using R, Plotly and Shiny for implementing the
Game of Life. The implementation of the game can be found at:
<https://xcstat99.shinyapps.io/Game_of_Life/>

## Background

The Game of Life, also known simply as Life, is a cellular automaton
devised by the British mathematician John Horton Conway in 1970. It is a
zero-player game, meaning that its evolution is determined by its
initial state, requiring no further input. One interacts with the Game
of Life by creating an initial configuration and observing how it
evolves. It is Turing complete and can simulate a universal constructor
or any other Turing machine.

This description is sourced from Wikipedia and more information can be
found here: <https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life>

## Control

Using the side panel (highlighted in red below) the size of the
‘habitat’ and the number of generations (iterations) can be adjusted.
Also adjustable is the ‘Probability of starting life’, this corresponds
to p in the binomial distribution which is used for randomly assigning
the starting state.

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
the rules in Conway’s Game of Life described above were chosen. Once the
parameters in the control panel have been selected the simulation can be
run by pressing the ‘Start’ button.

Once ‘Start’ is pressed all generations (iterations) will be calculated
and then displayed in the Plotly plot (highlighted in red below). This
may take some time for large habitats over a large number of
generations. This does lead to some limitations in performance as
outlined in the Performance Considerations section below.

Also generated is data on the population changes during the game this is
shown in the line plot in the population panel (highlighted in red
below). This calculates the population change for each generation
relative to the original starting population and it is interesting to
observe how changes in the rules of the game can be observed to have
significant effects on the population of the habitat and its stability.

Occasionally complete extinction will occur, especially if the rules are
changed, at this point the game will end and the output life cycle plot
will have fewer generations than was entered in the control panel.

## Performance Considerations

“Once ‘Start’ is pressed all generations of the habitat are calculated
prior to plotting, this combined with the use of Plotly, does lead to
some limitations with the performance of the game. Most of this
calculation time is actually used for generating the habitat plot.
However, this approach of creating the whole lifespan of the game and
plotting with Plotly does offer some nice features. For example, being
able to interactively zoom in on certain areas of the habitat, rewind
and pause generations. Allowing the birth and death of different
patterns to be observed.

Clearly faster ways of calculating the Game of Life are possible, but
this was purely a fun exercise to see what was possible with Plotly, R
and Shiny.
