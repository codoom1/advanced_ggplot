#' @title Facet Class
#' @description Base class for faceting
#' @export
Facet <- R6::R6Class("Facet",
  public = list(
    rows = NULL,
    cols = NULL,
    scales = "fixed",
    
    #' @description Initialize faceting
    #' @param rows Variable(s) to use for row facets
    #' @param cols Variable(s) to use for column facets
    #' @param scales Scale handling ("fixed", "free", "free_x", "free_y")
    initialize = function(rows = NULL, cols = NULL, scales = "fixed") {
      self$rows <- rows
      self$cols <- cols
      self$scales <- scales
    },
    
    #' @description Split data into facets
    #' @param data Data frame to split
    split_data = function(data) {
      # Get unique combinations of faceting variables
      row_vals <- if (!is.null(self$rows)) unique(data[[self$rows]]) else NULL
      col_vals <- if (!is.null(self$cols)) unique(data[[self$cols]]) else NULL
      
      # Create list of data frames for each facet
      facets <- list()
      if (is.null(row_vals) && is.null(col_vals)) {
        facets[[1]] <- list(data = data, row = 1, col = 1)
      } else {
        for (i in seq_along(row_vals %||% 1)) {
          for (j in seq_along(col_vals %||% 1)) {
            subset <- data
            if (!is.null(row_vals)) {
              subset <- subset[subset[[self$rows]] == row_vals[i],]
            }
            if (!is.null(col_vals)) {
              subset <- subset[subset[[self$cols]] == col_vals[j],]
            }
            
            facets[[length(facets) + 1]] <- list(
              data = subset,
              row = i,
              col = j,
              row_val = row_vals[i],
              col_val = col_vals[j]
            )
          }
        }
      }
      
      facets
    },
    
    #' @description Calculate layout dimensions
    get_dimensions = function(data) {
      rows <- if (!is.null(self$rows)) length(unique(data[[self$rows]])) else 1
      cols <- if (!is.null(self$cols)) length(unique(data[[self$cols]])) else 1
      list(rows = rows, cols = cols)
    },
    
    #' @description Generate scales for each facet
    #' @param data List of faceted data
    #' @param original_scales Original plot scales
    generate_scales = function(data, original_scales) {
      if (self$scales == "fixed") {
        return(lapply(data, function(d) original_scales))
      }
      
      scales <- list()
      for (facet in data) {
        facet_scales <- list()
        for (scale in original_scales) {
          if (self$scales == "free" ||
              (self$scales == "free_x" && scale$aesthetic %in% c("x", "xmin", "xmax")) ||
              (self$scales == "free_y" && scale$aesthetic %in% c("y", "ymin", "ymax"))) {
            # Create new scale with limits based on facet data
            new_scale <- scale$clone()
            new_scale$train(facet$data)
            facet_scales[[length(facet_scales) + 1]] <- new_scale
          } else {
            facet_scales[[length(facet_scales) + 1]] <- scale
          }
        }
        scales[[length(scales) + 1]] <- facet_scales
      }
      
      scales
    }
  )
)

#' @title Grid Facet Class
#' @description Create grid-based faceting
#' @export
FacetGrid <- R6::R6Class("FacetGrid",
  inherit = Facet,
  public = list(
    #' @description Render faceted plot
    #' @param plot Plot object to facet
    #' @param data Data frame containing the data
    render = function(plot, data) {
      # Split data into facets
      facets <- self$split_data(data)
      dims <- self$get_dimensions(data)
      
      # Create scales for each facet
      facet_scales <- self$generate_scales(
        facets,
        plot$scales
      )
      
      # Create layout viewport
      grid::pushViewport(grid::viewport(
        layout = grid::grid.layout(
          nrow = dims$rows,
          ncol = dims$cols
        )
      ))
      
      # Render each facet
      for (i in seq_along(facets)) {
        facet <- facets[[i]]
        
        # Create viewport for this facet
        grid::pushViewport(grid::viewport(
          layout.pos.row = facet$row,
          layout.pos.col = facet$col
        ))
        
        # Create facet label
        if (!is.null(facet$row_val) || !is.null(facet$col_val)) {
          label <- paste(
            if (!is.null(facet$row_val)) paste(self$rows, "=", facet$row_val),
            if (!is.null(facet$col_val)) paste(self$cols, "=", facet$col_val),
            sep = ", "
          )
          
          grid::grid.text(
            label,
            x = 0.5,
            y = 0.95,
            just = "center",
            gp = grid::gpar(fontsize = 10)
          )
        }
        
        # Render plot layers with faceted data
        for (layer in plot$layers) {
          layer$render(facet$data)
        }
        
        grid::upViewport()
      }
      
      grid::upViewport()
    }
  )
)

#' @title Wrap Facet Class
#' @description Create wrapped faceting
#' @export
FacetWrap <- R6::R6Class("FacetWrap",
  inherit = Facet,
  public = list(
    ncol = NULL,
    nrow = NULL,
    
    #' @description Initialize wrapped faceting
    #' @param facets Variable(s) to facet by
    #' @param ncol Number of columns
    #' @param nrow Number of rows
    #' @param scales Scale handling
    initialize = function(facets, ncol = NULL, nrow = NULL, scales = "fixed") {
      super$initialize(facets, NULL, scales)
      self$ncol <- ncol
      self$nrow <- nrow
    },
    
    #' @description Calculate layout dimensions
    get_dimensions = function(data) {
      n <- length(unique(data[[self$rows]]))
      
      if (is.null(self$ncol) && is.null(self$nrow)) {
        nc <- ceiling(sqrt(n))
        nr <- ceiling(n / nc)
      } else if (is.null(self$ncol)) {
        nr <- self$nrow
        nc <- ceiling(n / nr)
      } else if (is.null(self$nrow)) {
        nc <- self$ncol
        nr <- ceiling(n / nc)
      } else {
        nr <- self$nrow
        nc <- self$ncol
      }
      
      list(rows = nr, cols = nc)
    }
  )
)

#' Create a grid faceting specification
#' @export
#' @param rows Variable(s) for row facets
#' @param cols Variable(s) for column facets
#' @param scales Scale handling
facet_grid <- function(rows = NULL, cols = NULL, scales = "fixed") {
  FacetGrid$new(rows = rows, cols = cols, scales = scales)
}

#' Create a wrapped faceting specification
#' @export
#' @param facets Variable(s) to facet by
#' @param ncol Number of columns
#' @param nrow Number of rows
#' @param scales Scale handling
facet_wrap <- function(facets, ncol = NULL, nrow = NULL, scales = "fixed") {
  FacetWrap$new(facets = facets, ncol = ncol, nrow = nrow, scales = scales)
}