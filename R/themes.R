# ── Public theme functions ────────────────────────────────────────────────────

#' Install the LSHTM Quarto theme
#'
#' Copies `_extensions/lshtm/` into `path` and creates `_quarto.yml` there if
#' one does not already exist (required so that `.qmd` files in subfolders can
#' find the extension). Use `format: lshtm-html` in your `.qmd` YAML.
#'
#' # Optional format settings
#'
#' The theme imposes no document defaults of its own. The format arguments
#' below are all unset (`NULL`) by default and are written into the extension
#' *only* when you pass a value; anything left unset is omitted so Quarto's
#' own default applies. You can also set any of them per-document in your
#' `.qmd` YAML.
#'
#' @param path Project root directory. Defaults to the current working
#'   directory. Should be the top-level folder of your project so that all
#'   `.qmd` files in subfolders can resolve the extension.
#' @param logo Path to a PNG, SVG, or JPEG logo file. If `NULL`, the bundled
#'   LSHTM placeholder logo is used.
#' @param colour Primary brand colour as a hex string. Defaults to LSHTM teal
#'   (`"#0D5257"`). Lighter and paler tints are derived automatically.
#' @param overwrite If `TRUE`, replace an existing `_extensions/lshtm/`
#'   directory. Defaults to `FALSE`.
#' @param toc Show a table of contents (`toc`). Logical, or `NULL` to leave
#'   unset.
#' @param toc_depth Deepest heading level shown in the table of contents
#'   (`toc-depth`, e.g. `3`). Requires `toc = TRUE` to have any effect.
#' @param code_fold Fold code blocks behind a toggle (`code-fold`). Logical.
#' @param code_tools Show the document-level code menu (`code-tools`). Logical.
#' @param self_contained Produce a single self-contained HTML file with all
#'   assets inlined (sets both `embed-resources` and `self-contained`).
#'   Logical.
#' @param number_sections Number section headings (`number-sections`). Logical.
#' @param highlight_style Syntax-highlighting theme for code
#'   (`highlight-style`, e.g. `"github"`). Single string.
#' @param warning Show R warnings in the rendered output (`execute: warning`).
#'   Logical; set `FALSE` to suppress.
#' @param message Show R messages in the rendered output (`execute: message`).
#'   Logical; set `FALSE` to suppress.
#' @param fig_width Default figure width in inches (`execute: fig-width`).
#'   Numeric.
#' @param fig_height Default figure height in inches (`execute: fig-height`).
#'   Numeric.
#'
#' @return Invisibly returns the path to the installed extension directory.
#' @export
#'
#' @examples
#' \dontrun{
#' # Install at the current working directory (must be your project root)
#' usedepartmenttheme::lshtm()
#'
#' # Explicit project root
#' usedepartmenttheme::lshtm(path = "~/projects/my-analysis")
#'
#' # Custom logo
#' usedepartmenttheme::lshtm(path = "~/projects/my-analysis",
#'                            logo = "images/logo.png")
#'
#' # Opt in to a full-featured document (nothing is enabled unless you ask)
#' usedepartmenttheme::lshtm(
#'   toc            = TRUE,
#'   toc_depth      = 3,
#'   code_fold      = TRUE,
#'   self_contained = TRUE,
#'   warning        = FALSE,
#'   message        = FALSE
#' )
#' }
lshtm <- function(path            = ".",
                  logo            = NULL,
                  colour          = "#0D5257",
                  overwrite       = FALSE,
                  toc             = NULL,
                  toc_depth       = NULL,
                  code_fold       = NULL,
                  code_tools      = NULL,
                  self_contained  = NULL,
                  number_sections = NULL,
                  highlight_style = NULL,
                  warning         = NULL,
                  message         = NULL,
                  fig_width       = NULL,
                  fig_height      = NULL) {
  .install_theme(
    dept           = "lshtm",
    path           = path,
    logo           = logo,
    colour         = colour,
    dark_header    = FALSE,
    overwrite      = overwrite,
    format_options = .collect_format_options()
  )
}

#' Install the LSHTM / MRC Gambia (joint-branded) Quarto theme
#'
#' Identical colours to [lshtm()] but uses a separate logo slot.
#' Use `format: lshtm-mrcg-html` in your `.qmd` YAML.
#'
#' @inheritSection lshtm Optional format settings
#' @inheritParams lshtm
#' @export
#'
#' @examples
#' \dontrun{
#' usedepartmenttheme::lshtm_mrcg(path = "~/projects/my-analysis")
#' }
lshtm_mrcg <- function(path            = ".",
                       logo            = NULL,
                       colour          = "#0D5257",
                       overwrite       = FALSE,
                       toc             = NULL,
                       toc_depth       = NULL,
                       code_fold       = NULL,
                       code_tools      = NULL,
                       self_contained  = NULL,
                       number_sections = NULL,
                       highlight_style = NULL,
                       warning         = NULL,
                       message         = NULL,
                       fig_width       = NULL,
                       fig_height      = NULL) {
  .install_theme(
    dept           = "lshtm_mrcg",
    path           = path,
    logo           = logo,
    colour         = colour,
    dark_header    = FALSE,
    overwrite      = overwrite,
    format_options = .collect_format_options()
  )
}

