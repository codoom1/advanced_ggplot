#' @title Point Geometry
#' @description Create a scatter plot layer
#' @export
GeomPoint <- R6::R6Class("GeomPoint",
  inherit = Layer,
  public = list(
    #' @description Render points on the plot
    #' @param data The data frame containing the points to plot
    render = function(data) {
      aes <- self$eval_aes(data)
      x <- aes$x %||% data$x
      y <- aes$y %||% data$y
      color <- aes$color %||% "black"
      size <- aes$size %||% unit(2, "mm")
      
      grid::grid.points(
        x = x,
        y = y,
        default.units = "native",
        gp = grid::gpar(
          col = color,
          fill = color
        ),
        size = size
      )
    }
  )
)

#' Create a point layer
#' @export
#' @param mapping Aesthetic mappings
#' @param size Point size (optional)
#' @return A GeomPoint object
#' @examples
#' \dontrun{
#' plot <- AGPlot$new(data)
#' plot$add_layer(geom_point(list(x = "x", y = "y")))
#' }
geom_point <- function(mapping = NULL, size = NULL) {
  if (!is.null(mapping) && !is.null(size) && is.null(mapping$size)) {
    mapping$size <- size
  }
  
  GeomPoint$new(mapping = mapping)
}