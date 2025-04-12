#' @title Contour Geometry
#' @description Create contour plots
#' @export
GeomContour <- R6::R6Class("GeomContour",
  inherit = Layer,
  public = list(
    bins = 10,
    
    #' @description Initialize contour geometry
    #' @param mapping Aesthetic mappings
    #' @param bins Number of contour levels
    initialize = function(mapping = NULL, bins = 10) {
      super$initialize(mapping)
      self$bins <- bins
    },
    
    #' @description Render contours on the plot
    #' @param data Data frame containing the values to plot
    render = function(data) {
      aes <- self$eval_aes(data)
      x <- aes$x %||% data$x
      y <- aes$y %||% data$y
      z <- aes$z %||% data$z
      color <- aes$color %||% "black"
      size <- aes$size %||% 0.5
      
      # Create regular grid for contours
      x_unique <- sort(unique(x))
      y_unique <- sort(unique(y))
      z_matrix <- matrix(z, nrow = length(x_unique), ncol = length(y_unique))
      
      # Calculate contours using base R contour function
      cont <- grDevices::contourLines(
        x = x_unique,
        y = y_unique,
        z = z_matrix,
        nlevels = self$bins
      )
      
      # Draw each contour line
      for (i in seq_along(cont)) {
        grid::grid.lines(
          x = cont[[i]]$x,
          y = cont[[i]]$y,
          gp = grid::gpar(
            col = color,
            lwd = size,
            lty = aes$linetype %||% "solid"
          )
        )
        
        # Add level labels if specified
        if (!is.null(aes$label)) {
          mid_point <- floor(length(cont[[i]]$x) / 2)
          grid::grid.text(
            label = sprintf("%.2f", cont[[i]]$level),
            x = cont[[i]]$x[mid_point],
            y = cont[[i]]$y[mid_point],
            gp = grid::gpar(
              col = color,
              fontsize = 8
            )
          )
        }
      }
    }
  )
)

#' Create a contour layer
#' @export
#' @param mapping Aesthetic mappings
#' @param bins Number of contour levels
geom_contour <- function(mapping = NULL, bins = 10) {
  GeomContour$new(mapping = mapping, bins = bins)
}

#' @title Filled Contour Geometry
#' @description Create filled contour plots
#' @export
GeomContourFilled <- R6::R6Class("GeomContourFilled",
  inherit = GeomContour,
  public = list(
    #' @description Render filled contours on the plot
    #' @param data Data frame containing the values to plot
    render = function(data) {
      aes <- self$eval_aes(data)
      x <- aes$x %||% data$x
      y <- aes$y %||% data$y
      z <- aes$z %||% data$z
      
      # Create regular grid
      x_unique <- sort(unique(x))
      y_unique <- sort(unique(y))
      z_matrix <- matrix(z, nrow = length(x_unique), ncol = length(y_unique))
      
      # Calculate contours
      cont <- grDevices::contourLines(
        x = x_unique,
        y = y_unique,
        z = z_matrix,
        nlevels = self$bins
      )
      
      # Create color palette for fills
      if (!is.null(aes$fill)) {
        colors <- aes$fill
      } else {
        colors <- grDevices::colorRampPalette(c("white", "steelblue"))(self$bins)
      }
      
      # Draw filled regions
      for (i in seq_along(cont)) {
        grid::grid.polygon(
          x = cont[[i]]$x,
          y = cont[[i]]$y,
          gp = grid::gpar(
            fill = colors[i],
            col = NA,
            alpha = aes$alpha %||% 0.6
          )
        )
      }
      
      # Add contour lines if specified
      if (!is.null(aes$color)) {
        for (i in seq_along(cont)) {
          grid::grid.lines(
            x = cont[[i]]$x,
            y = cont[[i]]$y,
            gp = grid::gpar(
              col = aes$color,
              lwd = aes$size %||% 0.5
            )
          )
        }
      }
    }
  )
)

#' Create a filled contour layer
#' @export
#' @param mapping Aesthetic mappings
#' @param bins Number of contour levels
geom_contour_filled <- function(mapping = NULL, bins = 10) {
  GeomContourFilled$new(mapping = mapping, bins = bins)
}