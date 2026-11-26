# Fix invalid graphics device option
# The Positron R extension sets .ark.graphics.device for IDE integration,
# but it may be invalid if the extension isn't properly loaded.

message("Sourcing .Rprofile, device = ", getOption("device"))

if (identical(getOption("device"), ".ark.graphics.device")) {
  # Test if the ark graphics device is actually functional
  ark_dev <- tryCatch(get(".ark.graphics.device", mode = "function"), error = function(e) NULL)
  
  if (is.null(ark_dev)) {
    # No ark device function found - fall back to png
    options(device = "png")
    message("Set device to png (no ark device)")
  } else {
    # Test if the device can be called
    test_result <- tryCatch({
      ark_dev()
      dev.off()
      TRUE
    }, error = function(e) FALSE)
    
    if (!test_result) {
      # Device function exists but doesn't work - fall back to png
      options(device = "png")
      message("Set device to png (ark device failed)")
    } else {
      message("Kept ark device")
    }
  }
}