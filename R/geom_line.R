#' @title Line Geometry
#' @description Create a line plot layer
#' @export
GeomLine <- R6::R6Class("GeomLine",
  inherit = Layer,
  public = list(
    #' @description Render lines on the plot
    #' @param data The data frame containing the points to connect
    render = function(data) {
      aes <- self$eval_aes(data)
      x <- aes$x %||% data$x
      y <- aes$y %||% data$y
      color <- aes$color %||% "black"
      size <- aes$size %||% unit(1, "pt")
      
      grid::grid.lines(
        x = x,
        y = y,
        default.units = "native",
        gp = grid::gpar(
          col = color,
          lwd = size
        )
      )
    }
  )
)

#' Create a line layer
#' @export
#' @param mapping Aesthetic mappings
geom_line <- function(mapping = NULL) {
  GeomLine$new(mapping = mapping)
}