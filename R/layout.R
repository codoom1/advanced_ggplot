#' @title Layout Class
#' @description Manages plot layouts and arrangements
#' @export
Layout <- R6::R6Class("Layout",
  public = list(
    plots = list(),
    ncol = NULL,
    nrow = NULL,
    widths = NULL,
    heights = NULL,
    
    #' @description Initialize layout
    #' @param ncol Number of columns
    #' @param nrow Number of rows
    #' @param widths Relative widths of columns
    #' @param heights Relative heights of rows
    initialize = function(ncol = NULL, nrow = NULL, widths = NULL, heights = NULL) {
      self$ncol <- ncol
      self$nrow <- nrow
      self$widths <- widths
      self$heights <- heights
    },
    
    #' @description Add a plot to the layout
    #' @param plot Plot object to add
    add_plot = function(plot) {
      self$plots[[length(self$plots) + 1]] <- plot
      invisible(self)
    },
    
    #' @description Calculate optimal grid layout
    calculate_grid = function() {
      n <- length(self$plots)
      if (is.null(self$ncol) && is.null(self$nrow)) {
        # Calculate optimal layout
        self$ncol <- ceiling(sqrt(n))
        self$nrow <- ceiling(n / self$ncol)
      } else if (is.null(self$ncol)) {
        self$ncol <- ceiling(n / self$nrow)
      } else if (is.null(self$nrow)) {
        self$nrow <- ceiling(n / self$ncol)
      }
      
      # Set default widths and heights if not specified
      if (is.null(self$widths)) {
        self$widths <- rep(1, self$ncol)
      }
      if (is.null(self$heights)) {
        self$heights <- rep(1, self$nrow)
      }
    },
    
    #' @description Render all plots in layout
    render = function() {
      self$calculate_grid()
      
      # Create viewport for layout
      grid::pushViewport(grid::viewport(
        layout = grid::grid.layout(
          nrow = self$nrow,
          ncol = self$ncol,
          widths = self$widths,
          heights = self$heights
        )
      ))
      
      # Plot each subplot in its position
      for (i in seq_along(self$plots)) {
        row <- ceiling(i / self$ncol)
        col <- ((i - 1) %% self$ncol) + 1
        
        grid::pushViewport(grid::viewport(
          layout.pos.row = row,
          layout.pos.col = col
        ))
        
        self$plots[[i]]$plot()
        grid::upViewport()
      }
      
      grid::upViewport()
    }
  )
)

#' Create a new layout
#' @export
#' @param ... Plots to arrange
#' @param ncol Number of columns
#' @param nrow Number of rows
#' @param widths Relative widths of columns
#' @param heights Relative heights of rows
arrange_plots <- function(..., ncol = NULL, nrow = NULL, widths = NULL, heights = NULL) {
  plots <- list(...)
  layout <- Layout$new(ncol = ncol, nrow = nrow, widths = widths, heights = heights)
  for (plot in plots) {
    layout$add_plot(plot)
  }
  layout
}

#' @title Plot Grid Class
#' @description Create a regular grid of plots
#' @export
PlotGrid <- R6::R6Class("PlotGrid",
  inherit = Layout,
  public = list(
    #' @description Initialize plot grid
    #' @param plots List of plots
    #' @param ncol Number of columns
    initialize = function(plots, ncol = NULL) {
      super$initialize(ncol = ncol)
      for (plot in plots) {
        self$add_plot(plot)
      }
    },
    
    #' @description Add shared legend for all plots
    #' @param position Position of legend ("right", "bottom")
    add_shared_legend = function(position = "right") {
      # Collect unique aesthetics from all plots
      aesthetics <- list()
      for (plot in self$plots) {
        for (layer in plot$layers) {
          aes <- layer$eval_aes(plot$data)
          for (name in names(aes)) {
            if (name %in% c("color", "fill")) {
              aesthetics[[name]] <- unique(c(aesthetics[[name]], aes[[name]]))
            }
          }
        }
      }
      
      # Create legend viewport
      if (position == "right") {
        self$widths <- unit.c(unit(rep(1, self$ncol)), unit(0.2, "npc"))
      } else {
        self$heights <- unit.c(unit(rep(1, self$nrow)), unit(0.2, "npc"))
      }
      
      invisible(self)
    }
  )
)

#' Create a grid of plots
#' @export
#' @param plots List of plots
#' @param ncol Number of columns
#' @param shared_legend Whether to add shared legend
#' @param legend_position Position of shared legend
plot_grid <- function(plots, ncol = NULL, shared_legend = FALSE, legend_position = "right") {
  grid <- PlotGrid$new(plots, ncol = ncol)
  if (shared_legend) {
    grid$add_shared_legend(position = legend_position)
  }
  grid
}