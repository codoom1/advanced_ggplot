#' @title Violin Plot Geometry
#' @description Create a violin plot layer for visualizing distributions
#' @export
GeomViolin <- R6::R6Class("GeomViolin",
  inherit = Layer,
  public = list(
    #' @description Render violin plots on the plot
    #' @param data The data frame containing the points to plot
    render = function(data) {
      aes <- self$eval_aes(data)
      x <- aes$x %||% data$x
      y <- aes$y %||% data$y
      group <- aes$group %||% x
      color <- aes$color %||% "black"
      fill <- aes$fill %||% "white"
      alpha <- aes$alpha %||% 1
      width <- aes$width %||% 0.8
      scale <- aes$scale %||% "area"
      
      # Process data through StatDensity if not done already
      if (is.null(self$stat)) {
        self$stat <- StatViolin$new()
      }
      
      # Convert input data to stats data format
      stats_data <- data.frame(x = x, y = y, group = group)
      violin_stats <- self$stat$compute(stats_data, scale = scale, width = width)
      
      # Extract unique groups to plot
      unique_groups <- unique(violin_stats$group)
      
      for (g in unique_groups) {
        group_data <- violin_stats[violin_stats$group == g, ]
        x_pos <- unique(group_data$x)
        
        # Left side of violin
        left_x <- x_pos - group_data$density
        left_y <- group_data$y
        
        # Right side of violin
        right_x <- x_pos + group_data$density
        right_y <- rev(group_data$y)
        
        # Combine to get the complete violin shape
        polygon_x <- c(left_x, right_x)
        polygon_y <- c(left_y, right_y)
        
        # Draw the violin shape
        grid::grid.polygon(
          x = polygon_x,
          y = polygon_y,
          gp = grid::gpar(
            fill = fill,
            col = color,
            alpha = alpha
          ),
          default.units = "native"
        )
      }
    }
  )
)

#' @title Violin Plot Statistics
#' @description Statistical transformation for violin plot density calculations
#' @export
StatViolin <- R6::R6Class("StatViolin",
  inherit = Stat,
  public = list(
    compute = function(data, scale = "area", width = 0.8) {
      if (is.null(data$y)) stop("StatViolin requires y aesthetic")
      
      # Process each group separately
      groups <- unique(data$group)
      result <- data.frame()
      
      for (g in groups) {
        group_data <- data[data$group == g, ]
        x_val <- unique(group_data$x)
        y_vals <- group_data$y
        
        # Calculate density
        d <- stats::density(y_vals, adjust = 1, cut = 0)
        
        # Scale the density
        if (scale == "area") {
          # Scale so that the total area = 1
          total_area <- sum(diff(d$x) * (d$y[-1] + d$y[-length(d$y)]) / 2)
          scale_factor <- 1 / total_area
        } else if (scale == "count") {
          # Scale by count
          scale_factor <- length(y_vals)
        } else if (scale == "width") {
          # Scale to have same max width
          scale_factor <- 1
        } else {
          scale_factor <- 1
        }
        
        # Apply the scaling factor
        scaled_density <- d$y * scale_factor * (width / 2)
        
        # Create data frame with violin statistics
        group_result <- data.frame(
          x = x_val,
          y = d$x,
          density = scaled_density,
          scaled = scaled_density,
          group = g
        )
        
        result <- rbind(result, group_result)
      }
      
      return(result)
    }
  )
)

#' Create a violin plot layer
#' @export
#' @param mapping Aesthetic mappings
#' @param width Width of the violin plot relative to the category width
#' @param scale How to scale the violins: "area", "count", or "width"
geom_violin <- function(mapping = NULL, width = 0.8, scale = "area") {
  if (!is.null(mapping)) {
    if (is.null(mapping$width)) mapping$width <- width
    if (is.null(mapping$scale)) mapping$scale <- scale
  }
  
  GeomViolin$new(
    mapping = mapping,
    stat = StatViolin$new()
  )
} 