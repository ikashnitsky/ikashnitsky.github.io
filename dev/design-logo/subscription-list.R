#===============================================================================
# 2022-12-21 -- ik-q
# process the list of emails
# Ilya Kashnitsky, ilya.kashnitsky@gmail.com, @ikashnitsky
#===============================================================================


library(tidyverse)
library(rvest)

url <- "https://www.pythonanywhere.com/user/ikashnitsky/shares/a79496ed3b5246bba659158c576f313e/"

foo <- read_html(url)[2] %>%
    html_nodes() %>%
    html_table(fill = T)

foo <- read_lines("https://www.pythonanywhere.com/user/ikashnitsky/files/home/ikashnitsky/email_repo.txt")



