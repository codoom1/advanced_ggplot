#' @title Smoothed Line Layer
#' @description Creates a smoothed line layer with optional confidence intervals
#' @export
GeomSmooth <- R6::R6Class("GeomSmooth",
  inherit = Layer,
  public = list(
    #' @description Initialize a new smooth layer
    #' @param mapping Aesthetic mappings
    #' @param method Smoothing method ("loess" or "lm")
    #' @param span Parameter controlling the amount of smoothing
    initialize = function(mapping, method = "loess", span = 0.75) {
      super$initialize(
        mapping = mapping,
        stat = StatSmooth$new(list(method = method, span = span))
      )
    },

    #' @description Render the smoothed line and confidence interval
    #' @param data The data to render
    render = function(data) {
      ribbon <- grid::polygonGrob(
        x = c(data$x, rev(data$x)),
        y = c(data$ymax, rev(data$ymin)),
        gp = grid::gpar(
          fill = data$fill %||% "grey70",
          alpha = data$alpha %||% 0.2,
          col = NA
        )
      )
      
      line <- grid::polylineGrob(
        x = data$x,
        y = data$y,
        gp = grid::gpar(
          col = data$color %||% "blue",
          lwd = data$size %||% 1,
          alpha = data$alpha %||% 1
        )
      )
      
      grid::gTree(children = grid::gList(ribbon, line))
    }
  )
)

#' Create a smoothed line layer with confidence intervals
#' @export
#' @param mapping Aesthetic mappings
#' @param method Smoothing method ("loess" or "lm")
#' @param span Parameter controlling the amount of smoothing
#' @return A GeomSmooth object
#' @examples
#' \dontrun{
#' plot <- AGPlot$new(data)
#' plot$add_layer(geom_smooth(list(x = "x", y = "y")))
#' }
geom_smooth <- function(mapping, method = "loess", span = 0.75) {
  GeomSmooth$new(mapping = mapping, method = method, span = span)
}