#' @title Position Adjustment Class
#' @description Base class for position adjustments
#' @export
Position <- R6::R6Class("Position",
  public = list(
    #' @description Initialize position adjustment
    initialize = function() {},
    
    #' @description Adjust positions of data points
    #' @param data Data frame containing positions to adjust
    adjust = function(data) {
      data
    }
  )
)

#' @title Stack Position Adjustment
#' @description Stack overlapping geometries (e.g., for stacked bar charts)
#' @export
PositionStack <- R6::R6Class("PositionStack",
  inherit = Position,
  public = list(
    #' @description Adjust positions by stacking
    #' @param data Data frame containing positions to stack
    adjust = function(data) {
      if (is.null(data$y)) return(data)
      
      # Group by x position
      split_data <- split(data$y, data$x)
      
      # Calculate cumulative sums for each group
      new_y <- list()
      for (group in names(split_data)) {
        y_values <- split_data[[group]]
        new_y[[group]] <- cumsum(y_values)
      }
      
      # Update y positions
      data$y <- unlist(new_y)
      data
    }
  )
)

#' @title Dodge Position Adjustment
#' @description Adjust positions by dodging overlapping geometries
#' @export
PositionDodge <- R6::R6Class("PositionDodge",
  inherit = Position,
  public = list(
    width = 0.75,
    
    #' @description Initialize dodge position adjustment
    #' @param width Width of the dodging
    initialize = function(width = 0.75) {
      self$width <- width
    },
    
    #' @description Adjust positions by dodging
    #' @param data Data frame containing positions to dodge
    adjust = function(data) {
      if (is.null(data$x) || is.null(data$group)) return(data)
      
      # Calculate offset for each group
      groups <- unique(data$group)
      n <- length(groups)
      group_pos <- seq_len(n) - (n + 1) / 2
      width <- self$width / n
      
      # Apply offset based on group
      data$x <- data$x + width * group_pos[match(data$group, groups)]
      data
    }
  )
)

#' @title Jitter Position Adjustment
#' @description Add random noise to prevent overplotting
#' @export
PositionJitter <- R6::R6Class("PositionJitter",
  inherit = Position,
  public = list(
    width = 0.4,
    height = 0.4,
    
    #' @description Initialize jitter position adjustment
    #' @param width Amount of horizontal jitter
    #' @param height Amount of vertical jitter
    initialize = function(width = 0.4, height = 0.4) {
      self$width <- width
      self$height <- height
    },
    
    #' @description Adjust positions by adding jitter
    #' @param data Data frame containing positions to jitter
    adjust = function(data) {
      if (!is.null(data$x)) {
        data$x <- data$x + stats::runif(length(data$x), -self$width/2, self$width/2)
      }
      if (!is.null(data$y)) {
        data$y <- data$y + stats::runif(length(data$y), -self$height/2, self$height/2)
      }
      data
    }
  )
)

#' Create a stack position adjustment
#' @export
position_stack <- function() {
  PositionStack$new()
}

#' Create a dodge position adjustment
#' @export
#' @param width Width of the dodging
position_dodge <- function(width = 0.75) {
  PositionDodge$new(width = width)
}

#' Create a jitter position adjustment
#' @export
#' @param width Amount of horizontal jitter
#' @param height Amount of vertical jitter
position_jitter <- function(width = 0.4, height = 0.4) {
  PositionJitter$new(width = width, height = height)
}