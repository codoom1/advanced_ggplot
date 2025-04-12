#' @title Coordinate System Class
#' @description Base class for coordinate systems
#' @export
Coord <- R6::R6Class("Coord",
  public = list(
    #' @description Transform coordinates
    #' @param x x-coordinates
    #' @param y y-coordinates
    transform = function(x, y) {
      list(x = x, y = y)
    },
    
    #' @description Transform limits
    #' @param xlim x-axis limits
    #' @param ylim y-axis limits
    transform_limits = function(xlim, ylim) {
      list(xlim = xlim, ylim = ylim)
    }
  )
)

#' @title Cartesian Coordinate System
#' @description Standard Cartesian coordinates
#' @export
CoordCartesian <- R6::R6Class("CoordCartesian",
  inherit = Coord,
  public = list(
    xlim = NULL,
    ylim = NULL,
    expand = TRUE,
    
    #' @description Initialize Cartesian coordinates
    #' @param xlim x-axis limits
    #' @param ylim y-axis limits
    #' @param expand Whether to expand limits
    initialize = function(xlim = NULL, ylim = NULL, expand = TRUE) {
      self$xlim <- xlim
      self$ylim <- ylim
      self$expand <- expand
    }
  )
)

#' @title Polar Coordinate System
#' @description Polar coordinates for circular plots
#' @export
CoordPolar <- R6::R6Class("CoordPolar",
  inherit = Coord,
  public = list(
    theta = "x",
    start = 0,
    direction = 1,
    
    #' @description Initialize polar coordinates
    #' @param theta Variable to map to angle ("x" or "y")
    #' @param start Starting angle in radians
    #' @param direction Direction of rotation (1 or -1)
    initialize = function(theta = "x", start = 0, direction = 1) {
      self$theta <- theta
      self$start <- start
      self$direction <- direction
    },
    
    #' @description Transform coordinates to polar
    #' @param x x-coordinates
    #' @param y y-coordinates
    transform = function(x, y) {
      # Convert to polar coordinates
      if (self$theta == "x") {
        r <- y
        theta <- x
      } else {
        r <- x
        theta <- y
      }
      
      # Adjust angle based on start and direction
      theta <- self$start + self$direction * theta
      
      # Convert to Cartesian coordinates
      list(
        x = r * cos(theta),
        y = r * sin(theta)
      )
    }
  )
)

#' @title Log Coordinate System
#' @description Logarithmic coordinate transformation
#' @export
CoordLog <- R6::R6Class("CoordLog",
  inherit = Coord,
  public = list(
    base = exp(1),
    
    #' @description Initialize log coordinates
    #' @param base Base of logarithm
    initialize = function(base = exp(1)) {
      self$base <- base
    },
    
    #' @description Transform coordinates to log scale
    #' @param x x-coordinates
    #' @param y y-coordinates
    transform = function(x, y) {
      list(
        x = log(x, base = self$base),
        y = log(y, base = self$base)
      )
    },
    
    #' @description Transform limits to log scale
    #' @param xlim x-axis limits
    #' @param ylim y-axis limits
    transform_limits = function(xlim, ylim) {
      list(
        xlim = log(xlim, base = self$base),
        ylim = log(ylim, base = self$base)
      )
    }
  )
)

#' @title Position Adjustment Class
#' @description Base class for position adjustments
#' @export
Position <- R6::R6Class("Position",
  public = list(
    #' @description Adjust positions of graphical elements
    #' @param data Data frame containing positions
    adjust = function(data) {
      data
    }
  )
)

#' @title Stack Position Adjustment
#' @description Stack overlapping elements
#' @export
PositionStack <- R6::R6Class("PositionStack",
  inherit = Position,
  public = list(
    #' @description Adjust positions by stacking
    #' @param data Data frame containing positions
    adjust = function(data) {
      if (is.null(data$y)) return(data)
      
      # Calculate cumulative sums for stacking
      data$y <- ave(data$y,
                    data$x,
                    FUN = cumsum)
      data
    }
  )
)

#' @title Dodge Position Adjustment
#' @description Dodge overlapping elements
#' @export
PositionDodge <- R6::R6Class("PositionDodge",
  inherit = Position,
  public = list(
    width = 0.75,
    
    #' @description Initialize dodge position
    #' @param width Width of dodging
    initialize = function(width = 0.75) {
      self$width <- width
    },
    
    #' @description Adjust positions by dodging
    #' @param data Data frame containing positions
    adjust = function(data) {
      if (is.null(data$x)) return(data)
      
      # Calculate number of groups and offset
      groups <- length(unique(data$group))
      if (groups < 2) return(data)
      
      width <- self$width
      offset <- width / groups
      
      # Adjust x positions
      data$x <- data$x + offset * (as.numeric(factor(data$group)) - 1)
      data
    }
  )
)

#' Create Cartesian coordinates
#' @export
#' @param xlim x-axis limits
#' @param ylim y-axis limits
#' @param expand Whether to expand limits
coord_cartesian <- function(xlim = NULL, ylim = NULL, expand = TRUE) {
  CoordCartesian$new(xlim = xlim, ylim = ylim, expand = expand)
}

#' Create polar coordinates
#' @export
#' @param theta Variable to map to angle
#' @param start Starting angle
#' @param direction Direction of rotation
coord_polar <- function(theta = "x", start = 0, direction = 1) {
  CoordPolar$new(theta = theta, start = start, direction = direction)
}

#' Create log coordinates
#' @export
#' @param base Base of logarithm
coord_log <- function(base = exp(1)) {
  CoordLog$new(base = base)
}

#' Create stack position adjustment
#' @export
position_stack <- function() {
  PositionStack$new()
}

#' Create dodge position adjustment
#' @export
#' @param width Width of dodging
position_dodge <- function(width = 0.75) {
  PositionDodge$new(width = width)
}