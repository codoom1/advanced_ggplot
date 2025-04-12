# This script generates example plots to demonstrate what Advanced_ggplot plots will look like
# We'll use base R graphics to approximate the appearance

# Create pdf output file
pdf("example_plots.pdf", width=8, height=10)

# Set layout for multiple plots per page
par(mfrow=c(2,2), mar=c(4, 4, 3, 1))

# ---- Sample Data ----
set.seed(123)

# Regular data
x <- 1:20
y1 <- sin(x/2) + rnorm(20, sd=0.1)
y2 <- cos(x/2) + rnorm(20, sd=0.1)

# Categorical data
categories <- factor(rep(c("A", "B", "C", "D"), each=50))
values <- c(
  rnorm(50, mean=5, sd=1),   # A
  rnorm(50, mean=7, sd=1.5), # B
  rnorm(50, mean=4, sd=0.8), # C
  rnorm(50, mean=6, sd=2)    # D
)

# Skewed data
right_skewed <- exp(rnorm(100, mean=0, sd=0.5)) + 3
left_skewed <- 10 - exp(rnorm(100, mean=0, sd=0.5))

# Bimodal data
bimodal <- c(rnorm(50, mean=3, sd=0.5), rnorm(50, mean=6, sd=0.5))

# ---- Plot 1: Line and Points (Similar to geom_line and geom_point) ----
plot(x, y1, type="l", col="blue", lwd=2, 
     main="Line and Points\n(geom_line and geom_point)",
     xlab="x", ylab="y")
points(x, y2, col="red", pch=16)
lines(x, y2, col="red", lty=2)

legend("topright", 
       legend=c("Series 1", "Series 2"),
       col=c("blue", "red"), 
       lty=c(1, 2),
       pch=c(NA, 16))

# ---- Plot 2: Boxplot (Similar to geom_boxplot) ----
boxplot(values ~ categories, 
        main="Boxplot\n(geom_boxplot)",
        xlab="Category", ylab="Value",
        col=c("lightblue", "pink", "lightgreen", "lightyellow"),
        border=c("blue", "red", "darkgreen", "orange"))

# ---- Plot 3: Violin Plot (Similar to geom_violin) ----
# Custom function to draw a simple violin plot
simple_violin <- function(x, at, width=0.3, col="gray", border="black") {
  dens <- density(x)
  xs <- dens$x
  ys <- dens$y / max(dens$y) * width  # Scale to desired width
  
  # Draw left side
  polygon(c(at - ys, rev(at - ys/5)), 
          c(xs, rev(xs)), 
          col=col, border=border)
  
  # Draw right side
  polygon(c(at + ys/5, rev(at + ys)), 
          c(xs, rev(xs)), 
          col=col, border=border)
}

# Empty plot with the right dimensions
plot(1, type="n", 
     xlim=c(0.5, 4.5), 
     ylim=range(values),
     main="Violin Plot\n(geom_violin)",
     xlab="Category", ylab="Value",
     xaxt="n")
axis(1, at=1:4, labels=levels(categories))

# Draw violins
simple_violin(values[categories=="A"], at=1, col="lightgreen", border="darkgreen")
simple_violin(values[categories=="B"], at=2, col="lightblue", border="blue")
simple_violin(values[categories=="C"], at=3, col="pink", border="red")
simple_violin(values[categories=="D"], at=4, col="lightyellow", border="orange")

# ---- Plot 4: Combined Violin and Boxplot ----
# Empty plot with the right dimensions
plot(1, type="n", 
     xlim=c(0.5, 4.5), 
     ylim=range(values),
     main="Combined Violin and Boxplot\n(geom_violin + geom_boxplot)",
     xlab="Category", ylab="Value",
     xaxt="n")
axis(1, at=1:4, labels=levels(categories))

# Draw violins
simple_violin(values[categories=="A"], at=1, col=adjustcolor("lightgreen", alpha.f=0.5), border="darkgreen")
simple_violin(values[categories=="B"], at=2, col=adjustcolor("lightblue", alpha.f=0.5), border="blue")
simple_violin(values[categories=="C"], at=3, col=adjustcolor("pink", alpha.f=0.5), border="red")
simple_violin(values[categories=="D"], at=4, col=adjustcolor("lightyellow", alpha.f=0.5), border="orange")

# Add boxplots on top
boxplot(values ~ categories, add=TRUE, at=1:4, 
        boxwex=0.2, # Narrower boxes
        col="white", 
        border=c("darkgreen", "blue", "red", "orange"),
        outline=FALSE) # Don't show outliers twice

# Reset to single plot for next page
par(mfrow=c(1,1))

# ---- Plot 5: Different Distribution Shapes with Violin Plots ----
plot(1, type="n", 
     xlim=c(0.5, 4.5), 
     ylim=c(0, 10),
     main="Distribution Comparison with Violin Plots",
     xlab="Distribution Type", ylab="Value",
     xaxt="n")
axis(1, at=1:4, labels=c("Normal", "Right Skewed", "Left Skewed", "Bimodal"))

# Draw violins for different distributions
simple_violin(rnorm(100, mean=5, sd=1), at=1, width=0.5, col="lightblue", border="blue")
simple_violin(right_skewed, at=2, width=0.5, col="pink", border="red")
simple_violin(left_skewed, at=3, width=0.5, col="lightgreen", border="darkgreen")
simple_violin(bimodal, at=4, width=0.5, col="lightyellow", border="orange")

# Add a note about the real package
mtext("Note: These are simplified approximations. The actual Advanced_ggplot package\nprovides more sophisticated and customizable visualizations.", side=1, line=4, cex=0.8)

# Close the PDF file
dev.off()

cat("Example plots have been saved to 'example_plots.pdf'\n")

library(Advanced_ggplot)

# Create a violin plot
plot <- AGPlot$new(data)
plot$add_layer(geom_violin(mapping = list(
  x = "category", 
  y = "value",
  fill = "lightgreen"
)))
plot$plot() 