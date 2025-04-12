context("Boxplot Geometry")

test_that("geom_boxplot creates the correct structure", {
  # Test that the function returns the expected class
  boxplot_layer <- geom_boxplot()
  expect_is(boxplot_layer, "GeomBoxplot")
  expect_is(boxplot_layer, "Layer")
  
  # Test that it has the correct stat
  expect_is(boxplot_layer$stat, "StatBoxplot")
  
  # Test with explicit parameters
  boxplot_layer2 <- geom_boxplot(mapping = list(x = "category", y = "value", fill = "blue"), width = 0.5)
  expect_equal(boxplot_layer2$mapping$x, "category")
  expect_equal(boxplot_layer2$mapping$y, "value")
  expect_equal(boxplot_layer2$mapping$fill, "blue")
  expect_equal(boxplot_layer2$mapping$width, 0.5)
})

test_that("StatBoxplot computes correct values", {
  # Create sample data
  test_data <- data.frame(
    group = rep(c("A", "B"), each = 5),
    x = rep(c(1, 2), each = 5),
    y = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
  )
  
  # Compute boxplot stats
  stat <- StatBoxplot$new()
  result <- stat$compute(test_data)
  
  # Test structure
  expect_is(result, "data.frame")
  expect_true(all(c("x", "group", "ymin", "lower", "middle", "upper", "ymax", "outliers") %in% names(result)))
  
  # Test values for group A
  group_a <- result[result$group == "A", ]
  expect_equal(group_a$x, 1)
  expect_equal(group_a$ymin, 1)
  expect_equal(group_a$lower, 1.5)
  expect_equal(group_a$middle, 3)
  expect_equal(group_a$upper, 4.5)
  expect_equal(group_a$ymax, 5)
  
  # Test values for group B
  group_b <- result[result$group == "B", ]
  expect_equal(group_b$x, 2)
  expect_equal(group_b$ymin, 6)
  expect_equal(group_b$lower, 6.5)
  expect_equal(group_b$middle, 8)
  expect_equal(group_b$upper, 9.5)
  expect_equal(group_b$ymax, 10)
})

test_that("Boxplot handles outliers correctly", {
  # Create sample data with outliers
  test_data <- data.frame(
    group = rep("A", 10),
    x = rep(1, 10),
    y = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 20)  # 20 is an outlier
  )
  
  # Compute boxplot stats
  stat <- StatBoxplot$new()
  result <- stat$compute(test_data)
  
  # Test that outliers are detected
  expect_true(20 %in% unlist(result$outliers))
  expect_true(result$ymax < 20)  # Upper whisker should be less than the outlier value
})

test_that("Boxplot works with multiple groups", {
  # Create data with multiple groups
  test_data <- data.frame(
    group = c(rep("A", 5), rep("B", 5), rep("C", 5)),
    x = c(rep(1, 5), rep(2, 5), rep(3, 5)),
    y = c(1:5, 6:10, 11:15)
  )
  
  # Compute boxplot stats
  stat <- StatBoxplot$new()
  result <- stat$compute(test_data)
  
  # Check that we have three groups
  expect_equal(nrow(result), 3)
  expect_equal(sort(unique(result$group)), c("A", "B", "C"))
  expect_equal(sort(unique(result$x)), c(1, 2, 3))
}) 