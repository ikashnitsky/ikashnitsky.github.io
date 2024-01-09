
# save plots for arrangind a social media post

gd_n2_main |>
    ggplot() +
    geom_sf(fill = "#F48FB1", color = NA)+
    geom_sf(data = bord, color = "#C2185B", size = .5)+
    coord_sf(crs = 3857)+
    theme_void()

ggsave("~/Downloads/merc.pdf", width = 4, height = 4)

gd_n2_main_laea |>
    ggplot() +
    geom_sf(fill = "#DCE775", color = NA)+
    geom_sf(data = bord, color = "#AFB42B", size = .5)+
    theme_void()

ggsave("~/Downloads/laea.pdf", width = 4, height = 4)
