context("Violin Plot Geometry")

test_that("geom_violin creates the correct structure", {
  # Test that the function returns the expected class
  violin_layer <- geom_violin()
  expect_is(violin_layer, "GeomViolin")
  expect_is(violin_layer, "Layer")
  
  # Test that it has the correct stat
  expect_is(violin_layer$stat, "StatViolin")
  
  # Test with explicit parameters
  violin_layer2 <- geom_violin(
    mapping = list(x = "category", y = "value", fill = "blue"), 
    width = 0.5,
    scale = "count"
  )
  expect_equal(violin_layer2$mapping$x, "category")
  expect_equal(violin_layer2$mapping$y, "value")
  expect_equal(violin_layer2$mapping$fill, "blue")
  expect_equal(violin_layer2$mapping$width, 0.5)
  expect_equal(violin_layer2$mapping$scale, "count")
})

test_that("StatViolin computes correct values", {
  # Create sample data
  set.seed(123) # For reproducibility
  test_data <- data.frame(
    group = rep(c("A", "B"), each = 100),
    x = rep(c(1, 2), each = 100),
    y = c(rnorm(100, mean = 0, sd = 1), rnorm(100, mean = 2, sd = 1.5))
  )
  
  # Compute violin stats
  stat <- StatViolin$new()
  result <- stat$compute(test_data, scale = "area", width = 1.0)
  
  # Test structure
  expect_is(result, "data.frame")
  expect_true(all(c("x", "y", "density", "scaled", "group") %in% names(result)))
  
  # Test that we have density values for each group
  expect_true(nrow(result[result$group == "A", ]) > 0)
  expect_true(nrow(result[result$group == "B", ]) > 0)
  
  # Test basic properties
  group_a <- result[result$group == "A", ]
  expect_equal(unique(group_a$x), 1)
  expect_true(all(group_a$density >= 0))
  
  group_b <- result[result$group == "B", ]
  expect_equal(unique(group_b$x), 2)
  expect_true(all(group_b$density >= 0))
})

test_that("StatViolin scaling options work correctly", {
  # Create sample data
  set.seed(123) # For reproducibility
  test_data <- data.frame(
    group = rep("A", 50),
    x = rep(1, 50),
    y = rnorm(50)
  )
  
  # Compute with different scaling options
  stat <- StatViolin$new()
  
  area_scaling <- stat$compute(test_data, scale = "area", width = 1.0)
  count_scaling <- stat$compute(test_data, scale = "count", width = 1.0)
  width_scaling <- stat$compute(test_data, scale = "width", width = 1.0)
  
  # Check area scaling (total area should be normalized)
  expect_true(all(area_scaling$density >= 0))
  
  # Check count scaling (should scale by number of points)
  expect_true(all(count_scaling$density >= 0))
  
  # Check that the scaling options produce different results
  expect_false(identical(area_scaling$density, count_scaling$density))
  expect_false(identical(area_scaling$density, width_scaling$density))
}) 