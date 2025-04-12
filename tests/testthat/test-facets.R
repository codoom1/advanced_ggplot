test_that("Facet grid works with single variable", {
  test_data <- data.frame(
    x = 1:4,
    y = 1:4,
    group = c("A", "A", "B", "B")
  )
  p <- Plot$new(test_data)
  facet <- facet_grid("group")
  
  expect_s3_class(facet, "R6")
  expect_true(inherits(facet, "FacetGrid"))
  
  p$set_facet(facet)
  expect_identical(p$facet, facet)
  
  # Test data splitting
  splits <- facet$split_data(test_data)
  expect_length(splits, 2)  # Should have 2 groups: A and B
  expect_equal(nrow(splits$A), 2)
  expect_equal(nrow(splits$B), 2)
})

test_that("Facet grid works with multiple variables", {
  test_data <- data.frame(
    x = 1:8,
    y = 1:8,
    group1 = rep(c("A", "B"), each = 4),
    group2 = rep(c("X", "Y"), times = 4)
  )
  
  facet <- facet_grid(c("group1", "group2"))
  expect_s3_class(facet, "R6")
  
  # Test data splitting with two variables
  splits <- facet$split_data(test_data)
  expect_length(splits, 4)  # Should have 4 combinations
})