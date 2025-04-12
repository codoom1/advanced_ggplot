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
      row_vals <- if (!is.null(self$rows)) {
        if (length(self$rows) > 1) {
          # For multiple variables, create a combination column
          data$.facet_row <- apply(data[, self$rows, drop = FALSE], 1, paste, collapse = "_")
          unique(data$.facet_row)
        } else {
          unique(data[[self$rows]])
        }
      } else NULL
      
      col_vals <- if (!is.null(self$cols)) {
        if (length(self$cols) > 1) {
          # For multiple variables, create a combination column
          data$.facet_col <- apply(data[, self$cols, drop = FALSE], 1, paste, collapse = "_")
          unique(data$.facet_col)
        } else {
          unique(data[[self$cols]])
        }
      } else NULL
      
      # Create list of data frames for each facet
      facets <- list()
      if (is.null(row_vals) && is.null(col_vals)) {
        facets[["1"]] <- data
        return(facets)
      } 
      
      # Handle single variable faceting for rows
      if (!is.null(row_vals) && is.null(col_vals)) {
        for (val in row_vals) {
          if (length(self$rows) > 1) {
            subset <- data[data$.facet_row == val, ]
          } else {
            subset <- data[data[[self$rows]] == val, ]
          }
          facets[[as.character(val)]] <- subset
        }
        return(facets)
      }
      
      # Handle single variable faceting for cols
      if (is.null(row_vals) && !is.null(col_vals)) {
        for (val in col_vals) {
          if (length(self$cols) > 1) {
            subset <- data[data$.facet_col == val, ]
          } else {
            subset <- data[data[[self$cols]] == val, ]
          }
          facets[[as.character(val)]] <- subset
        }
        return(facets)
      }
      
      # Handle faceting by both row and column
      if (!is.null(row_vals) && !is.null(col_vals)) {
        for (r_val in row_vals) {
          for (c_val in col_vals) {
            if (length(self$rows) > 1 && length(self$cols) > 1) {
              subset <- data[data$.facet_row == r_val & data$.facet_col == c_val, ]
            } else if (length(self$rows) > 1) {
              subset <- data[data$.facet_row == r_val & data[[self$cols]] == c_val, ]
            } else if (length(self$cols) > 1) {
              subset <- data[data[[self$rows]] == r_val & data$.facet_col == c_val, ]
            } else {
              subset <- data[data[[self$rows]] == r_val & data[[self$cols]] == c_val, ]
            }
            key <- paste(r_val, c_val, sep = "_")
            facets[[key]] <- subset
          }
        }
      }
      
      return(facets)
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
      facet_names <- names(facets)
      
      # Create layout viewport
      grid::pushViewport(grid::viewport(
        layout = grid::grid.layout(
          nrow = dims$rows,
          ncol = dims$cols
        )
      ))
      
      # Render each facet
      i <- 1
      for (facet_name in facet_names) {
        facet_data <- facets[[facet_name]]
        
        # Position facets in a grid
        row_pos <- (i - 1) %/% dims$cols + 1
        col_pos <- (i - 1) %% dims$cols + 1
        
        # Create viewport for this facet
        grid::pushViewport(grid::viewport(
          layout.pos.row = row_pos,
          layout.pos.col = col_pos
        ))
        
        # Create facet label
        if (facet_name != "1") {
          grid::grid.text(
            facet_name,
            x = 0.5,
            y = 0.95,
            just = "center",
            gp = grid::gpar(fontsize = 10)
          )
        }
        
        # Render plot layers with faceted data
        for (layer in plot$layers) {
          layer$render(facet_data)
        }
        
        grid::popViewport()
        i <- i + 1
      }
      
      grid::popViewport()
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