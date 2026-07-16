test_that(".build_format_lines emits nothing when all options are unset", {
  opts <- setNames(vector("list", length(.format_option_names)),
                   .format_option_names)
  expect_length(.build_format_lines(opts), 0)
})

test_that(".build_format_lines emits only the options that are set", {
  lines <- .build_format_lines(list(toc = TRUE, toc_depth = 3))
  expect_equal(lines, c("      toc: true", "      toc-depth: 3"))
})

test_that("self_contained expands to embed-resources and self-contained", {
  lines <- .build_format_lines(list(self_contained = TRUE))
  expect_true(any(grepl("embed-resources: true", lines, fixed = TRUE)))
  expect_true(any(grepl("self-contained: true", lines, fixed = TRUE)))
})

test_that("execute-level options are nested under execute:", {
  lines <- .build_format_lines(list(warning = FALSE, fig_width = 8))
  expect_true(any(grepl("^      execute:$", lines)))
  expect_true(any(grepl("^        warning: false$", lines)))
  expect_true(any(grepl("^        fig-width: 8$", lines)))
})

test_that("logical flags render as lowercase yaml booleans", {
  expect_equal(.build_format_lines(list(code_fold = FALSE)),
               "      code-fold: false")
  expect_equal(.build_format_lines(list(code_fold = TRUE)),
               "      code-fold: true")
})

test_that(".validate_format_options rejects bad types", {
  expect_error(.validate_format_options(list(toc = "yes")),
               "TRUE, FALSE")
  expect_error(.validate_format_options(list(toc = NA)),
               "TRUE, FALSE")
  expect_error(.validate_format_options(list(toc_depth = "deep")),
               "single number")
  expect_error(.validate_format_options(list(highlight_style = 1)),
               "single string")
})

test_that(".validate_format_options accepts NULLs and valid values", {
  expect_silent(.validate_format_options(list(toc = NULL, toc_depth = NULL)))
  expect_silent(
    .validate_format_options(
      list(toc = TRUE, toc_depth = 3, highlight_style = "github", fig_width = 8)
    )
  )
})
