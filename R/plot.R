#' @title AGPlot Class
#' @description The main plot class that handles all visualizations
#' @export
AGPlot <- R6::R6Class("AGPlot",
  public = list(
    data = NULL,
    layers = list(),
    scales = list(),
    theme = NULL,
    facet = NULL,
    legends = list(),
    coord = NULL,  # Add coordinate system support
    annotations = list(),  # Add annotations support
    
    #' @description Create a new plot object
    #' @param data A data frame containing the data to plot
    initialize = function(data = NULL) {
      self$data <- data
      self$theme <- theme_minimal()  # Set default theme
      # Make sure all imports are used
      ensure_imports()
    },
    
    #' @description Add a new layer to the plot
    #' @param layer A layer object to add to the plot
    add_layer = function(layer) {
      self$layers[[length(self$layers) + 1]] <- layer
      invisible(self)
    },
    
    #' @description Add a scale to the plot
    #' @param scale A scale object to add to the plot
    add_scale = function(scale) {
      self$scales[[scale$aesthetic]] <- scale
      invisible(self)
    },
    
    #' @description Set the theme for the plot
    #' @param theme A theme object
    set_theme = function(theme) {
      self$theme <- theme
      invisible(self)
    },
    
    #' @description Set the faceting specification for the plot
    #' @param facet A facet object
    set_facet = function(facet) {
      self$facet <- facet
      invisible(self)
    },
    
    #' @description Set the coordinate system for the plot
    #' @param coord A coordinate system object
    set_coord = function(coord) {
      self$coord <- coord
      invisible(self)
    },
    
    #' @description Add an annotation to the plot
    #' @param annotation An annotation object
    add_annotation = function(annotation) {
      self$annotations[[length(self$annotations) + 1]] <- annotation
      invisible(self)
    },
    
    #' @description Calculate plot ranges from data and layers
    compute_ranges = function() {
      ranges <- list()
      for (layer in self$layers) {
        aes <- layer$eval_aes(self$data)
        for (name in names(aes)) {
          if (is.null(ranges[[name]])) {
            ranges[[name]] <- range(aes[[name]], na.rm = TRUE)
          } else {
            ranges[[name]] <- range(c(ranges[[name]], aes[[name]]), na.rm = TRUE)
          }
        }
      }
      ranges
    },
    
    #' @description Collect legends from layers
    collect_legends = function() {
      # Clear existing legends
      self$legends <- list()
      
      # Collect unique aesthetics and their values
      for (layer in self$layers) {
        aes <- layer$eval_aes(self$data)
        for (name in names(aes)) {
          if (name %in% c("color", "fill")) {
            values <- unique(aes[[name]])
            if (length(values) > 1) {  # Only create legend if we have multiple values
              self$legends[[name]] <- create_legend(
                aesthetic = name,
                values = values
              )
            }
          }
        }
      }
    },
    
    #' @description Render the plot
    plot = function() {
      # Collect legends before plotting
      self$collect_legends()
      
      # If we have facets, let the facet system handle the rendering
      if (!is.null(self$facet)) {
        self$facet$render(self, self$data)
        return(invisible(self))
      }
      
      # Set up the plotting region
      grid::pushViewport(grid::viewport(
        width = grid::unit(1, "npc"), 
        height = grid::unit(1, "npc"),
        xscale = c(0, 1),
        yscale = c(0, 1)
      ))
      
      # Apply theme
      self$theme$apply()
      
      # Calculate data ranges
      ranges <- self$compute_ranges()
      
      # Create viewport based on coordinate system
      if (!is.null(self$coord)) {
        vp <- self$coord$setup_viewport(ranges$x, ranges$y)
      } else {
        vp <- grid::viewport(
          width = grid::unit(0.8, "npc"),
          height = grid::unit(0.8, "npc"),
          xscale = ranges$x,
          yscale = ranges$y
        )
      }
      grid::pushViewport(vp)
      
      # Plot each layer with coordinate transformation
      for (layer in self$layers) {
        aes <- layer$eval_aes(self$data)
        if (!is.null(self$coord)) {
          transformed <- self$coord$transform(aes$x, aes$y)
          aes$x <- transformed$x
          aes$y <- transformed$y
        }
        layer$render(aes)
      }
      
      # Render axes if scales exist
      for (aesthetic in names(self$scales)) {
        self$scales[[aesthetic]]$render_axis()
      }
      
      grid::popViewport()
      
      # Render annotations
      if (length(self$annotations) > 0) {
        for (annotation in self$annotations) {
          annotation$render(grid::current.viewport())
        }
      }
      
      # Render legends
      for (legend in self$legends) {
        legend$render()
      }
      
      grid::popViewport()
    }
  )
)

#' @title Plot Class (Legacy)
#' @description The main plot class that handles all visualizations (deprecated, use AGPlot instead)
#' @export
Plot <- R6::R6Class("Plot", inherit = AGPlot)