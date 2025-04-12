# Examples of statistical transformations

# Create sample data with some noise
set.seed(123)
n <- 100
data <- data.frame(
  x = seq(0, 10, length.out = n),
  y = sin(seq(0, 10, length.out = n)) + rnorm(n, sd = 0.2)
)

# Example 1: Scatter plot with smoothed trend line
plot1 <- Plot$new(data)

# Add scatter points
plot1$add_layer(
  geom_point(mapping = list(
    x = "x",
    y = "y",
    color = "'steelblue'"
  ))
)

# Add smoothed line with confidence interval
plot1$add_layer(
  geom_line(
    mapping = list(
      x = "x",
      y = "y",
      color = "'red'"
    ),
    stat = stat_smooth(method = "loess", se = TRUE)
  )
)

# Use minimal theme
plot1$set_theme(theme_minimal())
plot1$plot()

# Example 2: Histogram with density curve
random_data <- data.frame(
  value = c(rnorm(500, mean = 0, sd = 1), rnorm(200, mean = 2, sd = 0.5))
)

plot2 <- Plot$new(random_data)

# Add histogram bars
plot2$add_layer(
  geom_bar(
    mapping = list(x = "value"),
    stat = stat_bin(bins = 30)
  )
)

# Add smoothed density curve
plot2$add_layer(
  geom_line(
    mapping = list(
      x = "value",
      y = "density"
    ),
    stat = stat_smooth(method = "loess", se = FALSE)
  )
)

# Use dark theme for contrast
plot2$set_theme(theme_dark())
plot2$plot()

# Example 3: Multiple smoothing methods comparison
plot3 <- Plot$new(data)

# Add original points
plot3$add_layer(
  geom_point(mapping = list(
    x = "x",
    y = "y",
    color = "'grey'"
  ))
)

# Add LOESS smoothing
plot3$add_layer(
  geom_line(
    mapping = list(
      x = "x",
      y = "y",
      color = "'red'"
    ),
    stat = stat_smooth(method = "loess", se = FALSE)
  )
)

# Add linear regression line
plot3$add_layer(
  geom_line(
    mapping = list(
      x = "x",
      y = "y",
      color = "'blue'"
    ),
    stat = stat_smooth(method = "lm", se = FALSE)
  )
)

plot3$plot()