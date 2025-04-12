#' @title Legend Class
#' @description Handles the creation and rendering of plot legends
#' @export
Legend <- R6::R6Class("Legend",
  public = list(
    title = NULL,
    aesthetic = NULL,
    values = NULL,
    labels = NULL,
    
    #' @description Initialize a new legend
    #' @param aesthetic The aesthetic this legend represents (e.g., "color", "fill")
    #' @param title Legend title
    #' @param values The values to show in the legend
    #' @param labels Labels for the values
    initialize = function(aesthetic, title = NULL, values = NULL, labels = NULL) {
      self$aesthetic <- aesthetic
      self$title <- title %||% aesthetic
      self$values <- values
      self$labels <- labels %||% as.character(values)
    },
    
    #' @description Render the legend in the current viewport
    render = function() {
      # Calculate legend dimensions
      n_items <- length(self$values)
      item_height <- unit(0.5, "lines")
      legend_height <- unit(n_items * 0.7, "lines")
      
      # Create viewport for legend
      grid::pushViewport(grid::viewport(
        x = unit(0.95, "npc"),
        y = unit(0.95, "npc"),
        width = unit(3, "lines"),
        height = legend_height,
        just = c("right", "top")
      ))
      
      # Draw legend title
      grid::grid.text(
        self$title,
        x = 0,
        y = unit(1, "npc") + unit(0.5, "lines"),
        just = c("left", "bottom")
      )
      
      # Draw legend items
      for (i in seq_along(self$values)) {
        y_pos <- unit(1, "npc") - unit(i * 0.7, "lines")
        
        # Draw symbol
        if (self$aesthetic == "color" || self$aesthetic == "fill") {
          grid::grid.rect(
            x = unit(0.5, "lines"),
            y = y_pos,
            width = unit(0.8, "lines"),
            height = item_height,
            gp = grid::gpar(
              fill = self$values[i],
              col = self$values[i]
            )
          )
        }
        
        # Draw label
        grid::grid.text(
          self$labels[i],
          x = unit(1.5, "lines"),
          y = y_pos,
          just = "left"
        )
      }
      
      grid::popViewport()
    }
  )
)

#' Create a new legend
#' @export
#' @param aesthetic The aesthetic this legend represents
#' @param title Legend title
#' @param values The values to show in the legend
#' @param labels Labels for the values
create_legend <- function(aesthetic, title = NULL, values = NULL, labels = NULL) {
  Legend$new(
    aesthetic = aesthetic,
    title = title,
    values = values,
    labels = labels
  )
}