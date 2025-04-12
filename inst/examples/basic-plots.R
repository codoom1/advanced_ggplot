# Advanced_ggplot Basic Examples
# This script demonstrates the core functionality of the Advanced_ggplot package

library(Advanced_ggplot)

# Create some sample data
set.seed(123)  # For reproducibility
data <- data.frame(
  x = 1:20,
  y = sin(1:20 / 2) + rnorm(20, sd = 0.1),
  z = cos(1:20 / 2) + rnorm(20, sd = 0.1),
  group = rep(c("A", "B"), each = 10)
)

#---------------------------------------------------------
# 1. Basic scatter plot
#---------------------------------------------------------
scatter_plot <- AGPlot$new(data)
scatter_plot$add_layer(geom_point(mapping = list(
  x = "x", 
  y = "y", 
  color = "blue"
)))
# Display the plot
scatter_plot$plot()

#---------------------------------------------------------
# 2. Line plot with different colors by group
#---------------------------------------------------------
line_plot <- AGPlot$new(data)
line_plot$add_layer(geom_line(mapping = list(
  x = "x", 
  y = "y", 
  color = "group"
)))
# Display the plot
line_plot$plot()

#---------------------------------------------------------
# 3. Combined geometries (points and lines)
#---------------------------------------------------------
combined_plot <- AGPlot$new(data)
combined_plot$add_layer(geom_line(mapping = list(
  x = "x", 
  y = "y", 
  color = "blue"
)))
combined_plot$add_layer(geom_point(mapping = list(
  x = "x", 
  y = "y", 
  color = "red"
)))
# Display the plot
combined_plot$plot()

#---------------------------------------------------------
# 4. Smoothed line with confidence interval
#---------------------------------------------------------
smooth_plot <- AGPlot$new(data)
smooth_plot$add_layer(geom_point(mapping = list(
  x = "x", 
  y = "y", 
  color = "black"
)))
smooth_plot$add_layer(geom_smooth(mapping = list(
  x = "x", 
  y = "y", 
  color = "blue"
)))
# Display the plot
smooth_plot$plot()

#---------------------------------------------------------
# 5. Histograms
#---------------------------------------------------------
hist_plot <- AGPlot$new(data)
hist_plot$add_layer(geom_histogram(mapping = list(
  x = "y", 
  fill = "lightblue", 
  color = "black"
)))
# Display the plot
hist_plot$plot()

#---------------------------------------------------------
# 6. Boxplots
#---------------------------------------------------------
# Create data for boxplot
boxplot_data <- data.frame(
  category = rep(c("Group A", "Group B", "Group C"), each = 30),
  value = c(
    rnorm(30, mean = 5, sd = 1),
    rnorm(30, mean = 7, sd = 1.5),
    rnorm(30, mean = 4, sd = 0.8)
  )
)

boxplot <- AGPlot$new(boxplot_data)
boxplot$add_layer(geom_boxplot(mapping = list(
  x = "category", 
  y = "value",
  fill = "lightblue",
  color = "navy"
)))
# Display the plot
boxplot$plot()

#---------------------------------------------------------
# 7. Faceted plot
#---------------------------------------------------------
# Prepare data in long format for faceting
long_data <- reshape2::melt(
  data[, c("x", "y", "z")], 
  id.vars = "x", 
  variable.name = "series", 
  value.name = "value"
)

facet_plot <- AGPlot$new(long_data)
facet_plot$add_layer(geom_line(mapping = list(
  x = "x", 
  y = "value", 
  color = "blue"
)))
facet_plot$add_layer(geom_point(mapping = list(
  x = "x", 
  y = "value", 
  color = "red"
)))
facet_plot$set_facet(facet_wrap(formula = ~ series, ncol = 1))
# Display the plot
facet_plot$plot()

#---------------------------------------------------------
# 8. Density plot
#---------------------------------------------------------
density_plot <- AGPlot$new(data)
density_plot$add_layer(geom_density(mapping = list(
  x = "y", 
  fill = "lightblue", 
  color = "blue"
)))
# Display the plot
density_plot$plot()

#---------------------------------------------------------
# 9. Bar chart
#---------------------------------------------------------
counts <- data.frame(
  category = c("A", "B", "C", "D"),
  value = c(25, 40, 15, 35)
)

bar_plot <- AGPlot$new(counts)
bar_plot$add_layer(geom_bar(mapping = list(
  x = "category", 
  y = "value",
  fill = "steelblue"
)))
# Display the plot
bar_plot$plot()

#---------------------------------------------------------
# 10. Area plot
#---------------------------------------------------------
area_plot <- AGPlot$new(data)
area_plot$add_layer(geom_area(mapping = list(
  x = "x", 
  y = "y",
  fill = "lightblue",
  color = "blue"
)))
# Display the plot
area_plot$plot() 