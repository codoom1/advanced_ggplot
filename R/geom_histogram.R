#' @title Histogram Layer
#' @description Creates a histogram layer
#' @export
GeomHistogram <- R6::R6Class("GeomHistogram",
  inherit = Layer,
  public = list(
    #' @description Initialize a new histogram layer
    #' @param mapping Aesthetic mappings
    #' @param bins Number of bins
    initialize = function(mapping, bins = NULL) {
      super$initialize(
        mapping = mapping,
        stat = StatBin$new(list(bins = bins))
      )
    },

    #' @description Render the histogram
    #' @param data The data to render
    render = function(data) {
      grid::rectGrob(
        x = data$x,
        y = data$y / 2,
        width = data$width,
        height = data$y,
        just = c("center", "bottom"),
        gp = grid::gpar(
          fill = data$fill %||% "grey50",
          col = data$color %||% "black",
          alpha = data$alpha %||% 1
        )
      )
    }
  )
)

#' @export
geom_histogram <- function(mapping, bins = NULL) {
  GeomHistogram$new(mapping = mapping, bins = bins)
}