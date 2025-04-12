# Contributing to Advanced_ggplot

Thank you for considering contributing to Advanced_ggplot! This document outlines the process for contributing to the package.

## Code of Conduct

Please note that this project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.

## How to Contribute

### Reporting Issues

- Check if the issue has already been reported
- Use the issue template to provide all necessary information
- Include a minimal reproducible example if possible

### Pull Requests

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Run tests and make sure they pass
5. Commit your changes (`git commit -m 'Add some amazing feature'`)
6. Push to the branch (`git push origin feature/amazing-feature`)
7. Open a Pull Request

## Development Workflow

### Setting up the Development Environment

```r
# Install development dependencies
install.packages(c("devtools", "roxygen2", "testthat", "knitr", "rmarkdown"))

# Install package in development mode
devtools::install_dev()
```

### Testing

```r
# Run tests
devtools::test()

# Check package
devtools::check()
```

### Documentation

- Use roxygen2 for documentation
- Update vignettes if relevant
- Run `devtools::document()` to generate documentation

## Style Guide

- Follow the tidyverse style guide
- Use meaningful variable and function names
- Document all functions with roxygen2
- Write tests for new functions

## Feature Requests

We welcome feature requests! Please submit them as issues in the GitHub repository, clearly describing the feature and its potential benefits.

## Questions?

If you have any questions, feel free to open an issue or reach out to the maintainer directly. 