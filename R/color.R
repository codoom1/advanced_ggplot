#' @title Color Palette Class
#' @description Handles color generation and palette management
#' @export
ColorPalette <- R6::R6Class("ColorPalette",
  public = list(
    colors = NULL,
    interpolate = TRUE,
    
    #' @description Initialize color palette
    #' @param colors Vector of colors
    #' @param interpolate Whether to interpolate between colors
    initialize = function(colors, interpolate = TRUE) {
      self$colors <- colors
      self$interpolate <- interpolate
    },
    
    #' @description Get colors for n values
    #' @param n Number of colors needed
    get_colors = function(n) {
      if (n <= length(self$colors)) {
        self$colors[1:n]
      } else if (self$interpolate) {
        grDevices::colorRampPalette(self$colors)(n)
      } else {
        rep_len(self$colors, n)
      }
    }
  )
)

#' @title Color Scale Class
#' @description Maps data values to colors
#' @export
ColorScale <- R6::R6Class("ColorScale",
  inherit = Scale,
  public = list(
    palette = NULL,
    na_color = "#808080",
    
    #' @description Initialize color scale
    #' @param aesthetic The aesthetic to scale
    #' @param palette Color palette to use
    #' @param na_color Color for NA values
    initialize = function(aesthetic, palette, na_color = "#808080") {
      super$initialize(aesthetic)
      self$palette <- palette
      self$na_color <- na_color
    },
    
    #' @description Transform data values to colors
    #' @param x Values to transform
    transform = function(x) {
      if (is.factor(x) || is.character(x)) {
        # Discrete scale
        unique_values <- unique(x)
        colors <- self$palette$get_colors(length(unique_values))
        color_map <- stats::setNames(colors, unique_values)
        ifelse(is.na(x), self$na_color, color_map[x])
      } else {
        # Continuous scale
        x_norm <- scales::rescale(x)
        colors <- self$palette$get_colors(100)
        color_ramp <- grDevices::colorRamp(colors)
        rgb_colors <- color_ramp(x_norm)
        ifelse(is.na(rgb_colors), 
               self$na_color, 
               grDevices::rgb(rgb_colors[,1], rgb_colors[,2], rgb_colors[,3], maxColorValue = 255))
      }
    }
  )
)

# Predefined color palettes
#' Default color palette with standard colors
#' @export 
#' @return A ColorPalette object with default colors
palette_default <- function() {
  ColorPalette$new(c("#1f77b4", "#ff7f0e", "#2ca02c", "#d62728", "#9467bd",
                     "#8c564b", "#e377c2", "#7f7f7f", "#bcbd22", "#17becf"))
}

#' Colorblind-friendly color palette
#' @export
#' @return A ColorPalette object with colorblind-friendly colors
palette_colorblind <- function() {
  ColorPalette$new(c("#000000", "#E69F00", "#56B4E9", "#009E73", "#F0E442", 
                     "#0072B2", "#D55E00", "#CC79A7"))
}

#' Diverging color palette for highlighting differences above/below a middle point
#' @export
#' @return A ColorPalette object with diverging colors
palette_diverging <- function() {
  ColorPalette$new(c("#d73027", "#f46d43", "#fdae61", "#fee090", "#ffffbf",
                     "#e0f3f8", "#abd9e9", "#74add1", "#4575b4"))
}

#' Sequential color palette for ordered data
#' @export
#' @return A ColorPalette object with sequential colors
palette_sequential <- function() {
  ColorPalette$new(c("#f7fbff", "#deebf7", "#c6dbef", "#9ecae1", "#6baed6",
                     "#4292c6", "#2171b5", "#08519c", "#08306b"))
}

# Color scale creation functions
#' Create a discrete color scale
#' @export
#' @param aesthetic The aesthetic to scale
#' @param palette Color palette to use
#' @param na_color Color for NA values
scale_color_discrete <- function(aesthetic, palette = palette_default(), na_color = "#808080") {
  ColorScale$new(aesthetic = aesthetic, palette = palette, na_color = na_color)
}

#' Create a continuous color scale
#' @export
#' @param aesthetic The aesthetic to scale
#' @param palette Color palette to use
#' @param na_color Color for NA values
scale_color_continuous <- function(aesthetic, palette = palette_sequential(), na_color = "#808080") {
  ColorScale$new(aesthetic = aesthetic, palette = palette, na_color = na_color)
}

#' Create a custom color palette
#' @export
#' @param colors Vector of colors
#' @param interpolate Whether to interpolate between colors
palette_custom <- function(colors, interpolate = TRUE) {
  ColorPalette$new(colors = colors, interpolate = interpolate)
}