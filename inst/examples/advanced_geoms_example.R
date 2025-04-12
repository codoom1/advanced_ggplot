# Examples demonstrating advanced geometries

# Example 1: Confidence Band with Ribbon
set.seed(123)
time_data <- data.frame(
  x = seq(0, 10, length.out = 100)
)
time_data$y <- sin(time_data$x) + rnorm(100, sd = 0.2)

# Fit a smooth curve with confidence intervals
smooth_fit <- loess(y ~ x, data = time_data, span = 0.3)
pred <- predict(smooth_fit, se = TRUE)

confidence_plot <- Plot$new(time_data)

# Add ribbon for confidence band
confidence_plot$add_layer(
  geom_ribbon(mapping = list(
    x = "x",
    ymin = sprintf("%s - 1.96 * %s", pred$fit, pred$se.fit),
    ymax = sprintf("%s + 1.96 * %s", pred$fit, pred$se.fit),
    fill = "'lightblue'"
  ))
)

# Add smooth line
confidence_plot$add_layer(
  geom_line(mapping = list(
    x = "x",
    y = pred$fit,
    color = "'steelblue'",
    size = 1.2
  ))
)

# Add original points
confidence_plot$add_layer(
  geom_point(mapping = list(
    x = "x",
    y = "y",
    color = "'gray50'",
    size = 0.8
  ))
)

confidence_plot$set_theme(theme_minimal())
confidence_plot$plot()

# Example 2: Stacked Area Plot
economics_data <- data.frame(
  year = rep(2015:2024, 3),
  sector = rep(c("Technology", "Services", "Manufacturing"), each = 10),
  value = c(
    cumsum(runif(10, 5, 15)),  # Technology growing fast
    cumsum(runif(10, 3, 8)),   # Services moderate growth
    cumsum(runif(10, 1, 5))    # Manufacturing slower growth
  )
)

area_plot <- Plot$new(economics_data)
area_plot$add_layer(
  geom_area(mapping = list(
    x = "year",
    y = "value",
    fill = "sector",
    group = "sector"
  ))
)

area_plot$add_scale(
  scale_color_discrete("fill", palette = palette_sequential())
)
area_plot$set_theme(theme_minimal())
area_plot$plot()

# Example 3: Bivariate Density Contours
set.seed(123)
n <- 1000
bivariate_data <- data.frame(
  x = c(rnorm(n/2, -1, 0.5), rnorm(n/2, 1, 0.5)),
  y = c(rnorm(n/2, -1, 0.5), rnorm(n/2, 1, 0.5))
)

# Create grid for density estimation
grid_size <- 50
x_grid <- seq(min(bivariate_data$x), max(bivariate_data$x), length.out = grid_size)
y_grid <- seq(min(bivariate_data$y), max(bivariate_data$y), length.out = grid_size)
grid_data <- expand.grid(x = x_grid, y = y_grid)

# Estimate density
density_est <- MASS::kde2d(bivariate_data$x, bivariate_data$y, n = grid_size)
grid_data$z <- as.vector(density_est$z)

# Create contour plot
contour_plot <- Plot$new(grid_data)

# Add filled contours
contour_plot$add_layer(
  geom_contour_filled(
    mapping = list(
      x = "x",
      y = "y",
      z = "z"
    ),
    bins = 15
  )
)

# Add contour lines
contour_plot$add_layer(
  geom_contour(
    mapping = list(
      x = "x",
      y = "y",
      z = "z",
      color = "'black'",
      alpha = 0.5
    ),
    bins = 10
  )
)

# Add points
contour_plot$add_layer(
  geom_point(
    mapping = list(
      x = bivariate_data$x,
      y = bivariate_data$y,
      color = "'black'",
      alpha = 0.1,
      size = 0.5
    )
  )
)

contour_plot$set_theme(theme_minimal())
contour_plot$plot()