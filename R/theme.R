#' @title Theme Class
#' @description Controls the visual appearance of plot elements
#' @export
Theme <- R6::R6Class("Theme",
  public = list(
    # Plot region
    plot.background = NULL,
    plot.margin = NULL,
    
    # Panel
    panel.background = NULL,
    panel.grid.major = NULL,
    panel.grid.minor = NULL,
    panel.border = NULL,
    
    # Axis
    axis.line = NULL,
    axis.text = NULL,
    axis.title = NULL,
    axis.ticks = NULL,
    
    #' @description Initialize a new theme
    #' @param ... Named list of theme elements
    initialize = function(...) {
      elements <- list(...)
      for (name in names(elements)) {
        if (name %in% names(self)) {
          self[[name]] <- elements[[name]]
        }
      }
    },
    
    #' @description Apply theme elements to the current viewport
    apply = function() {
      # Set plot background
      if (!is.null(self$plot.background)) {
        grid::grid.rect(
          gp = grid::gpar(
            fill = self$plot.background$fill %||% "white",
            col = self$plot.background$color %||% NA
          )
        )
      }
      
      # Set panel background
      if (!is.null(self$panel.background)) {
        grid::grid.rect(
          gp = grid::gpar(
            fill = self$panel.background$fill %||% "grey95",
            col = self$panel.background$color %||% NA
          )
        )
      }
      
      # Draw major grid lines
      if (!is.null(self$panel.grid.major)) {
        # Implementation for major grid lines
      }
      
      # Additional theme elements will be applied here
    }
  )
)

#' Create a new theme
#' @export
#' @param ... Named theme elements
theme <- function(...) {
  Theme$new(...)
}

#' @export
theme_minimal <- function() {
  theme(
    plot.background = list(fill = "white", color = NA),
    panel.background = list(fill = "white", color = NA),
    panel.grid.major = list(color = "grey90", size = 0.5),
    panel.grid.minor = list(color = "grey95", size = 0.25),
    axis.line = list(color = "grey20", size = 0.5),
    axis.text = list(color = "grey30", size = 8),
    axis.title = list(color = "grey30", size = 10)
  )
}

#' @export
theme_dark <- function() {
  theme(
    plot.background = list(fill = "grey20", color = NA),
    panel.background = list(fill = "grey15", color = NA),
    panel.grid.major = list(color = "grey30", size = 0.5),
    panel.grid.minor = list(color = "grey25", size = 0.25),
    axis.line = list(color = "grey70", size = 0.5),
    axis.text = list(color = "grey80", size = 8),
    axis.title = list(color = "grey90", size = 10)
  )
}