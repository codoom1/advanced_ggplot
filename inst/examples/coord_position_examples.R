# Examples demonstrating coordinate systems and position adjustments

# Example 1: Polar Coordinates for Circular Visualization
# Create data for a wind rose diagram
wind_data <- data.frame(
  direction = rep(seq(0, 330, by = 30), each = 20),
  speed = c(
    rnorm(20, 15, 3), rnorm(20, 12, 2), rnorm(20, 10, 2),
    rnorm(20, 8, 2), rnorm(20, 13, 3), rnorm(20, 15, 3),
    rnorm(20, 18, 4), rnorm(20, 16, 3), rnorm(20, 12, 2),
    rnorm(20, 10, 2), rnorm(20, 14, 3), rnorm(20, 16, 3)
  )
)

# Create wind rose plot
wind_rose <- Plot$new(wind_data)
wind_rose$add_layer(
  geom_bar(mapping = list(
    x = "direction",
    y = "speed",
    fill = "speed",
    alpha = 0.7
  ))
)

# Add polar coordinates
wind_rose$set_coord(
  coord_polar(
    theta = "x",
    start = pi/2,
    direction = -1
  )
)

# Add color scale
wind_rose$add_scale(
  scale_color_continuous(
    aesthetic = "fill",
    palette = palette_sequential("Blues")
  )
)

wind_rose$set_theme(theme_minimal())
wind_rose$plot()

# Example 2: Logarithmic Scale for Growth Data
# Create exponential growth data
time_points <- seq(0, 10, by = 0.1)
growth_data <- data.frame(
  time = time_points,
  population = 100 * exp(0.5 * time_points) + rnorm(length(time_points), 0, 50),
  bacteria = 10 * exp(0.8 * time_points) + rnorm(length(time_points), 0, 20)
)

# Create growth plot with log coordinates
growth_plot <- Plot$new(growth_data)

# Add lines for different populations
growth_plot$add_layer(
  geom_line(mapping = list(
    x = "time",
    y = "population",
    color = "'steelblue'"
  ))
)
growth_plot$add_layer(
  geom_line(mapping = list(
    x = "time",
    y = "bacteria",
    color = "'darkred'"
  ))
)

# Add log coordinates
growth_plot$set_coord(coord_log())
growth_plot$set_theme(theme_minimal())
growth_plot$plot()

# Example 3: Position Adjustments for Bar Charts
# Create sales data
sales_data <- data.frame(
  quarter = rep(c("Q1", "Q2", "Q3", "Q4"), 3),
  product = rep(c("Product A", "Product B", "Product C"), each = 4),
  sales = c(
    120, 150, 180, 160,  # Product A
    90, 110, 130, 120,   # Product B
    70, 85, 95, 90       # Product C
  )
)

# Create stacked bar plot
stacked_plot <- Plot$new(sales_data)
stacked_plot$add_layer(
  geom_bar(mapping = list(
    x = "quarter",
    y = "sales",
    fill = "product"
  ),
  position = position_stack())
)

stacked_plot$set_theme(theme_minimal())
stacked_plot$plot()

# Create dodged bar plot
dodged_plot <- Plot$new(sales_data)
dodged_plot$add_layer(
  geom_bar(mapping = list(
    x = "quarter",
    y = "sales",
    fill = "product"
  ),
  position = position_dodge(width = 0.8))
)

dodged_plot$set_theme(theme_minimal())
dodged_plot$plot()

# Example 4: Combined Coordinate and Position Adjustments
# Create data for a circular bar chart
categories <- LETTERS[1:8]
values <- data.frame(
  category = rep(categories, each = 3),
  group = rep(c("Group 1", "Group 2", "Group 3"), times = length(categories)),
  value = runif(length(categories) * 3, 5, 15)
)

# Create circular bar plot with dodged bars
circular_plot <- Plot$new(values)
circular_plot$add_layer(
  geom_bar(mapping = list(
    x = "category",
    y = "value",
    fill = "group"
  ),
  position = position_dodge(width = 0.8))
)

# Add polar coordinates
circular_plot$set_coord(
  coord_polar(theta = "x")
)

# Add color scale
circular_plot$add_scale(
  scale_color_discrete(
    aesthetic = "fill",
    palette = palette_qualitative()
  )
)

circular_plot$set_theme(theme_minimal())
circular_plot$plot()