#===============================================================================
# 2022-12-17 -- dd
# Demographic Digest logo set
# Ilya Kashnitsky, ilya.kashnitsky@gmail.com, @ikashnitsky
#===============================================================================

# load required packages
library(tidyverse)
library(extrafont)

ah <- "Atkinson Hyperlegible"



# teaser ------------------------------------------------------------------


teaser <- ggplot()+
  coord_equal(xlim = c(0,4), ylim = c(0,2.5), expand = F)+
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

  annotate('text', x = .3, y = 2, label = 'D',
           family = ah, size = 75, fontface = 1,
           color = '#002F2F', hjust = 0, vjust = 1)+

  annotate('text', x = .6, y = .45, label = 'D',
           family = ah, size = 75, fontface = 1,
           color = "#269292", hjust = 0, vjust = 0)+

  annotate('text', x = 1.25, y = 1.8, label = 'emographic',
           family = ah, size = 21, fontface = 2,
           color = '#002F2F', hjust = 0, vjust = 1)+

  annotate('text', x = 1.53, y = .45, label = 'igest',
           family = ah, size = 37, fontface = 1,
           color = "#269292", hjust = 0, vjust = 0)+

  theme_void()

ggsave("img/dd-teaser.png", teaser, width = 8, height = 5, bg = "#eeffff")



# banner ------------------------------------------------------------------

banner <- ggplot()+
    coord_equal(xlim = c(0,92.8), ylim = c(0,20), expand = F)+

    geom_abline(
        intercept = seq(-100, 100, 5), slope = 1,
        colour = "#ffffff", size = 1
    )+
    geom_vline(
        xintercept = seq(-100, 100, 5), colour = "#ffffff", size = 1
    )+
    geom_hline(
        yintercept = seq(-100, 100, 5), colour = "#ffffff", size = 1
    )+

    annotate('text', x = 5, y = 12.1, label = 'D',
             family = ah, size = 30, fontface = 2,
             color = '#002F2F', hjust = 0, vjust = 0)+

    annotate('text', x = 62.5, y = 12.1, label = 'D',
             family = ah, size = 30, fontface = 2,
             color = '#269292', hjust = 0, vjust = 0)+

    annotate('text', x = 12.3, y = 12.1, label = 'emographic',
             family = ah, size = 19, fontface = 2,
             color = '#002F2F', hjust = 0, vjust = 0)+

    annotate('text', x = 70, y = 12.1, label = 'igest',
             family = ah, size = 19, fontface = 2,
             color = "#269292", hjust = 0, vjust = 0)+

    theme_void()

ggsave("img/dd-banner.png", banner, width = 10, height = 10/4.64, bg = "#eeffff")


# logo --------------------------------------------------------------------


logo <- ggplot()+
  coord_equal(xlim = c(0,1), ylim = c(0,1), expand = F)+
  geom_abline(
    intercept = seq(-100, 100, .5), slope = 1,
    colour = "#ffffff", size = .5
  )+
  geom_vline(
    xintercept = seq(-100, 100, .5), colour = "#ffffff", size = .5
  )+
  geom_hline(
    yintercept = seq(-100, 100, .5), colour = "#ffffff", size = .5
  )+

  annotate('text', x = .13, y = .95, label = 'D',
           family = ah, size = 55, fontface = 1,
           color = '#002F2F', hjust = 0, vjust = 1)+

  annotate('text', x = .3, y = .05, label = 'D',
           family = ah, size = 55, fontface = 1,
           color = "#269292", hjust = 0, vjust = 0)+

  theme_minimal()+
  theme(axis.title = element_blank(),
        axis.text = element_blank(),
        axis.ticks = element_blank())


ggsave("img/dd-logo.png", logo, width = 2.5, height = 2.5, bg = "#eeffff")

ggsave("img/dd-logo.svg", logo, width = 2.5, height = 2.5, bg = "#eeffff")




# banner for facebook -----------------------------------------------------


fbanner <- ggplot()+
  coord_equal(xlim = c(0, 6), ylim = c(0,3.375), expand = F)+
  geom_abline(
    intercept = seq(-100, 100, .5), slope = 1,
    colour = "#ffffff", size = .5
  )+
  geom_vline(
    xintercept = seq(-100, 100, .5), colour = "#ffffff", size = .5
  )+
  geom_hline(
    yintercept = seq(-100, 100, .5), colour = "#ffffff", size = .5
  )+

  annotate('text', x = 1.4, y = 2.5, label = 'D',
           family = ah, size = 75, fontface = 1,
           color = '#002F2F', hjust = 0, vjust = 1)+

  annotate('text', x = 1.7, y = .95, label = 'D',
           family = ah, size = 75, fontface = 1,
           color = "#269292", hjust = 0, vjust = 0)+

  annotate('text', x = 2.2, y = 2.3, label = 'emographic',
           family = ah, size = 21, fontface = 2,
           color = '#002F2F', hjust = 0, vjust = 1)+

  annotate('text', x = 2.5, y = .95, label = 'igest',
           family = ah, size = 37, fontface = 1,
           color = "#269292", hjust = 0, vjust = 0)+

  theme_void()+
  theme(axis.title = element_blank(),
        axis.text = element_blank(),
        axis.ticks = element_blank(),
        plot.margin=grid::unit(rep(-0.3, 4), "lines"))

ggsave("img/dd-fbanner.png", fbanner, width = 12, height = 6.75, bg = "#eeffff")

