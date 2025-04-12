# Advanced plotting examples showing themes, scales, and bar plots

# Create sample categorical data
categories <- c("A", "B", "C", "D", "E")
values <- c(23, 45, 12, 78, 34)
error_margins <- c(2, 4, 1, 6, 3)

data <- data.frame(
  category = categories,
  value = values,
  error = error_margins
)

# Create a bar plot with error bars
plot <- Plot$new(data)

# Add bars
plot$add_layer(
  geom_bar(mapping = list(
    x = "category",
    y = "value",
    fill = "steelblue"
  ))
)

# Add error bars using line geometry
plot$add_layer(
  geom_line(mapping = list(
    x = "category",
    y = "value + error",
    color = "red"
  ))
)
plot$add_layer(
  geom_line(mapping = list(
    x = "category",
    y = "value - error",
    color = "red"
  ))
)

# Add scales
plot$add_scale(
  scale_continuous(
    aesthetic = "y",
    name = "Values",
    breaks = seq(0, 100, by = 20)
  )
)

# Apply dark theme
plot$set_theme(theme_dark())

# Display the plot
plot$plot()

# Create another example with multiple layers and custom theme
time <- seq(0, 10, by = 0.1)
data2 <- data.frame(
  x = time,
  y1 = sin(time),
  y2 = cos(time)
)

plot2 <- Plot$new(data2)

# Add sine wave
plot2$add_layer(
  geom_line(mapping = list(
    x = "x",
    y = "y1",
    color = "steelblue"
  ))
)

# Add cosine wave with points
plot2$add_layer(
  geom_line(mapping = list(
    x = "x",
    y = "y2",
    color = "darkred"
  ))
)
plot2$add_layer(
  geom_point(mapping = list(
    x = "x",
    y = "y2",
    color = "red",
    size = unit(1, "mm")
  ))
)

# Add custom theme
plot2$set_theme(
  theme(
    plot.background = list(fill = "grey95"),
    panel.background = list(fill = "white"),
    panel.grid.major = list(color = "grey80"),
    panel.grid.minor = list(color = "grey90"),
    axis.line = list(color = "grey50")
  )
)

# Display the second plot
plot2$plot()

# Examples demonstrating advanced plot layouts and arrangements

# Example 1: Multi-panel Time Series
# Create sample data for multiple time series
set.seed(123)
dates <- seq(as.Date("2024-01-01"), as.Date("2024-12-31"), by = "day")
metrics <- data.frame(
  date = rep(dates, 4),
  metric = rep(c("Sales", "Traffic", "Conversions", "Revenue"), each = length(dates)),
  value = c(
    cumsum(rnorm(366, 1, 0.2)),  # Sales
    cumsum(rnorm(366, 2, 0.5)),  # Traffic
    cumsum(rnorm(366, 0.5, 0.1)), # Conversions
    cumsum(rnorm(366, 3, 0.8))   # Revenue
  )
)

# Create individual plots
plots <- list()
for (m in unique(metrics$metric)) {
  data <- metrics[metrics$metric == m,]
  p <- Plot$new(data)
  p$add_layer(
    geom_line(mapping = list(
      x = "as.numeric(date)",
      y = "value",
      color = "'steelblue'"
    ))
  )
  p$set_theme(theme_minimal())
  plots[[m]] <- p
}

# Arrange plots in a 2x2 grid
grid_layout <- plot_grid(plots, ncol = 2)
grid_layout$render()

# Example 2: Complex Analysis Dashboard
# Create different visualizations of the same dataset
set.seed(456)
analysis_data <- data.frame(
  x = rnorm(1000),
  y = rnorm(1000),
  category = sample(LETTERS[1:5], 1000, replace = TRUE)
)

# Scatter plot
scatter <- Plot$new(analysis_data)
scatter$add_layer(
  geom_point(mapping = list(
    x = "x",
    y = "y",
    color = "category"
  ))
)
scatter$set_theme(theme_minimal())

# Density plot
density <- Plot$new(analysis_data)
density$add_layer(
  geom_density(mapping = list(
    x = "x",
    fill = "category",
    alpha = 0.5
  ))
)
density$set_theme(theme_minimal())

# Box plot
box <- Plot$new(analysis_data)
box$add_layer(
  geom_boxplot(mapping = list(
    x = "category",
    y = "y",
    fill = "category"
  ))
)
box$set_theme(theme_minimal())

# Arrange plots with custom layout
dashboard <- arrange_plots(
  scatter, density, box,
  ncol = 2,
  nrow = 2,
  widths = c(2, 1),    # Make left column wider
  heights = c(2, 1)    # Make top row taller
)
dashboard$render()

# Example 3: Comparative Analysis with Shared Legend
# Create multiple related visualizations
set.seed(789)
comparison_data <- data.frame(
  x = rep(1:50, 3),
  y = c(
    cumsum(rnorm(50, 1, 0.2)),
    cumsum(rnorm(50, 1.5, 0.3)),
    cumsum(rnorm(50, 0.8, 0.1))
  ),
  group = rep(c("A", "B", "C"), each = 50)
)

# Line plot
line_plot <- Plot$new(comparison_data)
line_plot$add_layer(
  geom_line(mapping = list(
    x = "x",
    y = "y",
    color = "group"
  ))
)
line_plot$set_theme(theme_minimal())

# Point plot with confidence bands
point_plot <- Plot$new(comparison_data)
point_plot$add_layer(
  geom_point(mapping = list(
    x = "x",
    y = "y",
    color = "group"
  ))
)
point_plot$set_theme(theme_minimal())

# Area plot
area_plot <- Plot$new(comparison_data)
area_plot$add_layer(
  geom_area(mapping = list(
    x = "x",
    y = "y",
    fill = "group",
    alpha = 0.5
  ))
)
area_plot$set_theme(theme_minimal())

# Create grid with shared legend
comparison_grid <- plot_grid(
  list(line_plot, point_plot, area_plot),
  ncol = 3,
  shared_legend = TRUE,
  legend_position = "bottom"
)
comparison_grid$render()

# Example 4: Hierarchical Layout
# Create nested layout structure
set.seed(101)
data1 <- data.frame(x = 1:10, y = cumsum(rnorm(10)))
data2 <- data.frame(x = 1:20, y = cumsum(rnorm(20)))
data3 <- data.frame(x = 1:15, y = cumsum(rnorm(15)))
data4 <- data.frame(x = 1:30, y = cumsum(rnorm(30)))

# Create individual plots
p1 <- Plot$new(data1)$add_layer(geom_line(mapping = list(x = "x", y = "y")))
p2 <- Plot$new(data2)$add_layer(geom_point(mapping = list(x = "x", y = "y")))
p3 <- Plot$new(data3)$add_layer(geom_area(mapping = list(x = "x", y = "y")))
p4 <- Plot$new(data4)$add_layer(geom_bar(mapping = list(x = "x", y = "y")))

# Create nested layout
# First create a sub-layout
sub_layout <- arrange_plots(p3, p4, ncol = 2)

# Create main layout with sub-layout
main_layout <- arrange_plots(
  p1,
  p2,
  sub_layout,
  nrow = 3,
  heights = c(1, 1, 2)  # Make bottom row (sub-layout) taller
)
main_layout$render()