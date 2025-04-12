#' @title Ribbon Geometry
#' @description Create ribbon plots (e.g., confidence bands)
#' @export
GeomRibbon <- R6::R6Class("GeomRibbon",
  inherit = Layer,
  public = list(
    #' @description Render ribbon on the plot
    #' @param data Data frame containing the values to plot
    render = function(data) {
      aes <- self$eval_aes(data)
      x <- aes$x %||% data$x
      ymin <- aes$ymin %||% data$ymin
      ymax <- aes$ymax %||% data$ymax
      fill <- aes$fill %||% "steelblue"
      alpha <- aes$alpha %||% 0.3
      
      # Create polygon for ribbon
      x_coords <- c(x, rev(x))
      y_coords <- c(ymin, rev(ymax))
      
      grid::grid.polygon(
        x = x_coords,
        y = y_coords,
        gp = grid::gpar(
          fill = fill,
          alpha = alpha,
          col = NA  # No border by default
        )
      )
    }
  )
)

#' Create a ribbon layer
#' @export
#' @param mapping Aesthetic mappings
geom_ribbon <- function(mapping = NULL) {
  GeomRibbon$new(mapping = mapping)
}