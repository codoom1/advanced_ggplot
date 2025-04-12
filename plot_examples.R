library(Advanced_ggplot)
library(grDevices)

# Set seed for reproducibility
set.seed(123)

# Create output directory
dir.create("plot_outputs", showWarnings = FALSE)

# Create sample data with different distributions
categories <- rep(c("Normal", "Right-skewed", "Bimodal", "Left-skewed"), each = 100)

# Normal distribution
normal_data <- rnorm(100, mean = 5, sd = 1)

# Right-skewed distribution (log-normal)
right_skewed <- exp(rnorm(100, mean = 0, sd = 0.5)) + 3

# Bimodal distribution (mixture of two normals)
bimodal <- c(rnorm(50, mean = 3, sd = 0.5), rnorm(50, mean = 6, sd = 0.5))

# Left-skewed distribution
left_skewed <- 10 - exp(rnorm(100, mean = 0, sd = 0.5))

# Combine into a data frame
values <- c(normal_data, right_skewed, bimodal, left_skewed)
stat_data <- data.frame(
  distribution = categories,
  value = values
)

# 1. Basic Violin Plot
png("plot_outputs/violin_plot.png", width = 800, height = 600)
violin_plot <- AGPlot$new(stat_data)
violin_plot$add_layer(geom_violin(mapping = list(
  x = "distribution", 
  y = "value",
  fill = "lightgreen",
  color = "darkgreen",
  alpha = 0.7
)))
violin_plot$plot()
dev.off()

# 2. Combined Boxplot and Violin Plot
png("plot_outputs/combined_boxplot_violin.png", width = 800, height = 600)
combined_plot <- AGPlot$new(stat_data)
combined_plot$add_layer(geom_violin(mapping = list(
  x = "distribution", 
  y = "value",
  fill = "lightgreen",
  alpha = 0.5,
  width = 0.9
)))
combined_plot$add_layer(geom_boxplot(mapping = list(
  x = "distribution", 
  y = "value",
  fill = "white",
  alpha = 0.7,
  width = 0.3
)))
combined_plot$plot()
dev.off()

# 3. Violin Plot Scaling Comparison
# Create data with different group sizes
uneven_groups <- data.frame(
  group = c(rep("Small", 20), rep("Medium", 50), rep("Large", 100)),
  value = c(rnorm(20), rnorm(50), rnorm(100))
)

# Area scaling (default)
png("plot_outputs/area_scaling.png", width = 800, height = 600)
area_scaling <- AGPlot$new(uneven_groups)
area_scaling$add_layer(geom_violin(mapping = list(
  x = "group", 
  y = "value",
  fill = "salmon",
  scale = "area"
)))
area_scaling$plot()
dev.off()

# Count scaling
png("plot_outputs/count_scaling.png", width = 800, height = 600)
count_scaling <- AGPlot$new(uneven_groups)
count_scaling$add_layer(geom_violin(mapping = list(
  x = "group", 
  y = "value",
  fill = "lightblue",
  scale = "count"
)))
count_scaling$plot()
dev.off()

# 4. Faceted Violin Plots
# Create multi-variable data
multi_var <- data.frame(
  x = rep(c("A", "B", "C"), each = 100),
  y = c(rnorm(100, 5, 1), rnorm(100, 7, 1.5), rnorm(100, 4, 0.8)),
  z = c(rnorm(100, 5, 2), rnorm(100, 6, 1), rnorm(100, 7, 0.5))
)

# Convert to long format for faceting
long_data <- reshape2::melt(
  multi_var, 
  id.vars = "x", 
  variable.name = "variable", 
  value.name = "value"
)

# Create faceted violin plots
png("plot_outputs/faceted_violins.png", width = 800, height = 600)
facet_violins <- AGPlot$new(long_data)
facet_violins$add_layer(geom_violin(mapping = list(
  x = "x", 
  y = "value",
  fill = "skyblue"
)))
facet_violins$set_facet(facet_wrap(formula = ~ variable, ncol = 2))
facet_violins$plot()
dev.off()

cat("Plot images have been saved to the 'plot_outputs' directory.\n") 