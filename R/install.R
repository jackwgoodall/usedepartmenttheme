# Quarto extension ids
# The folder name, _extension.yml name: field, and format: key all use this.
.dept_to_id <- c(
  lshtm      = "lshtm",
  lshtm_mrcg = "lshtm-mrcg",
  florey     = "florey"
)

# Department display titles (used in _extension.yml title: field)
.dept_titles <- c(
  lshtm      = "LSHTM HTML Format",
  lshtm_mrcg = "LSHTM / MRC Gambia HTML Format",
  florey     = "Florey Institute HTML Format"
)

#' Core installer — called by every public theme function
#'
#' @param dept       R-side department key: `"lshtm"`, `"lshtm_mrcg"`,
#'   `"florey"`, or `"lab_med"`. `NULL` for a custom theme, in which case
#'   `dept_id` and `title` must be supplied and no bundled logo is available.
#' @param path       Project root — must contain or will receive `_quarto.yml`.
#' @param logo       User-supplied logo path, or `NULL` to use the bundled one
#'   (custom themes have no bundled logo; the header image is hidden instead).
#' @param colour     Primary hex colour.
#' @param dark_header If `TRUE`, header text is white on a dark bar.
#' @param overwrite  Replace an existing extension directory.
#' @param dept_id    Extension id (folder name and `format:` prefix). Derived
#'   from `dept` when `dept` is supplied.
#' @param title      Display title for `_extension.yml`. Derived from `dept`
#'   when `dept` is supplied.
#' @param format_options Named list of optional Quarto format settings. Any
#'   element that is `NULL` is omitted from `_extension.yml` entirely, so
#'   Quarto's own default applies. See `.build_format_lines()`.
#' @noRd
.install_theme <- function(dept, path, logo, colour, dark_header, overwrite,
                           dept_id = NULL, title = NULL,
                           format_options = list()) {

  colour <- .normalise_hex(colour)
  .validate_format_options(format_options)

  if (!is.null(dept)) {
    dept_id <- .dept_to_id[[dept]]
    title   <- .dept_titles[[dept]]
    if (is.null(dept_id)) {
      rlang::abort(paste0("Unknown department key: '", dept, "'."))
    }
  }

  src       <- system.file("formats/dept", package = "usedepartmenttheme",
                           mustWork = TRUE)
  dest_root <- fs::path(path, "_extensions", dept_id)

  if (fs::dir_exists(dest_root)) {
    if (!overwrite) {
      rlang::abort(c(
        paste0("`_extensions/", dept_id, "` already exists in `", path, "`."),
        i = "Set `overwrite = TRUE` to replace it."
      ))
    }
    fs::dir_delete(dest_root)
  }

  fs::dir_copy(src, dest_root)

  # ── Inject name/title + optional format settings into _extension.yml ─────────
  yml_path <- fs::path(dest_root, "_extension.yml")
  .inject_yml(yml_path, dept_id, title)
  .inject_format_options(yml_path, format_options)

  # ── Inject colours into theme.scss ──────────────────────────────────────────
  scss_path <- fs::path(dest_root, "resources", "theme.scss")
  .inject_colours(scss_path, colour, dark_header)

  # ── Resolve logo file path ───────────────────────────────────────────────────
  dest_logo <- fs::path(dest_root, "resources", "logo.png")

  if (!is.null(logo)) {
    logo_path <- fs::path_abs(logo)
    if (!fs::file_exists(logo_path)) {
      if (is.null(dept)) {
        rlang::warn(paste0(
          "Logo not found at `", logo_path, "`. ",
          "The header image will be hidden at render time."
        ))
      } else {
        rlang::warn(paste0(
          "Logo not found at `", logo_path, "`. Falling back to bundled default."
        ))
        .copy_bundled_logo(dept, dest_logo)
      }
    } else {
      fs::file_copy(logo_path, dest_logo, overwrite = TRUE)
    }
  } else if (!is.null(dept)) {
    .copy_bundled_logo(dept, dest_logo)
  }

  # ── Embed logo as base64 data URI in header.html and the favicon ─────────────
  # A relative src path breaks when .qmd files are in subdirectories because
  # the browser resolves it relative to the .qmd, not the project root.
  # Embedding as a data URI makes the logo path-independent, and lets the same
  # image double as the browser-tab favicon.
  logo_uri <- .logo_data_uri(dest_logo)

  html_path <- fs::path(dest_root, "resources", "header.html")
  .inject_logo_uri(html_path, logo_uri, dept_id)

  favicon_path <- fs::path(dest_root, "resources", "favicon.html")
  .inject_favicon(favicon_path, logo_uri)

  # ── Ensure _quarto.yml exists so subfolders can find the extension ───────────
  quarto_yml <- fs::path(path, "_quarto.yml")
  if (!fs::file_exists(quarto_yml)) {
    fs::file_create(quarto_yml)
    .cli_inform(c("i" = paste0("Created `_quarto.yml` at ", path,
                               " so subfolders can find the extension.")))
  }

  logo_label <- if (!is.null(logo)) {
    logo
  } else if (!is.null(dept)) {
    paste0("bundled ", dept, " default")
  } else {
    "none (header image hidden)"
  }

  set_opts <- names(Filter(Negate(is.null), format_options))
  opts_label <- if (length(set_opts)) {
    paste(set_opts, collapse = ", ")
  } else {
    "none set (Quarto defaults apply)"
  }

  .cli_inform(c(
    "v" = paste0(title, " installed."),
    "i" = paste0("Location : ", dest_root),
    "i" = paste0("Colour   : ", colour),
    "i" = paste0("Header   : ",
                 if (dark_header || .is_dark(colour)) "white text on dark colour"
                 else "dark text on light colour"),
    "i" = paste0("Logo     : ", logo_label),
    "i" = paste0("Options  : ", opts_label),
    "i" = paste0("Format   : add `format: ", dept_id, "-html` to your document YAML.")
  ))

  invisible(dest_root)
}

