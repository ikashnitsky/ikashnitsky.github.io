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
analyze_file_chunks <- function(filepath, threshold = 200) {
  content <- readLines(filepath, warn = FALSE)
  content_text <- paste(content, collapse = "\n")
  
  # Remove YAML frontmatter
  content_text <- str_replace(content_text, "^---\\n.*?\\n---\\n", "")
  
  # Remove code blocks
  content_text <- str_replace_all(content_text, "```[\\s\\S]*?```", "")
  
  # Find all headings and their positions
  heading_matches <- str_locate_all(content_text, "\\n#+ [^\\n]+")[[1]]
  
  if (nrow(heading_matches) == 0) {
    # No headings, treat whole file as one section
    sections <- list(list(heading = "[No Headings]", content = content_text))
  } else {
    # Split content into sections based on headings
    sections <- list()
    
    # Text before first heading
    first_heading_start <- heading_matches[1, 1]
    sections[[1]] <- list(heading = "[Intro]", content = str_sub(content_text, 1, first_heading_start - 1))
    
    for (i in 1:nrow(heading_matches)) {
      start <- heading_matches[i, 1]
      end <- if (i < nrow(heading_matches)) heading_matches[i+1, 1] - 1 else nchar(content_text)
      
      heading_line <- str_sub(content_text, heading_matches[i, 1], heading_matches[i, 2])
      heading_text <- str_trim(str_replace(heading_line, "^\\n#+ ", ""))
      section_content <- str_sub(content_text, heading_matches[i, 2] + 1, end)
      
      sections[[i+1]] <- list(heading = heading_text, content = section_content)
    }
  }
  
  # Analyze sections
  long_sections_details <- map_dfr(sections, ~ {
    words <- str_split(str_trim(.x$content), "\\s+")[[1]]
    words <- words[words != ""]
    count <- length(words)
    
    if (count > threshold) {
      return(tibble(heading = .x$heading, word_count = count))
    }
    return(NULL)
  })
  
  if (nrow(long_sections_details) > 0) {
    return(long_sections_details %>% mutate(file = filepath))
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
  cat(sprintf("Found %d long sections (> 200 words) across %d files.\n\n", 
              nrow(results), length(unique(results$file))))
  
  # Select and arrange for better display
  report <- results %>% 
    select(file, heading, word_count) %>% 
    arrange(desc(word_count))
  
  print(as.data.frame(report), row.names = FALSE)
  
  cat("\nACTION REQUIRED:\n")
  cat("For the files listed above, consider breaking long sections into smaller chunks\n")
  cat("using additional H2 (##) or H3 (###) subheadings. Also, ensure each major\n")
  cat("section opens with a 1-2 sentence definition or summary to improve AI extraction.\n")
} else {
  cat("All posts are RAG chunk ready! No sections longer than 200 words found.\n")
}
