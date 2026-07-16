# A minimal valid 1x1 PNG for logo tests
local_png <- function(dir) {
  png_path <- file.path(dir, "logo.png")
  png_bytes <- as.raw(c(
    0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D,
    0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
    0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00,
    0x0D, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0x63, 0x64, 0x60, 0x60, 0x60,
    0x00, 0x00, 0x00, 0x05, 0x00, 0x01, 0xA5, 0xF6, 0x45, 0x40, 0x00, 0x00,
    0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82
  ))
  writeBin(png_bytes, png_path)
  png_path
}

local_project <- function(env = parent.frame()) {
  dir <- tempfile("usedepartmenttheme-test-")
  dir.create(dir)
  withr::defer(unlink(dir, recursive = TRUE), envir = env)
  dir
}

# A tiny SVG, used where we need a favicon that is visibly distinct from the
# PNG logo (different MIME type in the emitted data URI).
local_svg <- function(dir, name = "favicon.svg") {
  svg_path <- file.path(dir, name)
  writeLines(
    '<svg xmlns="http://www.w3.org/2000/svg" width="1" height="1"></svg>',
    svg_path
  )
  svg_path
}

test_that("custom() installs a complete extension", {
  skip_if_not_installed("withr")
  dir  <- local_project()
  logo <- local_png(dir)

  res <- suppressMessages(
    custom(colour = "#003865", logo = logo, name = "My Lab", path = dir)
  )

  ext <- file.path(dir, "_extensions", "my-lab")
  expect_equal(normalizePath(as.character(res)), normalizePath(ext))
  expect_true(dir.exists(ext))
  expect_true(file.exists(file.path(ext, "_extension.yml")))
  expect_true(file.exists(file.path(ext, "resources", "theme.scss")))
  expect_true(file.exists(file.path(ext, "resources", "header.html")))
  expect_true(file.exists(file.path(ext, "resources", "favicon.html")))
  expect_true(file.exists(file.path(ext, "resources", "logo.png")))
  expect_true(file.exists(file.path(dir, "_quarto.yml")))

  # name/title injected into _extension.yml
  yml <- readLines(file.path(ext, "_extension.yml"), warn = FALSE)
  expect_true(any(grepl("^name: my-lab$", yml)))
  expect_true(any(grepl("My Lab HTML Format", yml, fixed = TRUE)))
  expect_false(any(grepl("%%", yml, fixed = TRUE)))

  # colour + derived tints injected into theme.scss
  scss <- readLines(file.path(ext, "resources", "theme.scss"), warn = FALSE)
  expect_true(any(grepl("#003865", scss, fixed = TRUE)))
  expect_false(any(grepl("%%", scss, fixed = TRUE)))

  # dark colour => white header text
  expect_true(any(grepl("$dept-header-text:   #FFFFFF", scss, fixed = TRUE)))

  # logo embedded as a data URI in header.html
  html <- readLines(file.path(ext, "resources", "header.html"), warn = FALSE)
  expect_true(any(grepl("data:image/png;base64,", html, fixed = TRUE)))

  # same logo embedded as a favicon, wired into the head via _extension.yml
  fav <- readLines(file.path(ext, "resources", "favicon.html"), warn = FALSE)
  expect_true(any(grepl('<link rel="icon" href="data:image/png;base64,',
                        fav, fixed = TRUE)))
  expect_false(any(grepl("%%", fav, fixed = TRUE)))
  expect_true(any(grepl("include-in-header: resources/favicon.html",
                        yml, fixed = TRUE)))
})

test_that("an explicit favicon overrides the logo", {
  skip_if_not_installed("withr")
  dir  <- local_project()
  logo <- local_png(dir)          # PNG
  fav  <- local_svg(dir)          # SVG -> distinguishable MIME

  suppressMessages(
    custom(colour = "#003865", logo = logo, favicon = fav, path = dir)
  )
  res <- file.path(dir, "_extensions", "custom", "resources")

  # favicon uses the SVG we supplied ...
  favhtml <- readLines(file.path(res, "favicon.html"), warn = FALSE)
  expect_true(any(grepl('rel="icon" href="data:image/svg+xml;base64,',
                        favhtml, fixed = TRUE)))
  # ... while the header still shows the PNG logo
  header <- readLines(file.path(res, "header.html"), warn = FALSE)
  expect_true(any(grepl("data:image/png;base64,", header, fixed = TRUE)))
})

test_that("a missing favicon warns and falls back to the logo", {
  skip_if_not_installed("withr")
  dir  <- local_project()
  logo <- local_png(dir)

  expect_warning(
    suppressMessages(
      custom(colour = "#003865", logo = logo,
             favicon = file.path(dir, "does-not-exist.png"), path = dir)
    ),
    "Favicon not found"
  )
  favhtml <- readLines(
    file.path(dir, "_extensions", "custom", "resources", "favicon.html"),
    warn = FALSE
  )
  expect_true(any(grepl("data:image/png;base64,", favhtml, fixed = TRUE)))
})

test_that(".resolve_favicon precedence falls back logo -> none", {
  expect_equal(.resolve_favicon(NULL, NULL, "data:logo"),
               list(uri = "data:logo", label = "logo"))
  none <- .resolve_favicon(NULL, NULL, NULL)
  expect_null(none$uri)
  expect_equal(none$label, "none")
})

