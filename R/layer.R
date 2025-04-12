#' @title Layer Class
#' @description Base class for all layer types
#' @export
Layer <- R6::R6Class("Layer",
  public = list(
    mapping = NULL,
    stat = NULL,
    position = NULL,  # Add position adjustment support
    
    #' @description Initialize a new layer
    #' @param mapping Aesthetic mappings
    #' @param stat Statistical transformation to apply
    #' @param position Position adjustment to apply
    initialize = function(mapping = NULL, stat = NULL, position = NULL) {
      self$mapping <- mapping
      self$stat <- stat
      self$position <- position
    },
    
    #' @description Evaluate aesthetics for the layer
    #' @param data The data to evaluate aesthetics for
    eval_aes = function(data) {
      # First apply statistical transformation if present
      if (!is.null(self$stat)) {
        data <- self$stat$transform(data, self$mapping)
      }
      
      # Convert mapping to actual values
      aes <- if (is.null(self$mapping)) list() else {
        lapply(self$mapping, function(x) eval(parse(text = x), data))
      }
      
      # Convert to data frame for position adjustment
      df <- as.data.frame(aes)
      
      # Apply position adjustment if present
      if (!is.null(self$position)) {
        df <- self$position$adjust(df)
      }
      
      # Convert back to list
      as.list(df)
    },
    
    #' @description Render the layer (to be implemented by subclasses)
    #' @param data The data to render
    render = function(data) {
      stop("Render method must be implemented by subclasses")
    }
  )
)