#' Replace %%DEPT_NAME%% and %%DEPT_TITLE%% in the installed _extension.yml
#' @noRd
.inject_yml <- function(yml_path, dept_id, title) {
  yml   <- readLines(yml_path, warn = FALSE)
  if (is.null(title) || is.na(title)) title <- paste(toupper(dept_id), "HTML Format")
  yml <- gsub("%%DEPT_NAME%%",  dept_id, yml, fixed = TRUE)
  yml <- gsub("%%DEPT_TITLE%%", title,   yml, fixed = TRUE)
  writeLines(yml, yml_path)
}

#' Validate a named list of optional Quarto format settings.
#'
#' Each element may be `NULL` (meaning "not set" — leave it out of the
#' extension). When supplied, logical flags must be a single `TRUE`/`FALSE`,
#' numeric settings a single number, and `highlight_style` a single string.
#' @noRd
.validate_format_options <- function(opts) {
  flags <- c("toc", "code_fold", "code_tools", "self_contained",
             "number_sections", "warning", "message")
  for (nm in intersect(flags, names(opts))) {
    v <- opts[[nm]]
    if (!is.null(v) &&
        !(is.logical(v) && length(v) == 1L && !is.na(v))) {
      rlang::abort(paste0("`", nm, "` must be TRUE, FALSE, or NULL."))
    }
  }
  nums <- c("toc_depth", "fig_width", "fig_height")
  for (nm in intersect(nums, names(opts))) {
    v <- opts[[nm]]
    if (!is.null(v) &&
        !(is.numeric(v) && length(v) == 1L && !is.na(v))) {
      rlang::abort(paste0("`", nm, "` must be a single number or NULL."))
    }
  }
  hs <- opts[["highlight_style"]]
  if (!is.null(hs) && !(is.character(hs) && length(hs) == 1L && !is.na(hs))) {
    rlang::abort("`highlight_style` must be a single string or NULL.")
  }
  invisible(opts)
}

#' Build the `_extension.yml` lines for the optional format settings.
#'
#' Returns a character vector of YAML lines (correctly indented to sit under
#' `contributes: formats: html:`) for only those `opts` elements that are not
#' `NULL`. Anything left `NULL` is omitted so Quarto's own default applies.
#' Returns `character(0)` when nothing is set.
#' @noRd
.build_format_lines <- function(opts) {
  ind  <- strrep(" ", 6)   # under `html:`
  ind2 <- strrep(" ", 8)   # under `execute:`
  yn   <- function(x) if (isTRUE(x)) "true" else "false"

  lines <- character(0)
  add   <- function(lines, key, val) c(lines, paste0(ind, key, ": ", val))

  if (!is.null(opts$toc))             lines <- add(lines, "toc", yn(opts$toc))
  if (!is.null(opts$toc_depth))       lines <- add(lines, "toc-depth", as.integer(opts$toc_depth))
  if (!is.null(opts$code_fold))       lines <- add(lines, "code-fold", yn(opts$code_fold))
  if (!is.null(opts$code_tools))      lines <- add(lines, "code-tools", yn(opts$code_tools))
  if (!is.null(opts$number_sections)) lines <- add(lines, "number-sections", yn(opts$number_sections))
  if (!is.null(opts$highlight_style)) lines <- add(lines, "highlight-style", opts$highlight_style)
  if (!is.null(opts$self_contained)) {
    lines <- add(lines, "embed-resources", yn(opts$self_contained))
    lines <- add(lines, "self-contained",  yn(opts$self_contained))
  }

  exec <- character(0)
  if (!is.null(opts$warning))    exec <- c(exec, paste0(ind2, "warning: ",    yn(opts$warning)))
  if (!is.null(opts$message))    exec <- c(exec, paste0(ind2, "message: ",    yn(opts$message)))
  if (!is.null(opts$fig_width))  exec <- c(exec, paste0(ind2, "fig-width: ",  opts$fig_width))
  if (!is.null(opts$fig_height)) exec <- c(exec, paste0(ind2, "fig-height: ", opts$fig_height))
  if (length(exec)) lines <- c(lines, paste0(ind, "execute:"), exec)

  lines
}

