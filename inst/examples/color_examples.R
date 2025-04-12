# Examples demonstrating color palette and scale capabilities

# Example 1: Discrete Color Scale with Different Palettes
categorical_data <- data.frame(
  category = rep(LETTERS[1:8], each = 5),
  value = runif(40, 0, 10)
)

# Default palette
plot1 <- Plot$new(categorical_data)
plot1$add_layer(
  geom_point(mapping = list(
    x = "category",
    y = "value",
    color = "category"
  ))
)
plot1$add_scale(
  scale_color_discrete("color")
)
plot1$set_theme(theme_minimal())
plot1$plot()

# Colorblind-friendly palette
plot2 <- Plot$new(categorical_data)
plot2$add_layer(
  geom_point(mapping = list(
    x = "category",
    y = "value",
    color = "category"
  ))
)
plot2$add_scale(
  scale_color_discrete("color", palette = palette_colorblind())
)
plot2$set_theme(theme_minimal())
plot2$plot()

# Example 2: Continuous Color Scale with Sequential Palette
set.seed(123)
grid_data <- expand.grid(
  x = seq(-2, 2, length.out = 50),
  y = seq(-2, 2, length.out = 50)
)
grid_data$z <- with(grid_data, exp(-(x^2 + y^2)/2))

heatmap <- Plot$new(grid_data)
heatmap$add_layer(
  geom_tile(mapping = list(
    x = "x",
    y = "y",
    fill = "z"
  ))
)
heatmap$add_scale(
  scale_color_continuous("fill", palette = palette_sequential())
)
heatmap$set_theme(theme_minimal())
heatmap$plot()

# Example 3: Diverging Color Scale
correlation_data <- data.frame(
  x = rep(1:5, 5),
  y = rep(1:5, each = 5),
  correlation = runif(25, -1, 1)
)

correlation_plot <- Plot$new(correlation_data)
correlation_plot$add_layer(
  geom_tile(mapping = list(
    x = "x",
    y = "y",
    fill = "correlation"
  ))
)
correlation_plot$add_scale(
  scale_color_continuous("fill", palette = palette_diverging())
)
correlation_plot$set_theme(theme_minimal())
correlation_plot$plot()

# Example 4: Custom Color Palette
custom_colors <- c("#2E294E", "#541388", "#F1E9DA", "#FFD400", "#D90368")
scatter_data <- data.frame(
  x = rnorm(100),
  y = rnorm(100),
  group = sample(letters[1:5], 100, replace = TRUE)
)

custom_plot <- Plot$new(scatter_data)
custom_plot$add_layer(
  geom_point(mapping = list(
    x = "x",
    y = "y",
    color = "group"
  ))
)
custom_plot$add_scale(
  scale_color_discrete("color", palette = palette_custom(custom_colors))
)
custom_plot$set_theme(theme_minimal())
custom_plot$plot()

# Example 5: Gradient Color Scale
time_series <- data.frame(
  time = seq(as.Date("2024-01-01"), as.Date("2024-12-31"), by = "day"),
  value = cumsum(rnorm(366)),
  temperature = sin(seq(0, 2*pi, length.out = 366)) * 10 + 20
)

gradient_plot <- Plot$new(time_series)
gradient_plot$add_layer(
  geom_point(mapping = list(
    x = "as.numeric(time)",
    y = "value",
    color = "temperature"
  ))
)
gradient_plot$add_scale(
  scale_color_continuous(
    "color",
    palette = palette_custom(c("#313695", "#FFFFE5", "#A50026"))
  )
)
gradient_plot$set_theme(theme_minimal())
gradient_plot$plot()