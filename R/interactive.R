#' @title Interactive Plot Class
#' @description Extensions for interactive plot features
#' @export
InteractivePlot <- R6::R6Class("InteractivePlot",
  inherit = Plot,
  public = list(
    tooltips = list(),
    click_handlers = list(),
    zoom_enabled = FALSE,
    pan_enabled = FALSE,
    brush_enabled = FALSE,
    
    #' @description Enable tooltips for a layer
    #' @param layer_id Layer identifier
    #' @param tooltip_func Function to generate tooltip text
    add_tooltip = function(layer_id, tooltip_func) {
      self$tooltips[[layer_id]] <- tooltip_func
      invisible(self)
    },
    
    #' @description Add click handler for a layer
    #' @param layer_id Layer identifier
    #' @param handler_func Function to handle click events
    add_click_handler = function(layer_id, handler_func) {
      self$click_handlers[[layer_id]] <- handler_func
      invisible(self)
    },
    
    #' @description Enable zoom functionality
    #' @param enable Whether to enable zoom
    enable_zoom = function(enable = TRUE) {
      self$zoom_enabled <- enable
      invisible(self)
    },
    
    #' @description Enable pan functionality
    #' @param enable Whether to enable pan
    enable_pan = function(enable = TRUE) {
      self$pan_enabled <- enable
      invisible(self)
    },
    
    #' @description Enable brush selection
    #' @param enable Whether to enable brush selection
    enable_brush = function(enable = TRUE) {
      self$brush_enabled <- enable
      invisible(self)
    },
    
    #' @description Convert plot to HTML widget
    #' @param width Widget width
    #' @param height Widget height
    as_widget = function(width = NULL, height = NULL) {
      if (!requireNamespace("htmlwidgets", quietly = TRUE)) {
        stop("Please install the 'htmlwidgets' package for interactive features")
      }
      
      # Create a list of plot data for JavaScript
      plot_data <- list(
        data = self$data,
        layers = lapply(self$layers, function(layer) {
          list(
            type = class(layer)[1],
            mapping = layer$mapping,
            data = layer$eval_aes(self$data)
          )
        }),
        tooltips = self$tooltips,
        zoom_enabled = self$zoom_enabled,
        pan_enabled = self$pan_enabled,
        brush_enabled = self$brush_enabled
      )
      
      # Create htmlwidget
      htmlwidgets::createWidget(
        name = "vizrInteractive",
        x = plot_data,
        width = width,
        height = height,
        package = "vizr"
      )
    }
  )
)

#' Create an interactive plot
#' @export
#' @param data Data frame containing the data to plot
interactive_plot <- function(data = NULL) {
  InteractivePlot$new(data)
}

#' @title Interactive Layer Class
#' @description Base class for interactive layers
#' @export
InteractiveLayer <- R6::R6Class("InteractiveLayer",
  inherit = Layer,
  public = list(
    interactive = TRUE,
    hover_style = NULL,
    click_style = NULL,
    
    #' @description Set hover style
    #' @param style List of style properties
    set_hover_style = function(style) {
      self$hover_style <- style
      invisible(self)
    },
    
    #' @description Set click style
    #' @param style List of style properties
    set_click_style = function(style) {
      self$click_style <- style
      invisible(self)
    }
  )
)

#' @title Interactive Point Layer
#' @description Interactive scatter plot points
#' @export
InteractivePoint <- R6::R6Class("InteractivePoint",
  inherit = InteractiveLayer,
  public = list(
    #' @description Render interactive points
    render = function(data) {
      # Base rendering code similar to GeomPoint
      # Additional interactive attributes will be handled by JavaScript
    }
  )
)

#' Create an interactive point layer
#' @export
#' @param mapping Aesthetic mappings
#' @param hover_style Style to apply on hover
#' @param click_style Style to apply on click
interactive_point <- function(mapping = NULL, hover_style = NULL, click_style = NULL) {
  layer <- InteractivePoint$new(mapping = mapping)
  if (!is.null(hover_style)) layer$set_hover_style(hover_style)
  if (!is.null(click_style)) layer$set_click_style(click_style)
  layer
}