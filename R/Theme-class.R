#' Theme Class
#'
#' @name Theme-class
#' @aliases Theme
#' @description Controls the visual appearance of plot elements
#'
#' @details The Theme class controls various visual aspects of a plot, including 
#' backgrounds, grid lines, and text elements. It is used to define the visual 
#' style of plots created with AdvancedGgplot.
#'
#' @section Fields:
#' \describe{
#'   \item{plot.background}{Controls the plot background appearance}
#'   \item{plot.margin}{Controls plot margins}
#'   \item{panel.background}{Controls panel background appearance}
#'   \item{panel.grid.major}{Controls major grid lines}
#'   \item{panel.grid.minor}{Controls minor grid lines}
#'   \item{panel.border}{Controls panel border}
#'   \item{axis.line}{Controls axis line appearance}
#'   \item{axis.text}{Controls axis text appearance}
#'   \item{axis.title}{Controls axis title appearance}
#'   \item{axis.ticks}{Controls axis ticks appearance}
#' }
#'
#' @section Methods:
#' \describe{
#'   \item{\code{initialize(...)}}{Create a new Theme with the specified elements}
#'   \item{\code{apply()}}{Apply theme elements to the current viewport}
#' }
#'
#' @examples
#' \dontrun{
#' # Create a custom theme
#' custom_theme <- Theme$new(
#'   plot.background = list(fill = "white"),
#'   panel.grid.major = list(color = "grey80")
#' )
#'
#' # Apply theme to a plot
#' plot <- AGPlot$new(data)
#' plot$set_theme(custom_theme)
#' }
#'
#' @export
NULL 