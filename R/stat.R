#' @title Statistical Transformation Base Class
#' @description Base class for all statistical transformations
#' @export
Stat <- R6::R6Class("Stat",
  public = list(
    params = NULL,
    
    #' @description Initialize a new statistical transformation
    #' @param params Parameters for the transformation
    initialize = function(params = list()) {
      self$params <- params
    },
    
    #' @description Compute the statistical transformation
    #' @param data Input data frame
    compute = function(data) {
      stop("Stat$compute() must be implemented by subclasses")
    }
  )
)

#' @export
StatDensity <- R6::R6Class("StatDensity",
  inherit = Stat,
  public = list(
    compute = function(data) {
      if (is.null(data$x)) stop("StatDensity requires x aesthetic")
      dens <- stats::density(
        data$x,
        kernel = self$params$kernel,
        bw = self$params$bw
      )
      data.frame(
        x = dens$x,
        y = dens$y
      )
    }
  )
)

#' @export
StatBin <- R6::R6Class("StatBin",
  inherit = Stat,
  public = list(
    compute = function(data) {
      if (is.null(data$x)) stop("StatBin requires x aesthetic")
      bins <- self$params$bins %||% ceiling(sqrt(length(data$x)))
      h <- graphics::hist(
        data$x,
        breaks = bins,
        plot = FALSE
      )
      data.frame(
        x = h$mids,
        y = h$counts,
        width = diff(h$breaks)[1]
      )
    }
  )
)

#' @export
StatSmooth <- R6::R6Class("StatSmooth",
  inherit = Stat,
  public = list(
    compute = function(data) {
      if (is.null(data$x) || is.null(data$y)) {
        stop("StatSmooth requires both x and y aesthetics")
      }
      
      if (self$params$method == "loess") {
        fit <- stats::loess(
          y ~ x,
          data = data,
          span = self$params$span
        )
      } else if (self$params$method == "lm") {
        fit <- stats::lm(y ~ x, data = data)
      } else {
        stop("Unknown smoothing method")
      }
      
      new_data <- data.frame(x = seq(min(data$x), max(data$x), length.out = 100))
      pred <- predict(fit, newdata = new_data, se = TRUE)
      
      data.frame(
        x = new_data$x,
        y = pred$fit,
        ymin = pred$fit - 1.96 * pred$se.fit,
        ymax = pred$fit + 1.96 * pred$se.fit
      )
    }
  )
)

# Helper function for NULL coalescing
`%||%` <- function(a, b) if (is.null(a)) b else a