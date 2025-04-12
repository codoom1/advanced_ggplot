# Examples demonstrating faceting capabilities

# Example 1: Grid Faceting with Multiple Variables
set.seed(123)
experiment_data <- data.frame(
  treatment = rep(c("Control", "Treatment A", "Treatment B"), each = 200),
  time = rep(1:50, times = 12),
  response = rnorm(600),
  batch = rep(rep(c("Batch 1", "Batch 2", "Batch 3", "Batch 4"), each = 50), 3)
)

# Create plot with grid faceting
grid_plot <- Plot$new(experiment_data)

# Add points and trend line
grid_plot$add_layer(
  geom_point(mapping = list(
    x = "time",
    y = "response",
    color = "treatment"
  ))
)
grid_plot$add_layer(
  geom_smooth(mapping = list(
    x = "time",
    y = "response",
    color = "treatment"
  ))
)

# Add faceting
grid_plot$set_facet(
  facet_grid(
    rows = "batch",
    cols = "treatment",
    scales = "free_y"
  )
)

grid_plot$set_theme(theme_minimal())
grid_plot$plot()

# Example 2: Wrapped Faceting with Different Scales
set.seed(456)
species_data <- data.frame(
  species = rep(letters[1:6], each = 100),
  measurement1 = c(
    rnorm(100, 10, 2),
    rnorm(100, 15, 3),
    rnorm(100, 8, 1),
    rnorm(100, 12, 2),
    rnorm(100, 20, 4),
    rnorm(100, 9, 1.5)
  ),
  measurement2 = c(
    rnorm(100, 5, 1),
    rnorm(100, 8, 2),
    rnorm(100, 4, 0.5),
    rnorm(100, 6, 1),
    rnorm(100, 10, 2),
    rnorm(100, 5, 1)
  )
)

# Create density plot with wrapped faceting
wrap_plot <- Plot$new(species_data)

# Add density curves
wrap_plot$add_layer(
  geom_density(mapping = list(
    x = "measurement1",
    fill = "species",
    alpha = 0.5
  ))
)

# Add faceting
wrap_plot$set_facet(
  facet_wrap(
    facets = "species",
    ncol = 3,
    scales = "free"
  )
)

wrap_plot$set_theme(theme_minimal())
wrap_plot$plot()

# Example 3: Complex Grid Faceting with Multiple Layers
set.seed(789)
weather_data <- data.frame(
  month = rep(1:12, 4),
  year = rep(2021:2024, each = 12),
  temperature = rnorm(48, mean = 15, sd = 5) + sin(seq(0, 4*pi, length.out = 48)) * 10,
  rainfall = exp(rnorm(48, 1, 0.5)),
  region = rep(c("North", "South"), each = 24)
)

# Create multi-layer plot with grid faceting
weather_plot <- Plot$new(weather_data)

# Add temperature line
weather_plot$add_layer(
  geom_line(mapping = list(
    x = "month",
    y = "temperature",
    color = "'steelblue'"
  ))
)

# Add rainfall bars
weather_plot$add_layer(
  geom_bar(mapping = list(
    x = "month",
    y = "rainfall",
    fill = "'lightblue'",
    alpha = 0.3
  ))
)

# Add faceting by year and region
weather_plot$set_facet(
  facet_grid(
    rows = "year",
    cols = "region",
    scales = "free_y"
  )
)

weather_plot$set_theme(theme_minimal())
weather_plot$plot()

# Example 4: Wrapped Faceting with Different Geometries
set.seed(101)
performance_data <- data.frame(
  metric = rep(c("Speed", "Accuracy", "Efficiency", "Quality"), each = 100),
  value = c(
    rnorm(100, 75, 10),
    rbeta(100, 8, 2) * 100,
    rexp(100, 1/80),
    rnorm(100, 85, 5)
  ),
  category = rep(rep(c("A", "B", "C", "D"), each = 25), 4)
)

# Create plot with different geometries for each facet
mixed_plot <- Plot$new(performance_data)

# Add multiple geometries that will appear differently based on the metric
mixed_plot$add_layer(
  geom_density(mapping = list(
    x = "value",
    fill = "category",
    alpha = 0.5
  ))
)

mixed_plot$add_layer(
  geom_point(mapping = list(
    x = "value",
    y = "..density..",
    color = "category",
    alpha = 0.5
  ))
)

# Add faceting
mixed_plot$set_facet(
  facet_wrap(
    facets = "metric",
    scales = "free"
  )
)

mixed_plot$set_theme(theme_minimal())
mixed_plot$plot()