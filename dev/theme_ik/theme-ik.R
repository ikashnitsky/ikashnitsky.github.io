#===============================================================================
# 2023-01-03 -- ik-q
# My custom ggplot2 theme
# Ilya Kashnitsky, ilya.kashnitsky@gmail.com, @ikashnitsky
#===============================================================================

library(tidyverse)
sysfonts::font_families()
sysfonts::font_add_google("Atkinson Hyperlegible", "ah")
library(showtext)
showtext_auto()


# copy colors -------------------------------------------------------------
# from "my-colors.R"
# primary
"#269292"
# darker
[1] "#048484FF" "#0C7474FF" "#066666FF" "#025757FF" "#074949FF"
[6] "#033C3CFF" "#002F2FFF" "#002222FF" "#021515FF"
# lighter
[1] "#3A9E9EFF" "#4BA9A9FF" "#5BB5B5FF" "#69C2C2FF" "#77CECEFF"
[6] "#85DADAFF" "#93E7E7FF" "#A1F4F4FF" "#B7FFFFFF"
# secondary
"#DFFF00"


# theme -------------------------------------------------------------------

theme_ik <- theme_minimal()+
    theme(
        plot.title = element_text(face = 2, color = "#074949"),
        plot.subtitle = element_text(color = "#074949"),
        plot.caption = element_text(color = "#074949"),
        axis.title = element_text(color = "#002F2F"),
        axis.text = element_text(color = "#002F2F"),
        plot.background = element_rect(color = NA, fill = "#eeffff"),
        legend.position = "bottom",
        panel.spacing = unit(1, "lines"),
        panel.grid.major = element_line(color = "#ccffff"),
        panel.grid.minor = element_blank(),
        line = element_line(lineend = "round")
    )

# theme_set lines
theme_set(
    theme_minimal(base_family = font_rc, base_size = 15)+
        theme(
            plot.title = element_text(face = 2, color = "#074949"),
            plot.subtitle = element_text(color = "#074949"),
            plot.caption = element_text(color = "#074949"),
            axis.title = element_text(color = "#002F2F"),
            axis.text = element_text(color = "#002F2F"),
            plot.background = element_rect(color = NA, fill = "#eeffff"),
            legend.position = "bottom",
            panel.spacing = unit(1, "lines"),
            panel.grid.major = element_line(color = "#ccffff"),
            panel.grid.minor = element_blank(),
            line = element_line(lineend = "round")
        )
)


# theme function ----------------------------------------------------------

theme_ik <- function(
        base_size = 12,
        base_family = "sans",
        labs_color = "#074949",
        axis_color = "#002F2F",
        bg_color = "#eeffff",
        grid_color = "#ccffff"
){
    theme_minimal(base_size = base_size, base_family = base_family)+
        theme(
            plot.title = element_text(size = base_size*2, face = 2, color = labs_color),
            plot.subtitle = element_text(color = labs_color),
            plot.caption = element_text(color = labs_color),
            axis.title = element_text(color = axis_color),
            axis.text = element_text(color = axis_color),
            plot.background = element_rect(color = NA, fill = bg_color),
            legend.position = "bottom",
            panel.spacing = unit(1, "lines"),
            panel.grid.major = element_line(color = grid_color),
            panel.grid.minor = element_blank(),
            line = element_line(lineend = "round")
        )
}


# ggplot(mtcars, aes(wt, mpg)) +
#     geom_point()+
#     theme_ik(base_family = "ah")+
#     labs(title = "Some title")


# gist --------------------------------------------------------------------

library(tidyverse)
devtools::source_gist("653e1040a07364ae82b1bb312501a184")
theme_set(theme_ik())

# use 'thm' snippet !!!

ggplot(mtcars, aes(wt, mpg)) +
    geom_point()+
    theme_ik()

