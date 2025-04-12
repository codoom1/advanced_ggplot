#' @title Area Geometry
#' @description Create filled area plots
#' @export
GeomArea <- R6::R6Class("GeomArea",
  inherit = Layer,
  public = list(
    #' @description Render area on the plot
    #' @param data Data frame containing the values to plot
    render = function(data) {
      aes <- self$eval_aes(data)
      x <- aes$x %||% data$x
      y <- aes$y %||% data$y
      fill <- aes$fill %||% "steelblue"
      alpha <- aes$alpha %||% 0.6
      
      # Create polygon coordinates (area goes down to y=0)
      x_coords <- c(x[1], x, x[length(x)])
      y_coords <- c(0, y, 0)
      
      grid::grid.polygon(
        x = x_coords,
        y = y_coords,
        gp = grid::gpar(
          fill = fill,
          alpha = alpha,
          col = NA
        )
      )
      
      # Add line on top if specified
      if (!is.null(aes$color)) {
        grid::grid.lines(
          x = x,
          y = y,
          gp = grid::gpar(
            col = aes$color,
            lwd = aes$size %||% 1
          )
        )
      }
    }
  )
)

#' Create an area layer
#' @export
#' @param mapping Aesthetic mappings
geom_area <- function(mapping = NULL) {
  GeomArea$new(mapping = mapping)
}