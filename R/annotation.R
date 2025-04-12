#' @title Annotation Class
#' @description Base class for all annotations
#' @export
Annotation <- R6::R6Class("Annotation",
  public = list(
    #' @description Initialize annotation
    initialize = function() {},
    
    #' @description Render annotation
    #' @param viewport The current viewport
    render = function(viewport) {
      stop("render method must be implemented by subclasses")
    }
  )
)

#' @title Text Annotation
#' @description Add text labels to the plot
#' @export
AnnotationText <- R6::R6Class("AnnotationText",
  inherit = Annotation,
  public = list(
    x = NULL,
    y = NULL,
    label = NULL,
    color = "black",
    size = 10,
    angle = 0,
    
    #' @description Initialize text annotation
    #' @param x x coordinate
    #' @param y y coordinate
    #' @param label Text to display
    #' @param color Text color
    #' @param size Text size
    #' @param angle Rotation angle in degrees
    initialize = function(x, y, label, color = "black", size = 10, angle = 0) {
      self$x <- x
      self$y <- y
      self$label <- label
      self$color <- color
      self$size <- size
      self$angle <- angle
    },
    
    #' @description Render text annotation
    #' @param viewport The current viewport
    render = function(viewport) {
      grid::grid.text(
        self$label,
        x = unit(self$x, "native"),
        y = unit(self$y, "native"),
        gp = grid::gpar(
          col = self$color,
          fontsize = self$size
        ),
        rot = self$angle
      )
    }
  )
)

#' @title Arrow Annotation
#' @description Add arrows to the plot
#' @export
AnnotationArrow <- R6::R6Class("AnnotationArrow",
  inherit = Annotation,
  public = list(
    x0 = NULL,
    y0 = NULL,
    x1 = NULL,
    y1 = NULL,
    color = "black",
    size = 1,
    arrow_size = 0.1,
    
    #' @description Initialize arrow annotation
    #' @param x0 Start x coordinate
    #' @param y0 Start y coordinate
    #' @param x1 End x coordinate
    #' @param y1 End y coordinate
    #' @param color Arrow color
    #' @param size Line size
    #' @param arrow_size Size of arrow head
    initialize = function(x0, y0, x1, y1, color = "black", size = 1, arrow_size = 0.1) {
      self$x0 <- x0
      self$y0 <- y0
      self$x1 <- x1
      self$y1 <- y1
      self$color <- color
      self$size <- size
      self$arrow_size <- arrow_size
    },
    
    #' @description Render arrow annotation
    #' @param viewport The current viewport
    render = function(viewport) {
      grid::grid.segments(
        x0 = unit(self$x0, "native"),
        y0 = unit(self$y0, "native"),
        x1 = unit(self$x1, "native"),
        y1 = unit(self$y1, "native"),
        arrow = grid::arrow(
          length = unit(self$arrow_size, "inches"),
          type = "closed"
        ),
        gp = grid::gpar(
          col = self$color,
          lwd = self$size
        )
      )
    }
  )
)

#' @title Reference Line Annotation
#' @description Add reference lines to the plot
#' @export
AnnotationReferenceLine <- R6::R6Class("AnnotationReferenceLine",
  inherit = Annotation,
  public = list(
    value = NULL,
    orientation = "h",
    color = "gray50",
    size = 1,
    linetype = "dashed",
    
    #' @description Initialize reference line annotation
    #' @param value Position of the line
    #' @param orientation "h" for horizontal or "v" for vertical
    #' @param color Line color
    #' @param size Line size
    #' @param linetype Line type ("solid", "dashed", "dotted", etc.)
    initialize = function(value, orientation = "h", color = "gray50", 
                        size = 1, linetype = "dashed") {
      self$value <- value
      self$orientation <- orientation
      self$color <- color
      self$size <- size
      self$linetype <- linetype
    },
    
    #' @description Render reference line annotation
    #' @param viewport The current viewport
    render = function(viewport) {
      if (self$orientation == "h") {
        grid::grid.lines(
          y = unit(self$value, "native"),
          gp = grid::gpar(
            col = self$color,
            lwd = self$size,
            lty = self$linetype
          )
        )
      } else {
        grid::grid.lines(
          x = unit(self$value, "native"),
          gp = grid::gpar(
            col = self$color,
            lwd = self$size,
            lty = self$linetype
          )
        )
      }
    }
  )
)

#' Create a text annotation
#' @export
#' @param x x coordinate
#' @param y y coordinate
#' @param label Text to display
#' @param color Text color
#' @param size Text size
#' @param angle Rotation angle in degrees
annotate_text <- function(x, y, label, color = "black", size = 10, angle = 0) {
  AnnotationText$new(x, y, label, color, size, angle)
}

#' Create an arrow annotation
#' @export
#' @param x0 Start x coordinate
#' @param y0 Start y coordinate
#' @param x1 End x coordinate
#' @param y1 End y coordinate
#' @param color Arrow color
#' @param size Line size
#' @param arrow_size Size of arrow head
annotate_arrow <- function(x0, y0, x1, y1, color = "black", size = 1, arrow_size = 0.1) {
  AnnotationArrow$new(x0, y0, x1, y1, color, size, arrow_size)
}

#' Create a reference line annotation
#' @export
#' @param value Position of the line
#' @param orientation "h" for horizontal or "v" for vertical
#' @param color Line color
#' @param size Line size
#' @param linetype Line type
annotate_reference_line <- function(value, orientation = "h", color = "gray50",
                                  size = 1, linetype = "dashed") {
  AnnotationReferenceLine$new(value, orientation, color, size, linetype)
}