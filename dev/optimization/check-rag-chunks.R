#!/usr/bin/env Rscript
# Script to identify blog posts with sections longer than 200 words.
# This helps satisfy the GEO audit's RAG chunk readiness suggestion.

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
analyze_file_chunks <- function(filepath) {
  content <- readLines(filepath, warn = FALSE)
  content_text <- paste(content, collapse = "\n")
  
  # Remove YAML frontmatter
  content_text <- str_replace(content_text, "^---\\n.*?\\n---\\n", "")
  
  # Remove code blocks
  content_text <- str_replace_all(content_text, "```[\\s\\S]*?```", "")
  
  # Split by headings
  sections <- str_split(content_text, "\\n#+ ")[[1]]
  
  # Count words in each section
  word_counts <- map_int(sections, ~ {
    words <- str_split(str_trim(.x), "\\s+")[[1]]
    words <- words[words != ""]
    length(words)
  })
  
  # Check if any section is > 200 words
  long_sections <- word_counts[word_counts > 200]
  
  if (length(long_sections) > 0) {
    return(tibble(
      file = filepath,
      total_sections = length(sections),
      long_sections_count = length(long_sections),
      max_words = max(long_sections)
    ))
  }
  return(NULL)
}

# Run analysis
results <- map_dfr(files_to_check, analyze_file_chunks)

# Output results
if (nrow(results) > 0) {
  cat("========================================================================\n")
  cat("RAG CHUNK READINESS DIAGNOSTIC REPORT\n")
  cat("========================================================================\n")
  cat(sprintf("Found %d files with sections > 200 words.\n\n", nrow(results)))
  
  results <- results %>% arrange(desc(max_words))
  
  print(as.data.frame(results))
  
  cat("\nACTION REQUIRED:\n")
  cat("For the files listed above, consider breaking long sections into smaller chunks\n")
  cat("using additional H2 (##) or H3 (###) subheadings. Also, ensure each major\n")
  cat("section opens with a 1-2 sentence definition or summary to improve AI extraction.\n")
} else {
  cat("All posts are RAG chunk ready! No sections longer than 200 words found.\n")
}
