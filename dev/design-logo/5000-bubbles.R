#===============================================================================
# 2022-01-24 -- twitter
# for 5000 thread
# Ilya Kashnitsky, ilya.kashnitsky@gmail.com, @ikashnitsky
#===============================================================================

library(tidyverse)
library(magrittr)

# generate bubbles of random color and size
n <- 5e3

set.seed(911)
d = tibble(
    x = runif(n),
    y = runif(n),
    size = runif(n, min = 1, max = 4),
    color = rgb(runif(n), runif(n), runif(n))
) %>%
    arrange(size %>% desc)


(p <- d %>%
    ggplot(aes(x, y, size = size, color = color)) +
    geom_point() +
    scale_color_identity() +
    scale_size_identity() +
    coord_cartesian(c(0, 1), c(0, 1), expand = F) +
    theme_void())

# quatro blog on mobile -- header image ratio 4.64:1
a_ratio = 4.64

ggsave("221217-my-logo/bubbles-banner-large.png", p,  width = 10, height = 10/4.64, bg = "#15202b")

# x1200 for the site
ggsave("221217-my-logo/bubbles-banner.png", p,  width = 10, height = 10/4.64, bg = "#15202b", dpi = 120)

g <- d %>%
    ggplot(aes(x, y, size = size, color = color)) +
    geom_point() +
    scale_color_identity() +
    scale_size_identity() +
    coord_cartesian(c(0, 1), c(0, 1)) +
    theme_void()

ggsave("221217-my-logo/bubbles-github-card.png",g,  width = 6.4, height = 3.2, bg = "#15202b", dpi = 200)



# change colors -----------------------------------------------------------


n <- 5e3

set.seed(911)
p <- tibble(
    x = runif(n),
    y = runif(n),
    size = runif(n, min = .5, max = 2),
    color = rgb(runif(n, max = .1), runif(n, min = .7), runif(n, min = .7))
) %>%
    arrange(size %>% desc) %>%
    ggplot(aes(x, y, size = size, color = color)) +
    geom_point() +
    scale_color_identity() +
    scale_size_identity() +
    coord_cartesian(c(0, 1), c(0, 1), expand = F) +
    theme_void()

ggsave("img/bubbles-blue.png", p,  width = 6.4, height = 3.2, bg = "#15202b", dpi = 200)
