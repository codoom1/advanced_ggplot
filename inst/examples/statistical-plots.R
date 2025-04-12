# Advanced_ggplot Statistical Visualizations
# This script demonstrates statistical visualizations in the Advanced_ggplot package

library(Advanced_ggplot)

# Set seed for reproducibility
set.seed(123)

#---------------------------------------------------------
# Create sample data with multiple groups
#---------------------------------------------------------
# Generate random data for 4 different distributions
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

#---------------------------------------------------------
# 1. Basic Boxplot
#---------------------------------------------------------
boxplot <- Plot$new(stat_data)
boxplot$add_layer(geom_boxplot(mapping = list(
  x = "distribution", 
  y = "value",
  fill = "lightblue",
  color = "navy"
)))
# Display the plot
boxplot$plot()

#---------------------------------------------------------
# 2. Basic Violin Plot
#---------------------------------------------------------
violin_plot <- Plot$new(stat_data)
violin_plot$add_layer(geom_violin(mapping = list(
  x = "distribution", 
  y = "value",
  fill = "lightgreen",
  color = "darkgreen",
  alpha = 0.7
)))
# Display the plot
violin_plot$plot()

#---------------------------------------------------------
# 3. Combined Boxplot and Violin Plot
#---------------------------------------------------------
# This shows both the distribution shape and the summary statistics
combined_plot <- Plot$new(stat_data)
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
# Display the plot
combined_plot$plot()

#---------------------------------------------------------
# 4. Violin Plot with Different Scaling Options
#---------------------------------------------------------
# Create data with different group sizes
uneven_groups <- data.frame(
  group = c(rep("Small", 20), rep("Medium", 50), rep("Large", 100)),
  value = c(rnorm(20), rnorm(50), rnorm(100))
)

# Area scaling (each violin has the same area)
area_scaling <- Plot$new(uneven_groups)
area_scaling$add_layer(geom_violin(mapping = list(
  x = "group", 
  y = "value",
  fill = "salmon",
  scale = "area"
)))
# Display the plot
area_scaling$plot()

# Count scaling (violin width proportional to group size)
count_scaling <- Plot$new(uneven_groups)
count_scaling$add_layer(geom_violin(mapping = list(
  x = "group", 
  y = "value",
  fill = "lightblue",
  scale = "count"
)))
# Display the plot
count_scaling$plot()

#---------------------------------------------------------
# 5. Comparing Multiple Variables with Violin Plots
#---------------------------------------------------------
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
facet_violins <- Plot$new(long_data)
facet_violins$add_layer(geom_violin(mapping = list(
  x = "x", 
  y = "value",
  fill = "x"
)))
facet_violins$set_facet(facet_wrap(formula = ~ variable, ncol = 2))
# Display the plot
facet_violins$plot() 