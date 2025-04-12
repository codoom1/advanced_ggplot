test_that("Point geometry works", {
  test_data <- data.frame(x = 1:3, y = 1:3)
  p <- Plot$new(test_data)
  point_layer <- geom_point(mapping = list(x = "x", y = "y"))
  
  expect_s3_class(point_layer, "R6")
  expect_true(inherits(point_layer, "GeomPoint"))
  p$add_layer(point_layer)
  expect_length(p$layers, 1)
})

test_that("Line geometry works", {
  test_data <- data.frame(x = 1:3, y = 1:3)
  p <- Plot$new(test_data)
  line_layer <- geom_line(mapping = list(x = "x", y = "y"))
  
  expect_s3_class(line_layer, "R6")
  expect_true(inherits(line_layer, "GeomLine"))
  p$add_layer(line_layer)
  expect_length(p$layers, 1)
})

test_that("Bar geometry works", {
  test_data <- data.frame(
    category = c("A", "B", "C"),
    value = c(1, 2, 3)
  )
  p <- Plot$new(test_data)
  bar_layer <- geom_bar(mapping = list(x = "category", y = "value"))
  
  expect_s3_class(bar_layer, "R6")
  expect_true(inherits(bar_layer, "GeomBar"))
  p$add_layer(bar_layer)
  expect_length(p$layers, 1)
})

test_that("Themes can be applied to plots", {
  p <- Plot$new()
  dark_theme <- theme_dark()
  
  expect_s3_class(dark_theme, "R6")
  expect_true(inherits(dark_theme, "Theme"))
  
  p$set_theme(dark_theme)
  expect_identical(p$theme, dark_theme)
})

test_that("Custom theme elements are set correctly", {
  custom_theme <- theme(
    plot.background = list(fill = "red"),
    axis.line = list(color = "blue", size = 2)
  )
  
  expect_s3_class(custom_theme, "R6")
  expect_equal(custom_theme$plot.background$fill, "red")
  expect_equal(custom_theme$axis.line$color, "blue")
  expect_equal(custom_theme$axis.line$size, 2)
})