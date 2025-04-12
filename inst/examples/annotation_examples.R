# Examples demonstrating annotation capabilities

# Example 1: Annotated Scatter Plot
set.seed(123)
scatter_data <- data.frame(
  x = rnorm(50),
  y = rnorm(50)
)

# Find points of interest
max_point <- scatter_data[which.max(scatter_data$y), ]
min_point <- scatter_data[which.min(scatter_data$y), ]

scatter_plot <- Plot$new(scatter_data)

# Add points
scatter_plot$add_layer(
  geom_point(mapping = list(
    x = "x",
    y = "y",
    color = "'steelblue'"
  ))
)

# Add reference lines at mean values
scatter_plot$add_annotation(
  annotate_reference_line(
    value = mean(scatter_data$x),
    orientation = "v",
    color = "darkgray",
    linetype = "dashed"
  )
)

scatter_plot$add_annotation(
  annotate_reference_line(
    value = mean(scatter_data$y),
    orientation = "h",
    color = "darkgray",
    linetype = "dashed"
  )
)

# Add labels for extreme points
scatter_plot$add_annotation(
  annotate_text(
    x = max_point$x,
    y = max_point$y + 0.2,
    label = "Maximum",
    color = "red"
  )
)

scatter_plot$add_annotation(
  annotate_text(
    x = min_point$x,
    y = min_point$y - 0.2,
    label = "Minimum",
    color = "blue"
  )
)

# Add arrows pointing to extreme points
scatter_plot$add_annotation(
  annotate_arrow(
    x0 = max_point$x,
    y0 = max_point$y + 0.15,
    x1 = max_point$x,
    y1 = max_point$y + 0.02,
    color = "red"
  )
)

scatter_plot$add_annotation(
  annotate_arrow(
    x0 = min_point$x,
    y0 = min_point$y - 0.15,
    x1 = min_point$x,
    y1 = min_point$y - 0.02,
    color = "blue"
  )
)

scatter_plot$set_theme(theme_minimal())
scatter_plot$plot()

# Example 2: Annotated Time Series
time_data <- data.frame(
  time = seq(as.Date("2024-01-01"), as.Date("2024-12-31"), by = "month"),
  value = cumsum(rnorm(12, 0.5, 0.2))
)

# Find important events
peak <- time_data[which.max(time_data$value), ]
trough <- time_data[which.min(time_data$value), ]

ts_plot <- Plot$new(time_data)

# Add line
ts_plot$add_layer(
  geom_line(mapping = list(
    x = "as.numeric(time)",
    y = "value",
    color = "'darkblue'"
  ))
)

# Add trend line
ts_plot$add_annotation(
  annotate_reference_line(
    value = mean(time_data$value),
    orientation = "h",
    color = "red",
    linetype = "dashed"
  )
)

# Add annotations for peak and trough
ts_plot$add_annotation(
  annotate_text(
    x = as.numeric(peak$time),
    y = peak$value + 0.1,
    label = "Peak",
    color = "darkgreen"
  )
)

ts_plot$add_annotation(
  annotate_text(
    x = as.numeric(trough$time),
    y = trough$value - 0.1,
    label = "Trough",
    color = "darkred"
  )
)

ts_plot$set_theme(theme_minimal())
ts_plot$plot()

# Example 3: Annotated Bar Chart with Statistics
sales_data <- data.frame(
  product = LETTERS[1:5],
  sales = c(120, 85, 140, 95, 110)
)

mean_sales <- mean(sales_data$sales)
target_sales <- 100

bar_plot <- Plot$new(sales_data)

# Add bars
bar_plot$add_layer(
  geom_bar(mapping = list(
    x = "product",
    y = "sales",
    fill = "'steelblue'"
  ))
)

# Add target line
bar_plot$add_annotation(
  annotate_reference_line(
    value = target_sales,
    orientation = "h",
    color = "red",
    linetype = "dashed"
  )
)

# Add mean line
bar_plot$add_annotation(
  annotate_reference_line(
    value = mean_sales,
    orientation = "h",
    color = "green",
    linetype = "dashed"
  )
)

# Add labels for lines
bar_plot$add_annotation(
  annotate_text(
    x = 1,
    y = target_sales + 5,
    label = "Target",
    color = "red"
  )
)

bar_plot$add_annotation(
  annotate_text(
    x = 1,
    y = mean_sales + 5,
    label = "Mean",
    color = "green"
  )
)

# Add performance indicators
for (i in seq_along(sales_data$sales)) {
  if (sales_data$sales[i] > target_sales) {
    bar_plot$add_annotation(
      annotate_text(
        x = i,
        y = sales_data$sales[i] + 5,
        label = "↑",
        color = "darkgreen",
        size = 12
      )
    )
  } else if (sales_data$sales[i] < target_sales) {
    bar_plot$add_annotation(
      annotate_text(
        x = i,
        y = sales_data$sales[i] + 5,
        label = "↓",
        color = "darkred",
        size = 12
      )
    )
  }
}

bar_plot$set_theme(theme_minimal())
bar_plot$plot()