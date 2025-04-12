# Examples demonstrating animation capabilities

# Example 1: Animated Transition Between States
# Create data for population pyramids
create_pyramid_data <- function(year, total_pop) {
  data.frame(
    age_group = rep(seq(0, 80, by = 10), 2),
    gender = rep(c("Male", "Female"), each = 9),
    population = total_pop * (1 - abs(seq(-0.8, 0.8, length.out = 18))) + 
                 rnorm(18, 0, total_pop * 0.05),
    year = year
  )
}

# Create population data for multiple years
years <- 2000:2020
population_states <- lapply(years, function(year) {
  create_pyramid_data(year, 1000000 * (1 + (year - 2000) * 0.02))
})

# Create animated population pyramid
pyramid_plot <- Plot$new(population_states[[1]])
pyramid_plot$add_layer(
  geom_bar(mapping = list(
    x = "age_group",
    y = "population",
    fill = "gender"
  ),
  position = position_dodge())
)

# Add transition animation
pyramid_plot$add_animation(
  animate_transition(
    states = population_states[-1],
    duration = 5000
  )
)

pyramid_plot$set_theme(theme_minimal())
pyramid_plot$plot()

# Example 2: Time Series Animation with Moving Window
# Create stock price data
set.seed(123)
n_days <- 365
dates <- seq(as.Date("2024-01-01"), by = "day", length.out = n_days)
price <- cumsum(rnorm(n_days, 0, 1)) + 100
volume <- exp(rnorm(n_days, 10, 0.5))

stock_data <- data.frame(
  date = dates,
  price = price,
  volume = volume,
  ma_50 = stats::filter(price, rep(1/50, 50), sides = 1)
)

# Create animated stock chart
stock_plot <- Plot$new(stock_data)

# Add price line and volume bars
stock_plot$add_layer(
  geom_line(mapping = list(
    x = "date",
    y = "price",
    color = "'steelblue'"
  ))
)
stock_plot$add_layer(
  geom_line(mapping = list(
    x = "date",
    y = "ma_50",
    color = "'red'",
    linetype = "'dashed'"
  ))
)
stock_plot$add_layer(
  geom_bar(mapping = list(
    x = "date",
    y = "volume",
    alpha = 0.3,
    fill = "'gray'"
  ))
)

# Add time series animation with 90-day window
stock_plot$add_animation(
  animate_time_series(
    time_column = "date",
    window_size = 90,
    duration = 10000
  )
)

stock_plot$set_theme(theme_minimal())
stock_plot$plot()

# Example 3: Animated Scatter Plot Transition
# Create cluster data
create_cluster_data <- function(n_points, centers, sds) {
  data <- data.frame()
  for (i in seq_along(centers$x)) {
    cluster <- data.frame(
      x = rnorm(n_points, centers$x[i], sds$x[i]),
      y = rnorm(n_points, centers$y[i], sds$y[i]),
      cluster = paste("Cluster", i)
    )
    data <- rbind(data, cluster)
  }
  data
}

# Create different cluster states
initial_centers <- list(
  x = c(0, 5, -5),
  y = c(0, 0, 0)
)
initial_sds <- list(
  x = c(1, 1, 1),
  y = c(1, 1, 1)
)

final_centers <- list(
  x = c(-2, 2, 0),
  y = c(-2, -2, 2)
)
final_sds <- list(
  x = c(0.5, 0.5, 0.5),
  y = c(0.5, 0.5, 0.5)
)

cluster_states <- list(
  create_cluster_data(100, initial_centers, initial_sds),
  create_cluster_data(100, final_centers, final_sds)
)

# Create animated scatter plot
cluster_plot <- Plot$new(cluster_states[[1]])
cluster_plot$add_layer(
  geom_point(mapping = list(
    x = "x",
    y = "y",
    color = "cluster",
    alpha = 0.6
  ))
)

# Add transition animation
cluster_plot$add_animation(
  animate_transition(
    states = cluster_states[-1],
    duration = 3000,
    easing = "cubic-in-out"
  )
)

cluster_plot$set_theme(theme_minimal())
cluster_plot$plot()

# Example 4: Animated Bar Chart Race
# Create data for changing rankings
n_categories <- 10
n_timepoints <- 20
categories <- LETTERS[1:n_categories]

ranking_data <- data.frame()
for (t in 1:n_timepoints) {
  values <- sort(runif(n_categories, 0, 100) * (1 + t/10), decreasing = TRUE)
  frame <- data.frame(
    category = categories,
    value = values,
    time = t
  )
  ranking_data <- rbind(ranking_data, frame)
}

# Create animated bar chart race
race_plot <- Plot$new(ranking_data)
race_plot$add_layer(
  geom_bar(mapping = list(
    x = "reorder(category, -value)",
    y = "value",
    fill = "category"
  ))
)

# Add time series animation
race_plot$add_animation(
  animate_time_series(
    time_column = "time",
    duration = 8000
  )
)

# Customize appearance
race_plot$set_theme(theme_minimal())
race_plot$add_scale(
  scale_color_discrete(
    aesthetic = "fill",
    palette = palette_qualitative()
  )
)
race_plot$plot()