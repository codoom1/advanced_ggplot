#' @title Animation Class
#' @description Base class for animations
#' @export
Animation <- R6::R6Class("Animation",
  public = list(
    duration = 1000,
    easing = "linear",
    delay = 0,
    
    #' @description Initialize animation
    #' @param duration Duration in milliseconds
    #' @param easing Easing function name
    #' @param delay Delay before start in milliseconds
    initialize = function(duration = 1000, easing = "linear", delay = 0) {
      self$duration <- duration
      self$easing <- easing
      self$delay <- delay
    },
    
    #' @description Generate animation frames
    #' @param data Data frame to animate
    #' @param n_frames Number of frames
    generate_frames = function(data, n_frames = 30) {
      stop("Abstract method")
    }
  )
)

#' @title Transition Animation
#' @description Animate transitions between states
#' @export
TransitionAnimation <- R6::R6Class("TransitionAnimation",
  inherit = Animation,
  public = list(
    states = NULL,
    
    #' @description Initialize transition animation
    #' @param states List of data frames representing states
    #' @param duration Duration in milliseconds
    #' @param easing Easing function name
    initialize = function(states, duration = 1000, easing = "linear") {
      super$initialize(duration = duration, easing = easing)
      self$states <- states
    },
    
    #' @description Generate transition frames
    #' @param data Initial data frame
    #' @param n_frames Number of frames
    generate_frames = function(data, n_frames = 30) {
      frames <- list()
      n_states <- length(self$states)
      
      for (i in 1:(n_states - 1)) {
        start_state <- if (i == 1) data else self$states[[i - 1]]
        end_state <- self$states[[i]]
        
        # Generate intermediate frames
        for (j in 1:n_frames) {
          alpha <- j / n_frames
          frame <- self$interpolate(start_state, end_state, alpha)
          frames[[length(frames) + 1]] <- frame
        }
      }
      
      frames
    },
    
    #' @description Interpolate between states
    #' @param start_state Starting state
    #' @param end_state Ending state
    #' @param alpha Interpolation parameter
    interpolate = function(start_state, end_state, alpha) {
      # Interpolate numeric columns
      result <- start_state
      for (col in names(start_state)) {
        if (is.numeric(start_state[[col]])) {
          result[[col]] <- start_state[[col]] * (1 - alpha) + 
                          end_state[[col]] * alpha
        }
      }
      result
    }
  )
)

#' @title Time Series Animation
#' @description Animate time series data
#' @export
TimeSeriesAnimation <- R6::R6Class("TimeSeriesAnimation",
  inherit = Animation,
  public = list(
    time_column = NULL,
    window_size = NULL,
    
    #' @description Initialize time series animation
    #' @param time_column Name of time column
    #' @param window_size Size of moving window
    #' @param duration Duration in milliseconds
    initialize = function(time_column, window_size = NULL, duration = 1000) {
      super$initialize(duration = duration)
      self$time_column <- time_column
      self$window_size <- window_size
    },
    
    #' @description Generate time series frames
    #' @param data Data frame containing time series
    #' @param n_frames Number of frames
    generate_frames = function(data, n_frames = 30) {
      frames <- list()
      times <- unique(data[[self$time_column]])
      n_times <- length(times)
      
      if (is.null(self$window_size)) {
        # Accumulating animation
        for (i in 1:n_times) {
          subset <- data[data[[self$time_column]] <= times[i], ]
          frames[[i]] <- subset
        }
      } else {
        # Moving window animation
        window <- self$window_size
        for (i in window:n_times) {
          subset <- data[data[[self$time_column]] >= times[i - window + 1] &
                        data[[self$time_column]] <= times[i], ]
          frames[[i - window + 1]] <- subset
        }
      }
      
      frames
    }
  )
)

#' Create a transition animation
#' @export
#' @param states List of data frames representing states
#' @param duration Duration in milliseconds
#' @param easing Easing function name
animate_transition <- function(states, duration = 1000, easing = "linear") {
  TransitionAnimation$new(
    states = states,
    duration = duration,
    easing = easing
  )
}

#' Create a time series animation
#' @export
#' @param time_column Name of time column
#' @param window_size Size of moving window
#' @param duration Duration in milliseconds
animate_time_series <- function(time_column, window_size = NULL, duration = 1000) {
  TimeSeriesAnimation$new(
    time_column = time_column,
    window_size = window_size,
    duration = duration
  )
}