#' Replace the %%FORMAT_OPTIONS%% placeholder line in _extension.yml.
#'
#' Splices in the lines from `.build_format_lines()`, or removes the
#' placeholder line entirely when no options were set.
#' @noRd
.inject_format_options <- function(yml_path, opts) {
  yml   <- readLines(yml_path, warn = FALSE)
  idx   <- grep("%%FORMAT_OPTIONS%%", yml, fixed = TRUE)
  lines <- .build_format_lines(opts)
  if (length(idx)) {
    yml <- append(yml[-idx], lines, after = idx - 1L)
  }
  writeLines(yml, yml_path)
}

#' Encode a logo file as a self-contained base64 `data:` URI.
#'
#' Returns `NULL` when the file is missing or empty. Encoding the logo this
#' way makes it path-independent — it renders regardless of where the `.qmd`
#' lives in the project tree — and lets the same image serve as the favicon.
#' @noRd
.logo_data_uri <- function(logo_path) {
  # Use base R file.info() for size — fs::file_info() can return NA on
  # network/iCloud paths even when the file is valid.
  logo_size <- file.info(logo_path)$size
  if (!file.exists(logo_path) || is.na(logo_size) || logo_size == 0) {
    return(NULL)
  }

  ext  <- tolower(tools::file_ext(logo_path))
  mime <- switch(ext,
                 svg  = "image/svg+xml",
                 png  = "image/png",
                 jpg  = "image/jpeg",
                 jpeg = "image/jpeg",
                 "image/png")

  raw <- readBin(logo_path, "raw", n = logo_size)
  paste0("data:", mime, ";base64,", base64enc::base64encode(raw))
}

#' Embed the logo as a base64 data URI in header.html.
#'
#' Replaces the placeholder src path with the self-contained data URI from
#' `.logo_data_uri()`. Falls back to the on-disk relative path when no usable
#' logo is available.
#' @noRd
.inject_logo_uri <- function(html_path, logo_uri, dept_id) {
  html <- readLines(html_path, warn = FALSE)

  placeholder <- 'src="_extensions/dept/resources/logo.png"'
  replacement <- if (!is.null(logo_uri)) {
    paste0('src="', logo_uri, '"')
  } else {
    paste0('src="_extensions/', dept_id, '/resources/logo.png"')
  }

  html <- gsub(placeholder, replacement, html, fixed = TRUE)
  writeLines(html, html_path)
}

#' Write the favicon include, embedding the logo as the browser-tab icon.
#'
#' Replaces the %%FAVICON_LINK%% placeholder with a `<link rel="icon">` using
#' the logo data URI. When there is no logo the placeholder is blanked, so the
#' included file is inert and no favicon is set.
#' @noRd
.inject_favicon <- function(favicon_path, logo_uri) {
  html <- readLines(favicon_path, warn = FALSE)
  link <- if (!is.null(logo_uri)) {
    paste0('<link rel="icon" href="', logo_uri, '">')
  } else {
    ""
  }
  html <- gsub("%%FAVICON_LINK%%", link, html, fixed = TRUE)
  writeLines(html, favicon_path)
}

#' Copy the bundled per-department logo to the extension resources dir.
#' Tries PNG first (real logos), falls back to SVG (placeholders).
#' Uses base R file.exists() throughout to avoid fs issues on iCloud paths.
#' @noRd
.copy_bundled_logo <- function(dept, dest_logo) {
  src_logo <- system.file(file.path("logos", dept, "logo.png"),
                          package = "usedepartmenttheme")
  if (nchar(src_logo) == 0 || !file.exists(src_logo)) {
    src_logo <- system.file(file.path("logos", dept, "logo.svg"),
                            package = "usedepartmenttheme")
  }
  if (nchar(src_logo) == 0 || !file.exists(src_logo)) {
    rlang::warn(paste0(
      "No bundled logo found for department '", dept, "'. ",
      "The header image will be hidden at render time."
    ))
    return(invisible(NULL))
  }
  file.copy(src_logo, dest_logo, overwrite = TRUE)
}


#' Names of the optional Quarto format settings shared by every theme.
#' @noRd
.format_option_names <- c(
  "toc", "toc_depth", "code_fold", "code_tools", "self_contained",
  "number_sections", "highlight_style", "warning", "message",
  "fig_width", "fig_height"
)