#' Install the Florey Institute Quarto theme
#'
#' Copies `_extensions/florey/` into `path`.
#' Use `format: florey-html` in your `.qmd` YAML.
#'
#' @inheritSection lshtm Optional format settings
#' @inheritParams lshtm
#' @param colour Primary brand colour. Defaults to near-black (`"#1a1a1a"`).
#' @export
#'
#' @examples
#' \dontrun{
#' usedepartmenttheme::florey(path = "~/projects/my-analysis")
#' }
florey <- function(path            = ".",
                   logo            = NULL,
                   colour          = "#1a1a1a",
                   overwrite       = FALSE,
                   toc             = NULL,
                   toc_depth       = NULL,
                   code_fold       = NULL,
                   code_tools      = NULL,
                   self_contained  = NULL,
                   number_sections = NULL,
                   highlight_style = NULL,
                   warning         = NULL,
                   message         = NULL,
                   fig_width       = NULL,
                   fig_height      = NULL) {
  .install_theme(
    dept           = "florey",
    path           = path,
    logo           = logo,
    colour         = colour,
    dark_header    = TRUE,
    overwrite      = overwrite,
    format_options = .collect_format_options()
  )
}

#' Install a custom-branded Quarto theme
#'
#' The generic counterpart to the built-in department themes ([lshtm()],
#' [lshtm_mrcg()], [florey()]). Supply your own logo and a single base colour
#' and the package works out the rest:
#'
#' - lighter and paler tints of `colour` are derived automatically and used
#'   for sidebar backgrounds, heading accents, and borders;
#' - header text is set to white or near-black depending on whether `colour`
#'   is perceptually dark (WCAG relative luminance), so the header bar stays
#'   readable whatever colour you pick;
#' - the logo is embedded as a base64 data URI so it renders correctly from
#'   `.qmd` files anywhere in the project tree, and doubles as the browser-tab
#'   favicon.
#'
#' The extension is installed to `_extensions/<name>/` under `path`, and a
#' `_quarto.yml` is created at `path` if one does not already exist. Use
#' `format: <name>-html` in your `.qmd` YAML.
#'
#' @inheritSection lshtm Optional format settings
#' @param colour Primary brand colour as a hex string (e.g. `"#003865"` or
#'   `"#abc"`). Lighter and paler tints, and a readable header text colour,
#'   are derived automatically.
#' @param logo Path to a PNG, SVG, or JPEG logo file. If `NULL`, the header
#'   bar is rendered without a logo.
#' @param name Theme name. Used (after sanitising to lowercase letters,
#'   digits, and hyphens) as the extension folder name and the format key, so
#'   `name = "My Lab"` installs `_extensions/my-lab/` and is used as
#'   `format: my-lab-html`. Defaults to `"custom"`.
#' @param title Human-readable title recorded in the extension's
#'   `_extension.yml`. Defaults to `"<name> HTML Format"`.
#' @inheritParams lshtm
#'
#' @return Invisibly returns the path to the installed extension directory.
#' @export
#'
#' @examples
#' \dontrun{
#' # Your organisation's logo and brand colour — the package derives the rest
#' usedepartmenttheme::custom(colour = "#003865", logo = "images/logo.png")
#'
#' # A named theme, opting in to a table of contents and self-contained output
#' usedepartmenttheme::custom(
#'   colour         = "#6E2585",
#'   logo           = "images/my-lab.svg",
#'   name           = "My Lab",
#'   toc            = TRUE,
#'   self_contained = TRUE
#' )
#'
#' # No logo: the header bar simply omits the image
#' usedepartmenttheme::custom(colour = "#B45C1F")
#' }
custom <- function(colour,
                   logo            = NULL,
                   name            = "custom",
                   title           = NULL,
                   path            = ".",
                   overwrite       = FALSE,
                   toc             = NULL,
                   toc_depth       = NULL,
                   code_fold       = NULL,
                   code_tools      = NULL,
                   self_contained  = NULL,
                   number_sections = NULL,
                   highlight_style = NULL,
                   warning         = NULL,
                   message         = NULL,
                   fig_width       = NULL,
                   fig_height      = NULL) {
  colour  <- .normalise_hex(colour)
  dept_id <- .sanitise_name(name)

  if (is.null(title)) {
    title <- paste(name, "HTML Format")
  }

  .install_theme(
    dept           = NULL,
    path           = path,
    logo           = logo,
    colour         = colour,
    dark_header    = .is_dark(colour),
    overwrite      = overwrite,
    dept_id        = dept_id,
    title          = title,
    format_options = .collect_format_options()
  )
}
