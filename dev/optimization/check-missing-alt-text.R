#!/usr/bin/env Rscript
# Script to identify blog posts with images lacking alt text (![]()).
# This helps satisfy GEO requirements for multimodal model image understanding.

suppressPackageStartupMessages({
  library(fs)
  library(stringr)
  library(purrr)
  library(dplyr)
})

# Define directories to scan (post directories from 2017 to 2026)
years <- 2017:2026
dirs_to_scan <- as.character(years)
dirs_to_scan <- dirs_to_scan[dir_exists(dirs_to_scan)]

# Get all .qmd and .md files in the post directories
files_to_check <- dir_ls(dirs_to_scan, recurse = TRUE, type = "file", regexp = "\\.(qmd|md)$")

# Ignore index.qmd/md in the root of year directories if any
files_to_check <- files_to_check[!str_detect(files_to_check, "^\\d{4}/index\\.(qmd|md)$")]

# Function to analyze a single file
analyze_alt_text <- function(filepath) {
  content <- readLines(filepath, warn = FALSE)
  content_text <- paste(content, collapse = "\n")
  
  # Regex to find markdown images with empty alt text, e.g. ![](image.jpg)
  # It looks for ![ followed by optional spaces, then ], then (
  missing_alt_matches <- str_extract_all(content_text, "!\\[\\s*\\]\\([^\\)]+\\)")[[1]]
  
  if (length(missing_alt_matches) > 0) {
    # Extract the "src" part for better reporting
    img_srcs <- str_extract(missing_alt_matches, "\\([^\\)]+\\)") %>% 
      str_remove_all("[\\(\\)]")
    
    return(tibble(
      file = filepath,
      image = img_srcs
    ))
  }
  return(NULL)
}

# Run analysis
results <- map_dfr(files_to_check, analyze_alt_text)

# Output results
if (nrow(results) > 0) {
  cat("========================================================================\n")
  cat("MISSING IMAGE ALT TEXT DIAGNOSTIC REPORT\n")
  cat("========================================================================\n")
  cat(sprintf("Found %d images missing alt text across %d files.\n\n", 
              nrow(results), length(unique(results$file))))
  
  print(as.data.frame(results), row.names = FALSE)
  
  cat("\nACTION REQUIRED:\n")
  cat("For the files listed above, please add descriptive alt text inside the brackets []\n")
  cat("Example: change ![](plot.png) to ![Bar chart showing demographic changes](plot.png)\n")
  cat("This is crucial for accessibility and Multimodal AI (GEO) understanding.\n")
} else {
  cat("All images have alt text! Excellent for GEO and accessibility.\n")
}
