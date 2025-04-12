# AGTheme class is documented in AGTheme-doc.R
#' @export
#' @keywords internal
AGTheme <- R6::R6Class("AGTheme",
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
#'
#' Creates a new AGTheme object with the specified elements.
#'
#' @param ... Named theme elements
#' @return A AGTheme object
#' @export
#' @examples
#' \dontrun{
#' my_theme <- theme(
#'   plot.background = list(fill = "lightyellow"),
#'   axis.line = list(color = "darkgrey")
#' )
#' }
theme <- function(...) {
  AGTheme$new(...)
}

#' Create a minimal theme with light background
#' @export
#' @return A AGTheme object with minimal styling
#' @examples
#' \dontrun{
#' plot <- AGPlot$new(data)
#' plot$set_theme(theme_minimal())
#' }
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

#' Create a dark theme with dark background
#' @export
#' @return A AGTheme object with dark styling
#' @examples
#' \dontrun{
#' plot <- AGPlot$new(data)
#' plot$set_theme(theme_dark())
#' }
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