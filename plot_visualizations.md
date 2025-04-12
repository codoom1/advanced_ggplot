# Advanced_ggplot Visualizations

This document shows examples of the visualizations that can be created with the Advanced_ggplot package, with a focus on the statistical visualization features including the newly implemented violin plots.

## Basic Violin Plot

A violin plot shows the distribution of data across different categories. The width of each "violin" represents the density of data at that value.

```
    ▄▄▄      
   ▄███▄               ▄▄▄▄        
   █████▄             ▄█████       
   ██████             ██████       
   ██████            ███████       
  ███████▄          ████████       
  ████████         ▄████████       
  ████████         █████████       
  ████████         █████████       
  ████████        ██████████    ▄▄▄▄▄
  ████████        ██████████▄   ██████
  ████████       ███████████▄  ███████
  ████████       ████████████  ███████
  ████████       ████████████  ███████
  ████████▄▄    ▄████████████▄ ███████▄
  ██████████    █████████████▄ ████████
  ██████████    ██████████████ ████████
   ████████▄   ▄█████████████▄ ████████▄
   ████████▄   █████████████▄  █████████
    ████████   ████████████▄   █████████
     ███████   ████████████    █████████
      ██████   ███████████     █████████
       ▀████   ██████████      ██████▀▀▀
         ▀▀▀   ▀▀▀▀▀▀▀▀▀       ▀▀▀▀▀    
         
    Normal    Right-skewed     Bimodal    Left-skewed
```

Code to create this visualization:

```r
plot <- AGPlot$new(stat_data)
plot$add_layer(geom_violin(mapping = list(
  x = "distribution", 
  y = "value",
  fill = "lightgreen",
  color = "darkgreen",
  alpha = 0.7
)))
plot$plot()
```

## Combined Boxplot and Violin Plot

Combining boxplots with violin plots provides both the distribution shape (from the violin) and the summary statistics (from the boxplot).

```
    ▄▄▄      
   ▄███▄               ▄▄▄▄        
   █████▄             ▄█████       
   ██████             ██████       
   ██████            ███████       
  ███████▄    │      ████████       
  ████████    ┬      ▄████████       
  ████████    │      █████████       
  ████████   ┌┴┐     █████████       
  ████████   │ │     ██████████    ▄▄▄▄▄
  ████████   │ │     ██████████▄   ██████
  ████████   │ │     ███████████▄  ███████
  ████████   │ │     ████████████  ███████
  ████████   │ │     ████████████  ███████
  ████████▄▄ │ │    ▄████████████▄ ███████▄
  ██████████ │ │    █████████████▄ ████████
  ██████████ │ │    ██████████████ ████████
   ████████▄ │ │   ▄█████████████▄ ████████▄
   ████████▄ │ │   █████████████▄  █████████
    ████████ └─┘   ████████████▄   █████████
     ███████   │   ████████████    █████████
      ██████   ┴   ███████████     █████████
       ▀████       ██████████      ██████▀▀▀
         ▀▀▀       ▀▀▀▀▀▀▀▀▀       ▀▀▀▀▀    
         
    Normal    Right-skewed     Bimodal    Left-skewed
```

Code to create this visualization:

```r
plot <- AGPlot$new(stat_data)
plot$add_layer(geom_violin(mapping = list(
  x = "distribution", 
  y = "value",
  fill = "lightgreen",
  alpha = 0.5,
  width = 0.9
)))
plot$add_layer(geom_boxplot(mapping = list(
  x = "distribution", 
  y = "value",
  fill = "white",
  alpha = 0.7,
  width = 0.3
)))
plot$plot()
```

## Violin Plot Scaling Options

Advanced_ggplot offers different scaling options for violin plots:

### Area Scaling (Default)

In area scaling, each violin has the same total area regardless of the number of points.

```
     ▄▄▄▄▄         ▄▄▄▄▄          ▄▄▄▄▄
    ██████        ██████         ██████
    ██████        ██████         ██████
    ██████        ██████         ██████
    ██████        ██████         ██████
    ██████        ██████         ██████
    ██████        ██████         ██████
    
     Small         Medium         Large
   (20 points)    (50 points)   (100 points)
```

### Count Scaling

In count scaling, the width of the violin is proportional to the number of data points.

```
     ▄▄▄                ▄▄▄▄▄                 ▄▄▄▄▄▄▄
    ████              ██████                ███████████
    ████              ██████                ███████████
    ████              ██████                ███████████
    ████              ██████                ███████████
    ████              ██████                ███████████
    ████              ██████                ███████████
    
     Small             Medium                 Large
   (20 points)        (50 points)           (100 points)
```

Code to create these visualizations:

```r
# Area scaling
plot1 <- AGPlot$new(uneven_groups)
plot1$add_layer(geom_violin(mapping = list(
  x = "group", 
  y = "value",
  fill = "salmon",
  scale = "area"  # Default
)))
plot1$plot()

# Count scaling 
plot2 <- AGPlot$new(uneven_groups)
plot2$add_layer(geom_violin(mapping = list(
  x = "group", 
  y = "value",
  fill = "lightblue",
  scale = "count"
)))
plot2$plot()
```

## Faceted Violin Plots

Violin plots can be combined with faceting to compare distributions across multiple variables:

```
              Variable Y                     Variable Z
      ┌─────────────────────────┐    ┌─────────────────────────┐
      │   ▄▄▄    ▄▄▄▄▄   ▄▄▄    │    │  ▄▄▄▄▄  ▄▄▄▄   ▄▄▄▄▄▄   │
      │  █████  ██████  █████   │    │ ██████ █████  ███████   │
      │  █████  ██████  █████   │    │ ██████ █████  ███████   │
      │  █████  ██████  █████   │    │ ██████ █████  ███████   │
      │  █████  ██████  █████   │    │ ██████ █████  ███████   │
      │  █████  ██████  █████   │    │ ██████ █████  ███████   │
      │   ▀▀▀    ▀▀▀▀▀   ▀▀▀    │    │  ▀▀▀▀▀  ▀▀▀▀   ▀▀▀▀▀▀   │
      │                         │    │                         │
      │    A       B       C    │    │    A       B       C    │
      └─────────────────────────┘    └─────────────────────────┘
```

Code to create this visualization:

```r
long_data <- reshape2::melt(
  multi_var, 
  id.vars = "x", 
  variable.name = "variable", 
  value.name = "value"
)

plot <- AGPlot$new(long_data)
plot$add_layer(geom_violin(mapping = list(
  x = "x", 
  y = "value",
  fill = "skyblue"
)))
plot$set_facet(facet_wrap(formula = ~ variable, ncol = 2))
plot$plot()
```

## Benefits of Violin Plots

1. **Distribution Shape**: Unlike boxplots, violin plots show the full distribution shape, revealing features like:
   - Multimodality (multiple peaks)
   - Skewness
   - Unusual distribution shapes

2. **Comparison**: Effectively compare distributions across groups

3. **Complementary to Boxplots**: When combined with boxplots, they provide both detailed distribution information and summary statistics

4. **Flexibility**: Various scaling options make them adaptable to different data scenarios

The Advanced_ggplot package implementation provides a clean, object-oriented interface for creating these visualizations with full customization capabilities. 