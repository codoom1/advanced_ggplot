# Examples demonstrating interactive visualization capabilities

# Example 1: Interactive Scatter Plot with Tooltips and Zoom
set.seed(123)
data <- data.frame(
  x = rnorm(100),
  y = rnorm(100),
  category = sample(LETTERS[1:4], 100, replace = TRUE),
  value = round(runif(100, 10, 100))
)

# Create interactive scatter plot
scatter_plot <- interactive_plot(data)

# Add interactive points with tooltips
scatter_plot$add_layer(
  interactive_point(
    mapping = list(
      x = "x",
      y = "y",
      color = "category"
    ),
    hover_style = list(
      radius = 8,
      stroke = "white",
      strokeWidth = 2
    )
  )
)

# Add tooltip showing point details
scatter_plot$add_tooltip("points", function(d) {
  sprintf("Category: %s\nValue: %d", d$category, d$value)
})

# Enable zoom and pan
scatter_plot$enable_zoom()
scatter_plot$enable_pan()

# Convert to widget
scatter_widget <- scatter_plot$as_widget(width = 800, height = 600)

# Example 2: Interactive Time Series with Brush Selection
time_data <- data.frame(
  date = seq(as.Date("2024-01-01"), as.Date("2024-12-31"), by = "day"),
  value = cumsum(rnorm(366, 0, 0.1)),
  category = rep(c("A", "B"), each = 183)
)

ts_plot <- interactive_plot(time_data)

# Add interactive lines
ts_plot$add_layer(
  interactive_line(
    mapping = list(
      x = "as.numeric(date)",
      y = "value",
      color = "category"
    ),
    hover_style = list(
      strokeWidth = 3,
      opacity = 1
    )
  )
)

# Enable brush selection for time range selection
ts_plot$enable_brush()

# Add click handler for points
ts_plot$add_click_handler("lines", function(d) {
  sprintf("Selected date: %s\nValue: %.2f", d$date, d$value)
})

# Convert to widget
ts_widget <- ts_plot$as_widget(width = 1000, height = 400)

# Example 3: Interactive Bar Chart with Drill-down
sales_data <- data.frame(
  category = rep(LETTERS[1:5], each = 4),
  subcategory = rep(1:4, times = 5),
  value = round(runif(20, 100, 1000))
)

bar_plot <- interactive_plot(sales_data)

# Add interactive bars
bar_plot$add_layer(
  interactive_bar(
    mapping = list(
      x = "category",
      y = "value",
      fill = "category"
    ),
    hover_style = list(
      opacity = 0.8,
      stroke = "white",
      strokeWidth = 2
    ),
    click_style = list(
      opacity = 1,
      stroke = "black",
      strokeWidth = 3
    )
  )
)

# Add tooltip with detailed information
bar_plot$add_tooltip("bars", function(d) {
  sprintf("Category: %s\nTotal Value: %d\nClick for details", 
          d$category, d$value)
})

# Add click handler to show subcategories
bar_plot$add_click_handler("bars", function(d) {
  # Filter data for clicked category
  subset_data <- sales_data[sales_data$category == d$category, ]
  # Create detailed view (in practice, this would update the visualization)
  sprintf("Subcategories for %s:\n%s", 
          d$category,
          paste(sprintf("  %d: %d", subset_data$subcategory, subset_data$value),
                collapse = "\n"))
})

# Convert to widget
bar_widget <- bar_plot$as_widget(width = 800, height = 500)

# Example 4: Interactive Network Graph
nodes <- data.frame(
  id = 1:10,
  group = sample(c("A", "B", "C"), 10, replace = TRUE),
  size = runif(10, 5, 15)
)

edges <- data.frame(
  from = sample(1:10, 15, replace = TRUE),
  to = sample(1:10, 15, replace = TRUE),
  weight = runif(15)
)

network_plot <- interactive_plot()
network_plot$add_layer(
  interactive_network(
    nodes = nodes,
    edges = edges,
    mapping = list(
      color = "group",
      size = "size",
      edge_width = "weight"
    ),
    hover_style = list(
      nodeColor = "red",
      nodeSize = 20
    )
  )
)

# Enable zoom and pan for network navigation
network_plot$enable_zoom()
network_plot$enable_pan()

# Add tooltip for nodes
network_plot$add_tooltip("nodes", function(d) {
  sprintf("Node %d\nGroup: %s\nConnections: %d",
          d$id, d$group, sum(edges$from == d$id | edges$to == d$id))
})

# Convert to widget
network_widget <- network_plot$as_widget(width = 800, height = 800)