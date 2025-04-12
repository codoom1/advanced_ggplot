# Advanced_ggplot Examples
# This script demonstrates how to use the Advanced_ggplot package
# Run this after installing the package with: devtools::install_github("christopherodoom/Advanced_ggplot")

library(Advanced_ggplot)
library(reshape2) # For data manipulation

# Set seed for reproducibility
set.seed(123)

# Create output directory for saving plots if needed
dir.create("plot_outputs", showWarnings = FALSE)

# -----------------------------------------------------------------
# 1. Basic Examples
# -----------------------------------------------------------------

# Create sample data
basic_data <- data.frame(
  x = 1:20,
  y = sin(1:20 / 2) + rnorm(20, sd = 0.1),
  z = cos(1:20 / 2) + rnorm(20, sd = 0.1),
  group = rep(c("A", "B"), each = 10)
)

# 1.1 Basic scatter plot
scatter_plot <- AGPlot$new(basic_data)
scatter_plot$add_layer(geom_point(mapping = list(
  x = "x", 
  y = "y", 
  color = "blue",
  size = 3
)))
scatter_plot$plot()
# To save: pdf("scatter_plot.pdf"); scatter_plot$plot(); dev.off()

# 1.2 Line plot with different colors by group
line_plot <- AGPlot$new(basic_data)
line_plot$add_layer(geom_line(mapping = list(
  x = "x", 
  y = "y", 
  color = "group"
)))
line_plot$plot()

# 1.3 Combined geometries (points and lines)
combined_plot <- AGPlot$new(basic_data)
combined_plot$add_layer(geom_line(mapping = list(
  x = "x", 
  y = "y", 
  color = "blue"
)))
combined_plot$add_layer(geom_point(mapping = list(
  x = "x", 
  y = "y", 
  color = "red",
  size = 2
)))
combined_plot$plot()

# 1.4 Multi-series plot
multi_series <- AGPlot$new(basic_data)
multi_series$add_layer(geom_line(mapping = list(
  x = "x", 
  y = "y", 
  color = "blue"
)))
multi_series$add_layer(geom_point(mapping = list(
  x = "x", 
  y = "y", 
  color = "blue"
)))
multi_series$add_layer(geom_line(mapping = list(
  x = "x", 
  y = "z", 
  color = "red"
)))
multi_series$add_layer(geom_point(mapping = list(
  x = "x", 
  y = "z", 
  color = "red"
)))
multi_series$plot()

# -----------------------------------------------------------------
# 2. Statistical Visualizations
# -----------------------------------------------------------------

# Create data for statistical plots
stat_data <- data.frame(
  category = rep(c("Group A", "Group B", "Group C", "Group D"), each = 50),
  value = c(
    rnorm(50, mean = 5, sd = 1),     # Group A - normal
    exp(rnorm(50, 0, 0.5)) + 4,      # Group B - right skewed
    8 - exp(rnorm(50, 0, 0.5)),      # Group C - left skewed
    c(rnorm(25, 3, 0.5), rnorm(25, 6, 0.5))  # Group D - bimodal
  )
)

# 2.1 Boxplot
boxplot <- AGPlot$new(stat_data)
boxplot$add_layer(geom_boxplot(mapping = list(
  x = "category", 
  y = "value",
  fill = "lightblue",
  color = "navy"
)))
boxplot$plot()

# 2.2 Violin plot
violin_plot <- AGPlot$new(stat_data)
violin_plot$add_layer(geom_violin(mapping = list(
  x = "category", 
  y = "value",
  fill = "lightgreen",
  color = "darkgreen",
  alpha = 0.7
)))
violin_plot$plot()

# 2.3 Combined violin and boxplot - shows distribution and statistics together
combo_plot <- AGPlot$new(stat_data)
combo_plot$add_layer(geom_violin(mapping = list(
  x = "category", 
  y = "value",
  fill = "lightgreen",
  alpha = 0.5,
  width = 0.9
)))
combo_plot$add_layer(geom_boxplot(mapping = list(
  x = "category", 
  y = "value",
  fill = "white",
  alpha = 0.7,
  width = 0.3
)))
combo_plot$plot()

# 2.4 Violin plots with different scaling options
uneven_groups <- data.frame(
  group = c(rep("Small", 20), rep("Medium", 50), rep("Large", 100)),
  value = c(rnorm(20), rnorm(50), rnorm(100))
)

