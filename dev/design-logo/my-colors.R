#===============================================================================
# 2022-12-17 -- ik-q
# Create my own logo in vector
# Ilya Kashnitsky, ilya.kashnitsky@gmail.com, @ikashnitsky
#===============================================================================

# load required packages
library(purrr)
library(magrittr)
library(prismatic)

my_teal <- "#269292"

# darker
seq(.1, .9, .1) |>
    map_chr(
        .x = .,
        .f = function(x) x |> clr_darken(my_teal, .)
    )

# lighter
seq(.1, .9, .1) |>
    map_chr(
        .x = .,
        .f = function(x) x |> clr_lighten(my_teal, .)
    )
