#===============================================================================
# 2022-12-17 -- ik-q
# Create my own logo in vector
# Ilya Kashnitsky, ilya.kashnitsky@gmail.com, @ikashnitsky
#===============================================================================

# load required packages
library(tidyverse)
library(extrafont)

ah <- "Atkinson Hyperlegible"

theme_set(
   theme_minimal(base_family = ah)+
        theme(
            plot.background = element_rect(fill = "#eeffff", color = NA),
            legend.position = "none",
            panel.spacing = unit(.5, "lines"),
            panel.grid.minor = element_blank(),
            plot.title = element_text(size = 22, face = 2, color = "#002F2F"),
            line = element_line(lineend = "round")
        )
)

logo <- ggplot()+
    geom_abline(
        intercept = seq(-100, 100, .5), slope = 1,
        colour = "#ffffff", size = 2
    )+
    geom_vline(
        xintercept = seq(-100, 100, .5), colour = "#ffffff", size = 2
    )+
    geom_hline(
        yintercept = seq(-100, 100, .5), colour = "#ffffff", size = 2
    )+
        labs(x=NULL, y=NULL, title=NULL)+

        coord_equal(xlim = c(0,1), ylim = c(0,1), expand = F)+
        annotate('text', x = .03, y = .9, label = 'i',
                 family = "Consolas", size = 40, fontface = 1,
                 color = '#269292', hjust = 0, vjust = 1)+
        annotate('text', x = .97, y = .1, label = 'k',
                 family = "Roboto Mono", size = 40, fontface = 1,
                 color = '#002F2F', hjust = 1, vjust = 0)+
        #theme_minimal()

        theme_void()+
        theme(plot.margin=grid::unit(c(0,0,-0.2,-0.2), "lines"))

ggsave("img/logo.png", logo, width = 2, height = 2, bg = "#eeffff", dpi = 256)




# twitter -----------------------------------------------------------------



card_tw <- ggplot()+
        coord_equal(xlim = c(0,9.55), ylim = c(0,5), expand = F)+
    geom_abline(
        intercept = seq(-100, 100, .5), slope = 1,
        colour = "#ffffff", size = 1
    )+
    geom_vline(
        xintercept = seq(-100, 100, .5), colour = "#ffffff", size = 1
    )+
    geom_hline(
        yintercept = seq(-100, 100, .5), colour = "#ffffff", size = 1
    )+

        annotate('text', x = .25, y = 10/3,
                 label = "demographe        's",
                 family = ah, size = 18, fontface = 1,
                 color = '#002F2F', hjust = 0, vjust = 0)+

        annotate('text', x = 4.1, y = 1.95, label = 'R',
                 family = ah, size = 72, fontface = 2,
                 color = '#269292', hjust = 0, vjust = 0)+

        annotate('text', x = 9.5, y = 1.95, label = 'notes',
                 family = ah, size = 36, fontface = 1,
                 color = "#269292", hjust = 1, vjust = 0)+

        annotate('text', x = 9, y = 1.15, label = 'ikashnitsky.github.io',
                 family = ah, size = 12, fontface = 1,
                 color = "#93E7E7", hjust = 1, vjust = 0)+

        theme_void()+
        theme(plot.margin=grid::unit(c(0,0,-0.2,-0.2), "lines"))

ggsave("img/card-tw.png", card_tw, width = 9.55, height = 5, bg = "#eeffff", dpi = 200)

#
# # demographic digest
# teaser_dd <- ggplot()+
#         coord_equal(xlim = c(0,4), ylim = c(0,2.5), expand = c(0,0))+
#         geom_abline(intercept=seq(-100, 100, .5),slope=1,colour="#ffffff",size = .5)+
#         geom_vline(xintercept = seq(-100, 100, .5), colour="#ffffff",size = .5)+
#         geom_hline(yintercept = seq(-100, 100, .5), colour="#ffffff",size = .5)+
#
#         annotate('text', x = .3, y = 2.25, label = 'D',
#                  family = ah, size = 75, fontface = 1,
#                  color = '#002F2F', hjust = 0, vjust = 1)+
#
#         annotate('text', x = .6, y = .7, label = 'D',
#                  family = ah, size = 75, fontface = 1,
#                  color = "#269292", hjust = 0, vjust = 0)+
#
#         annotate('text', x = 1.15, y = 2.05, label = 'emographic',
#                  family = ah, size = 21, fontface = 2,
#                  color = '#002F2F', hjust = 0, vjust = 1)+
#
#         annotate('text', x = 1.4, y = .7, label = 'igest',
#                  family = ah, size = 37, fontface = 1,
#                  color = "#269292", hjust = 0, vjust = 0)+
#
#         annotate('text', x = .4, y = .25, label = 'ikashnitsky.github.io/dd',
#                  family = ah, size = 10, fontface = 1,
#                  color = "#93E7E7", hjust = 0, vjust = 1)+
#
#         theme_void()+
#         theme(panel.background = element_rect(fill = '#eeffff'),
#               plot.margin=grid::unit(c(0,0,-0.2,-0.2), "lines"))
#
# ik_explot_png(teaser_dd, '2017/170105-my-logo/teaser-dd.png', w = 8, h = 5, dpi = 256)
