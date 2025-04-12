#' @title Density Plot Layer
#' @description Creates a density plot layer
#' @export
GeomDensity <- R6::R6Class("GeomDensity",
  inherit = Layer,
  public = list(
    #' @description Initialize a new density layer
    #' @param mapping Aesthetic mappings
    #' @param kernel Kernel function to use for density estimation
    #' @param bw Bandwidth method or value
    initialize = function(mapping, kernel = "gaussian", bw = "nrd0") {
      super$initialize(
        mapping = mapping,
        stat = StatDensity$new(list(kernel = kernel, bw = bw))
      )
    },

    #' @description Render the density plot
    #' @param data The data to render
    render = function(data) {
      grid::polygonGrob(
        x = c(data$x, rev(data$x)),
        y = c(data$y, rep(0, length(data$y))),
        gp = grid::gpar(
          fill = data$fill %||% "grey50",
          alpha = data$alpha %||% 0.4,
          col = data$color %||% "black"
        )
      )
    }
  )
)

#' @export
geom_density <- function(mapping, kernel = "gaussian", bw = "nrd0") {
  GeomDensity$new(mapping = mapping, kernel = kernel, bw = bw)
}