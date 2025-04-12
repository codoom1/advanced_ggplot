#' @title Boxplot Geometry
#' @description Create a boxplot layer for statistical summaries
#' @export
GeomBoxplot <- R6::R6Class("GeomBoxplot",
  inherit = Layer,
  public = list(
    #' @description Render boxplots on the plot
    #' @param data The data frame containing the points to plot
    render = function(data) {
      aes <- self$eval_aes(data)
      x <- aes$x %||% data$x
      y <- aes$y %||% data$y
      group <- aes$group %||% x
      color <- aes$color %||% "black"
      fill <- aes$fill %||% "white"
      width <- aes$width %||% 0.75
      alpha <- aes$alpha %||% 1
      
      # Process data through StatBoxplot if not done already
      if (is.null(aes$ymin) || is.null(aes$lower) || is.null(aes$middle) || 
          is.null(aes$upper) || is.null(aes$ymax)) {
        if (is.null(self$stat)) {
          self$stat <- StatBoxplot$new()
        }
        stats_data <- data.frame(x = x, y = y, group = group)
        box_stats <- self$stat$compute(stats_data)
        
        # Extract boxplot statistics
        unique_groups <- unique(box_stats$group)
        
        for (g in unique_groups) {
          group_data <- box_stats[box_stats$group == g, ]
          x_pos <- unique(group_data$x)
          
          # Draw the box
          grid::grid.rect(
            x = x_pos,
            y = unit(0.5 * (group_data$lower + group_data$upper), "native"),
            width = unit(width, "native"),
            height = unit(group_data$upper - group_data$lower, "native"),
            gp = grid::gpar(
              col = color,
              fill = fill,
              alpha = alpha
            ),
            default.units = "native"
          )
          
          # Draw the median line
          grid::grid.segments(
            x0 = x_pos - 0.5 * width,
            x1 = x_pos + 0.5 * width,
            y0 = group_data$middle,
            y1 = group_data$middle,
            gp = grid::gpar(col = color, lwd = 2),
            default.units = "native"
          )
          
          # Draw the whiskers
          grid::grid.segments(
            x0 = x_pos,
            x1 = x_pos,
            y0 = group_data$lower,
            y1 = group_data$ymin,
            gp = grid::gpar(col = color),
            default.units = "native"
          )
          
          grid::grid.segments(
            x0 = x_pos,
            x1 = x_pos,
            y0 = group_data$upper,
            y1 = group_data$ymax,
            gp = grid::gpar(col = color),
            default.units = "native"
          )
          
          # Draw horizontal whisker ends
          whisker_width <- width * 0.5
          
          grid::grid.segments(
            x0 = x_pos - whisker_width,
            x1 = x_pos + whisker_width,
            y0 = group_data$ymin,
            y1 = group_data$ymin,
            gp = grid::gpar(col = color),
            default.units = "native"
          )
          
          grid::grid.segments(
            x0 = x_pos - whisker_width,
            x1 = x_pos + whisker_width,
            y0 = group_data$ymax,
            y1 = group_data$ymax,
            gp = grid::gpar(col = color),
            default.units = "native"
          )
          
          # Draw outliers if present
          if (!is.null(group_data$outliers) && length(group_data$outliers) > 0) {
            grid::grid.points(
              x = rep(x_pos, length(group_data$outliers)),
              y = group_data$outliers,
              pch = 19,
              size = unit(0.5, "char"),
              gp = grid::gpar(col = color),
              default.units = "native"
            )
          }
        }
      }
    }
  )
)

#' @title Boxplot Statistics
#' @description Statistical transformation for boxplot calculations
#' @export
StatBoxplot <- R6::R6Class("StatBoxplot",
  inherit = Stat,
  public = list(
    compute = function(data) {
      if (is.null(data$y)) stop("StatBoxplot requires y aesthetic")
      
      # Process each group separately
      groups <- unique(data$group)
      result <- data.frame()
      
      for (g in groups) {
        group_data <- data[data$group == g, ]
        x_val <- unique(group_data$x)
        y_vals <- group_data$y
        
        # Calculate boxplot statistics using the imported function
        bp_stats <- .boxplot.stats(y_vals)
        
        # Create a data frame with boxplot statistics
        # Always provide an outliers list, even if empty
        outliers_list <- list(bp_stats$out)
        if (length(outliers_list[[1]]) == 0) {
          outliers_list <- list(numeric(0))
        }
        
        group_result <- data.frame(
          x = x_val,
          group = g,
          ymin = bp_stats$stats[1],  # lower whisker
          lower = bp_stats$stats[2], # lower hinge (25%)
          middle = bp_stats$stats[3], # median
          upper = bp_stats$stats[4], # upper hinge (75%)
          ymax = bp_stats$stats[5],  # upper whisker
          stringsAsFactors = FALSE
        )
        group_result$outliers <- outliers_list
        
        result <- rbind(result, group_result)
      }
      
      return(result)
    }
  )
)

#' Create a boxplot layer
#' @export
#' @param mapping Aesthetic mappings
#' @param width Width of the boxplot relative to the category width
geom_boxplot <- function(mapping = NULL, width = 0.75) {
  if (!is.null(mapping) && is.null(mapping$width)) {
    mapping$width <- width
  }
  
  GeomBoxplot$new(
    mapping = mapping,
    stat = StatBoxplot$new()
  )
} 