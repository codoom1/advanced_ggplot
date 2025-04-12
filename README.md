# Advanced_ggplot

A modern and flexible data visualization package for R, designed to provide an alternative to ggplot2 with a clean, composable API and object-oriented design.

## Features

- Modular, object-oriented design using R6 classes
- Composable layers for building complex visualizations
- Flexible aesthetic mapping system
- Support for multiple geometry types:
  - Points, lines, bars, histograms
  - Area, density, ribbons, contours
  - Smoothing with confidence intervals
  - Statistical visualizations (boxplots, violin plots)
- Advanced features:
  - Faceting for multi-panel plots
  - Theming system for customizing plot appearance
  - Coordinate systems for different data projections
  - Annotations for adding context to visualizations
  - Interactive elements for dynamic visualization
  - Animation capabilities for temporal data

## Installation

```R
# Install from GitHub
# install.packages("devtools")
devtools::install_github("christopherodoom/Advanced_ggplot")
```

## Usage Examples

### Basic Plot

```R
library(Advanced_ggplot)

# Create sample data
data <- data.frame(
  x = 1:10,
  y = sin(1:10),
  z = cos(1:10)
)

# Create a simple scatter plot
plot <- Plot$new(data)
plot$add_layer(geom_point(mapping = list(x = "x", y = "y", color = "blue")))
plot$plot()
```

### Combined Geometries

```R
# Combine multiple geometries
plot <- Plot$new(data)
plot$add_layer(geom_point(mapping = list(x = "x", y = "y", color = "blue")))
plot$add_layer(geom_line(mapping = list(x = "x", y = "y", color = "blue")))
plot$add_layer(geom_point(mapping = list(x = "x", y = "z", color = "red")))
plot$add_layer(geom_line(mapping = list(x = "x", y = "z", color = "red")))
plot$plot()
```

### Customizing with Themes and Annotations

```R
# Create a more advanced plot with custom theme and annotations
plot <- Plot$new(data)
plot$add_layer(geom_line(mapping = list(x = "x", y = "y", color = "blue")))
plot$add_layer(geom_smooth(mapping = list(x = "x", y = "y")))
plot$set_theme(theme_dark())
plot$add_annotation(annotation_text(x = 5, y = 0.5, label = "Peak"))
plot$plot()
```

### Statistical Visualization with Boxplots

```R
# Create data for boxplot example
categories <- rep(c("A", "B", "C", "D"), each = 30)
values <- c(
  rnorm(30, mean = 5, sd = 1),   # Category A
  rnorm(30, mean = 7, sd = 1.5), # Category B
  rnorm(30, mean = 4, sd = 0.8), # Category C
  rnorm(30, mean = 6, sd = 2)    # Category D
)
box_data <- data.frame(category = categories, value = values)

# Create a boxplot
plot <- Plot$new(box_data)
plot$add_layer(geom_boxplot(mapping = list(
  x = "category", 
  y = "value",
  fill = "lightblue",
  color = "navy"
)))
plot$plot()
```

### Violin Plots for Distribution Visualization

```R
# Using the same data as the boxplot example
plot <- Plot$new(box_data)
plot$add_layer(geom_violin(mapping = list(
  x = "category", 
  y = "value",
  fill = "lightgreen",
  color = "darkgreen",
  alpha = 0.7
)))
plot$plot()

# Combining boxplots and violin plots
plot <- Plot$new(box_data)
plot$add_layer(geom_violin(mapping = list(
  x = "category", 
  y = "value",
  fill = "lightgreen",
  alpha = 0.5
)))
plot$add_layer(geom_boxplot(mapping = list(
  x = "category", 
  y = "value",
  width = 0.3
)))
plot$plot()
```

### Faceted Plots

```R
# Create a faceted plot
long_data <- reshape2::melt(data, id.vars = "x", variable.name = "series", value.name = "value")
plot <- Plot$new(long_data)
plot$add_layer(geom_line(mapping = list(x = "x", y = "value", color = "series")))
plot$set_facet(facet_wrap(formula = ~ series, ncol = 2))
plot$plot()
```

## Roadmap

- Additional statistical visualizations
- Geographic mapping support
- Interactive web export
- Enhanced theming capabilities
- Performance optimizations for large datasets

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

Areas we're particularly interested in:
- New geometry types
- Enhanced documentation and examples
- Performance improvements
- Test coverage expansion

## License

This project is licensed under the MIT License - see the LICENSE file for details.