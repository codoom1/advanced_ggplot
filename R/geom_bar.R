#' @title Bar Geometry
#' @description Create bar plots
#' @export
GeomBar <- R6::R6Class("GeomBar",
  inherit = Layer,
  public = list(
    #' @description Initialize a new bar geometry
    #' @param mapping Aesthetic mappings
    #' @param width Bar width as a proportion of the resolution of the data
    initialize = function(mapping = NULL, width = 0.9) {
      super$initialize(mapping)
      private$width <- width
    },
    
    #' @description Render bars on the plot
    #' @param data The data frame containing the values to plot
    render = function(data) {
      aes <- self$eval_aes(data)
      x <- aes$x %||% data$x
      y <- aes$y %||% data$y
      fill <- aes$fill %||% "grey35"
      color <- aes$color %||% "black"
      
      # If y is not provided, count occurrences of x
      if (is.null(y)) {
        counts <- table(x)
        x <- as.numeric(names(counts))
        y <- as.numeric(counts)
      }
      
      # Calculate bar positions and widths
      width <- private$width * min(diff(sort(unique(x))))
      
      # Draw bars
      for (i in seq_along(x)) {
        grid::grid.rect(
          x = x[i],
          y = y[i] / 2,
          width = width,
          height = y[i],
          just = c("center", "bottom"),
          gp = grid::gpar(
            fill = fill,
            col = color
          )
        )
      }
    }
  ),
  
  private = list(
    width = NULL
  )
)

#' Create a bar layer
#' @export
#' @param mapping Aesthetic mappings
#' @param width Bar width as a proportion of the resolution of the data
geom_bar <- function(mapping = NULL, width = 0.9) {
  GeomBar$new(mapping = mapping, width = width)
}