#' Collect the optional format settings from a theme function's environment.
#'
#' Each public theme function declares the same set of format arguments (see
#' `.format_option_names`); this pulls them into the named list that
#' `.install_theme()` expects, without repeating the list in every function.
#' @noRd
.collect_format_options <- function(env = parent.frame()) {
  mget(.format_option_names, envir = env, ifnotfound = list(NULL))
}

#' Sanitise a user-supplied theme name into a Quarto extension id
#'
#' Lowercases, replaces runs of anything other than letters/digits with a
#' single hyphen, and trims leading/trailing hyphens, so the result is safe
#' as a folder name and `format:` key (e.g. "My Lab!" -> "my-lab").
#' @noRd
.sanitise_name <- function(name) {
  if (!is.character(name) || length(name) != 1L || is.na(name)) {
    rlang::abort("`name` must be a single character string.")
  }
  id <- tolower(trimws(name))
  id <- gsub("[^a-z0-9]+", "-", id)
  id <- gsub("^-+|-+$", "", id)
  if (!nzchar(id)) {
    rlang::abort(paste0(
      "`name` must contain at least one letter or digit. Got: \"", name, "\"."
    ))
  }
  id
}


# Colour helpers ----

#' Validate and normalise a hex colour string to uppercase 6-digit form
#' @noRd
.normalise_hex <- function(hex) {
  hex <- trimws(hex)
  if (!grepl("^#([0-9A-Fa-f]{3}|[0-9A-Fa-f]{6})$", hex)) {
    rlang::abort(paste0(
      "`colour` must be a hex colour like \"#0D5257\" or \"#abc\". Got: ", hex
    ))
  }
  if (nchar(hex) == 4) {
    ch  <- strsplit(substring(hex, 2), "")[[1]]
    hex <- paste0("#", paste(rep(ch, each = 2), collapse = ""))
  }
  toupper(hex)
}

#' Parse a 6-digit hex colour to a named numeric RGB vector (0-255)
#' @noRd
.hex_to_rgb <- function(hex) {
  h <- substring(hex, 2)
  c(r = strtoi(substring(h, 1, 2), 16L),
    g = strtoi(substring(h, 3, 4), 16L),
    b = strtoi(substring(h, 5, 6), 16L))
}

#' Convert a numeric RGB vector (0-255) to a hex string
#' @noRd
.rgb_to_hex <- function(rgb) {
  vals <- pmin(pmax(round(rgb), 0L), 255L)
  paste0("#", paste(sprintf("%02X", vals), collapse = ""))
}

#' Mix a colour toward white by `amount` (0 = original, 1 = pure white)
#' @noRd
.lighten <- function(hex, amount) {
  rgb   <- .hex_to_rgb(hex)
  white <- c(r = 255L, g = 255L, b = 255L)
  .rgb_to_hex(rgb + amount * (white - rgb))
}

#' Return TRUE when a colour is perceptually dark (WCAG relative luminance < 0.35)
#' @noRd
.is_dark <- function(hex) {
  rgb <- .hex_to_rgb(hex) / 255
  lin <- ifelse(rgb <= 0.04045, rgb / 12.92, ((rgb + 0.055) / 1.055)^2.4)
  lum <- 0.2126 * lin[["r"]] + 0.7152 * lin[["g"]] + 0.0722 * lin[["b"]]
  lum < 0.35
}

#' Inject colour tokens into the installed theme.scss
#' @noRd
.inject_colours <- function(scss_path, colour, dark_header) {
  scss <- readLines(scss_path, warn = FALSE)

  light <- .lighten(colour, 0.30)
  pale  <- .lighten(colour, 0.88)

  header_text   <- if (dark_header || .is_dark(colour)) "#FFFFFF" else "#1A1A1A"
  header_border <- if (dark_header || .is_dark(colour)) "transparent" else pale

  scss <- gsub("%%DEPT_COLOUR%%",        colour,        scss, fixed = TRUE)
  scss <- gsub("%%DEPT_COLOUR_LIGHT%%",  light,         scss, fixed = TRUE)
  scss <- gsub("%%DEPT_COLOUR_PALE%%",   pale,          scss, fixed = TRUE)
  scss <- gsub("%%DEPT_HEADER_TEXT%%",   header_text,   scss, fixed = TRUE)
  scss <- gsub("%%DEPT_HEADER_BORDER%%", header_border, scss, fixed = TRUE)

  writeLines(scss, scss_path)
}


# CLI helper -----

#' Emit a cli-style message, falling back to base message() if cli is absent
#' @noRd
.cli_inform <- function(x) {
  if (requireNamespace("cli", quietly = TRUE)) {
    cli::cli_inform(x)
  } else {
    message(paste(unname(x), collapse = "\n"))
  }
}
