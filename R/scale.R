#' @title Scale Class
#' @description Base class for all scale types
#' @export
Scale <- R6::R6Class("Scale",
  public = list(
    aesthetic = NULL,
    name = NULL,
    breaks = NULL,
    labels = NULL,
    limits = NULL,
    
    #' @description Initialize a new scale
    #' @param aesthetic The aesthetic this scale applies to (e.g., "x", "y", "color")
    #' @param name The name to use for the axis or legend
    #' @param breaks Vector of break points
    #' @param labels Vector of labels for the breaks
    #' @param limits Vector of length 2 giving the range of the scale
    initialize = function(aesthetic, name = NULL, breaks = NULL, labels = NULL, limits = NULL) {
      self$aesthetic <- aesthetic
      self$name <- name
      self$breaks <- breaks
      self$labels <- labels
      self$limits <- limits
    },
    
    #' @description Transform data from data space to plot space
    #' @param x Values to transform
    transform = function(x) {
      if (!is.null(self$limits)) {
        x <- pmin(pmax(x, self$limits[1]), self$limits[2])
      }
      x
    },
    
    #' @description Render the axis or legend for this scale
    #' @param side The side to render the axis on ("top", "right", "bottom", "left")
    render_axis = function(side = "bottom") {
      if (is.null(self$breaks)) {
        self$breaks <- pretty(self$limits %||% range(x, na.rm = TRUE))
      }
      if (is.null(self$labels)) {
        self$labels <- as.character(self$breaks)
      }
      
      grid::grid.xaxis(
        at = self$transform(self$breaks),
        label = self$labels,
        main = side %in% c("top", "bottom")
      )
    }
  )
)

#' Create a continuous scale
#' @export
#' @param aesthetic The aesthetic to scale
#' @param name Optional name for the scale
#' @param breaks Optional break points
#' @param labels Optional labels for breaks
#' @param limits Optional limits for the scale
scale_continuous <- function(aesthetic, name = NULL, breaks = NULL, labels = NULL, limits = NULL) {
  Scale$new(
    aesthetic = aesthetic,
    name = name,
    breaks = breaks,
    labels = labels,
    limits = limits
  )
}