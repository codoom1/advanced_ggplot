#' Theme Class
#'
#' @title Theme Class
#' @name Theme
#' @aliases Theme
#' @docType class
#' @format \code{\link{R6Class}} object.
#' @description R6 Class for controlling the visual appearance of plot elements.
#' @section Fields:
#' \describe{
#'   \item{\code{plot.background}}{Controls the plot background appearance}
#'   \item{\code{plot.margin}}{Controls plot margins}
#'   \item{\code{panel.background}}{Controls panel background appearance}
#'   \item{\code{panel.grid.major}}{Controls major grid lines}
#'   \item{\code{panel.grid.minor}}{Controls minor grid lines}
#'   \item{\code{panel.border}}{Controls panel border}
#'   \item{\code{axis.line}}{Controls axis line appearance}
#'   \item{\code{axis.text}}{Controls axis text appearance}
#'   \item{\code{axis.title}}{Controls axis title appearance}
#'   \item{\code{axis.ticks}}{Controls axis ticks appearance}
#' }
#' @section Methods:
#' \describe{
#'   \item{\code{initialize(...)}}{Create a new Theme with the specified elements}
#'   \item{\code{apply()}}{Apply theme elements to the current viewport}
#' }
#' @export
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
NULL 