test_that("custom() without a logo writes an inert (link-free) favicon", {
  skip_if_not_installed("withr")
  dir <- local_project()

  suppressMessages(custom(colour = "#0D5257", path = dir))

  fav <- readLines(
    file.path(dir, "_extensions", "custom", "resources", "favicon.html"),
    warn = FALSE
  )
  expect_false(any(grepl("rel=\"icon\"", fav)))
  expect_false(any(grepl("%%", fav, fixed = TRUE)))
})

test_that("custom() imposes no format options by default", {
  skip_if_not_installed("withr")
  dir <- local_project()

  suppressMessages(custom(colour = "#0D5257", path = dir))

  yml <- readLines(
    file.path(dir, "_extensions", "custom", "_extension.yml"), warn = FALSE
  )
  expect_false(any(grepl("^\\s*toc:", yml)))
  expect_false(any(grepl("^\\s*code-fold:", yml)))
  expect_false(any(grepl("^\\s*self-contained:", yml)))
  expect_false(any(grepl("execute:", yml, fixed = TRUE)))
  expect_false(any(grepl("%%", yml, fixed = TRUE)))
  # The two always-present keys survive
  expect_true(any(grepl("theme:", yml, fixed = TRUE)))
  expect_true(any(grepl("include-before-body:", yml, fixed = TRUE)))
})

test_that("opt-in format options are written into the extension", {
  skip_if_not_installed("withr")
  dir <- local_project()

  suppressMessages(custom(
    colour         = "#0D5257",
    path           = dir,
    toc            = TRUE,
    toc_depth      = 2,
    code_fold      = TRUE,
    self_contained = TRUE,
    warning        = FALSE,
    fig_width      = 8
  ))

  yml <- readLines(
    file.path(dir, "_extensions", "custom", "_extension.yml"), warn = FALSE
  )
  expect_true(any(grepl("^\\s*toc: true$", yml)))
  expect_true(any(grepl("^\\s*toc-depth: 2$", yml)))
  expect_true(any(grepl("^\\s*code-fold: true$", yml)))
  expect_true(any(grepl("^\\s*embed-resources: true$", yml)))
  expect_true(any(grepl("^\\s*self-contained: true$", yml)))
  expect_true(any(grepl("^\\s*execute:$", yml)))
  expect_true(any(grepl("^\\s*warning: false$", yml)))
  expect_true(any(grepl("^\\s*fig-width: 8$", yml)))
})

test_that("custom() rejects malformed format options", {
  skip_if_not_installed("withr")
  dir <- local_project()

  expect_error(
    suppressMessages(custom(colour = "#0D5257", path = dir, toc = "yes")),
    "TRUE, FALSE"
  )
})

test_that("custom() with a light colour uses dark header text", {
  skip_if_not_installed("withr")
  dir <- local_project()

  suppressMessages(custom(colour = "#FFD700", path = dir))

  scss <- readLines(
    file.path(dir, "_extensions", "custom", "resources", "theme.scss"),
    warn = FALSE
  )
  expect_true(any(grepl("$dept-header-text:   #1A1A1A", scss, fixed = TRUE)))
})

test_that("custom() without a logo installs and warns nowhere fatal", {
  skip_if_not_installed("withr")
  dir <- local_project()

  expect_no_error(suppressMessages(custom(colour = "#0D5257", path = dir)))
  expect_false(
    file.exists(file.path(dir, "_extensions",
                          "custom",
                          "resources",
                          "logo.png"))
  )
})

test_that("custom() respects overwrite", {
  skip_if_not_installed("withr")
  dir <- local_project()

  suppressMessages(custom(colour = "#0D5257", path = dir))
  expect_error(
    suppressMessages(custom(colour = "#0D5257", path = dir)),
    "already exists"
  )
  expect_no_error(
    suppressMessages(custom(colour = "#0D5257", path = dir, overwrite = TRUE))
  )
})

test_that("custom() validates its inputs", {
  skip_if_not_installed("withr")
  dir <- local_project()

  expect_error(custom(colour = "not-a-colour", path = dir), "hex colour")
  expect_error(custom(colour = "#0D5257", name = "!!!", path = dir))
})

test_that("bundled department themes still install", {
  skip_if_not_installed("withr")

  cases <- list(
    list(fn = lshtm,      id = "lshtm"),
    list(fn = lshtm_mrcg, id = "lshtm-mrcg"),
    list(fn = lshtm_mrcu, id = "lshtm-mrcu"),
    list(fn = florey,     id = "florey")
  )

  for (case in cases) {
    dir <- local_project()
    suppressMessages(case$fn(path = dir))

    ext <- file.path(dir, "_extensions", case$id)
    expect_true(dir.exists(ext))
    expect_true(file.exists(file.path(ext, "resources", "logo.png")))

    yml <- readLines(file.path(ext, "_extension.yml"), warn = FALSE)
    expect_true(any(grepl(paste0("^name: ", case$id, "$"), yml)))
  }
})

test_that("lshtm_mrcu ships a bundled favicon distinct from its logo", {
  skip_if_not_installed("withr")
  dir <- local_project()

  suppressMessages(lshtm_mrcu(path = dir))
  res <- file.path(dir, "_extensions", "lshtm-mrcu", "resources")

  fav <- readLines(file.path(res, "favicon.html"), warn = FALSE)
  expect_true(any(grepl('rel="icon" href="data:image', fav)))
})
