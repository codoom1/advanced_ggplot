# Basic plotting examples using Advanced_ggplot

# Generate some sample data
x <- seq(0, 2*pi, length.out = 100)
data <- data.frame(
  x = x,
  sin = sin(x),
  cos = cos(x)
)

# Create a plot with both sine and cosine curves
plot <- Plot$new(data)

# Add sine curve in red
plot$add_layer(
  geom_line(mapping = list(
    x = "x",
    y = "sin",
    color = "red"
  ))
)

# Add points for sine curve
plot$add_layer(
  geom_point(mapping = list(
    x = "x",
    y = "sin",
    color = "darkred",
    size = unit(1.5, "mm")
  ))
)

# Add cosine curve in blue
plot$add_layer(
  geom_line(mapping = list(
    x = "x",
    y = "cos",
    color = "blue"
  ))
)

# Add points for cosine curve
plot$add_layer(
  geom_point(mapping = list(
    x = "x",
    y = "cos",
    color = "darkblue",
    size = unit(1.5, "mm")
  ))
)

# Display the plot
plot$plot()