# Area scaling (default)
area_scaling <- AGPlot$new(uneven_groups)
area_scaling$add_layer(geom_violin(mapping = list(
  x = "group", 
  y = "value",
  fill = "salmon",
  scale = "area"   # Each violin has the same area
)))
area_scaling$plot()

# Count scaling
count_scaling <- AGPlot$new(uneven_groups)
count_scaling$add_layer(geom_violin(mapping = list(
  x = "group", 
  y = "value",
  fill = "lightblue",
  scale = "count"  # Violin width proportional to sample size
)))
count_scaling$plot()

# -----------------------------------------------------------------
# 3. Other Geometries
# -----------------------------------------------------------------

# 3.1 Histogram
hist_data <- data.frame(x = rnorm(200))
hist_plot <- AGPlot$new(hist_data)
hist_plot$add_layer(geom_histogram(mapping = list(
  x = "x",
  fill = "steelblue", 
  color = "white"
)))
hist_plot$plot()

# 3.2 Density plot
density_plot <- AGPlot$new(hist_data)
density_plot$add_layer(geom_density(mapping = list(
  x = "x", 
  fill = "lightblue", 
  color = "blue",
  alpha = 0.5
)))
density_plot$plot()

# 3.3 Bar chart
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
bar_plot$plot()

# 3.4 Area plot
area_plot <- AGPlot$new(basic_data)
area_plot$add_layer(geom_area(mapping = list(
  x = "x", 
  y = "y",
  fill = "lightblue",
  color = "blue",
  alpha = 0.7
)))
area_plot$plot()

# 3.5 Smoothed line with confidence interval
smooth_plot <- AGPlot$new(basic_data)
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
smooth_plot$plot()

# -----------------------------------------------------------------
# 4. Advanced Features
# -----------------------------------------------------------------

# 4.1 Faceting
# Create data for faceting example
multi_var <- data.frame(
  x = rep(c("A", "B", "C"), each = 100),
  y = c(rnorm(100, 5, 1), rnorm(100, 7, 1.5), rnorm(100, 4, 0.8)),
  z = c(rnorm(100, 5, 2), rnorm(100, 6, 1), rnorm(100, 7, 0.5))
)

# Convert to long format
long_data <- reshape2::melt(
  multi_var, 
  id.vars = "x", 
  variable.name = "variable", 
  value.name = "value"
)

# Create faceted plot
facet_plot <- AGPlot$new(long_data)
facet_plot$add_layer(geom_violin(mapping = list(
  x = "x", 
  y = "value",
  fill = "skyblue"
)))
facet_plot$set_facet(facet_wrap(formula = ~ variable, ncol = 2))
facet_plot$plot()

# 4.2 Theme customization
themed_plot <- AGPlot$new(basic_data)
themed_plot$add_layer(geom_line(mapping = list(
  x = "x", 
  y = "y", 
  color = "white"
)))
themed_plot$add_layer(geom_point(mapping = list(
  x = "x", 
  y = "y", 
  color = "white"
)))
themed_plot$set_theme(theme_dark())
themed_plot$plot()

# 4.3 Using annotations
annotated_plot <- AGPlot$new(basic_data)
annotated_plot$add_layer(geom_line(mapping = list(
  x = "x", 
  y = "y", 
  color = "blue"
)))
annotated_plot$add_annotation(annotation_text(
  x = 10, 
  y = max(basic_data$y), 
  label = "Peak"
))
annotated_plot$plot()

# -----------------------------------------------------------------
# 5. Combining Multiple Plot Elements
# -----------------------------------------------------------------

# Create a comprehensive plot that demonstrates multiple features
comprehensive <- AGPlot$new(stat_data)

# Add violin plots to show distributions
comprehensive$add_layer(geom_violin(mapping = list(
  x = "category", 
  y = "value",
  fill = "category",  # Color by category
  alpha = 0.6,
  width = 0.9
)))

# Add boxplots to show summary statistics
comprehensive$add_layer(geom_boxplot(mapping = list(
  x = "category", 
  y = "value",
  width = 0.2,
  alpha = 0.8
)))

# Add individual points to show raw data
comprehensive$add_layer(geom_point(mapping = list(
  x = "category",
  y = "value",
  color = "black",
  alpha = 0.3,
  size = 0.8
)))

# Apply theme and title
comprehensive$set_theme(theme_minimal())

# Plot the comprehensive visualization
comprehensive$plot()

cat("Examples completed. Run these after installing the Advanced_ggplot package.\n") 