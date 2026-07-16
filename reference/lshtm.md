# Install the LSHTM Quarto theme

Copies `_extensions/lshtm/` into `path` and creates `_quarto.yml` there
if one does not already exist (required so that `.qmd` files in
subfolders can find the extension). Use `format: lshtm-html` in your
`.qmd` YAML.

## Usage

``` r
lshtm(
  path = ".",
  logo = NULL,
  favicon = NULL,
  colour = "#0D5257",
  overwrite = FALSE,
  toc = NULL,
  toc_depth = NULL,
  code_fold = NULL,
  code_tools = NULL,
  self_contained = NULL,
  number_sections = NULL,
  highlight_style = NULL,
  warning = NULL,
  message = NULL,
  fig_width = NULL,
  fig_height = NULL
)
```

## Arguments

- path:

  Project root directory. Defaults to the current working directory.
  Should be the top-level folder of your project so that all `.qmd`
  files in subfolders can resolve the extension.

- logo:

  Path to a PNG, SVG, or JPEG logo file. If `NULL`, the bundled LSHTM
  placeholder logo is used.

- favicon:

  Optional path to a dedicated favicon image (PNG, SVG, ICO, ...). If
  `NULL`, a bundled `favicon.png` for the department is used when
  present, otherwise the logo doubles as the favicon.

- colour:

  Primary brand colour as a hex string. Defaults to LSHTM teal
  (`"#0D5257"`). Lighter and paler tints are derived automatically.

- overwrite:

  If `TRUE`, replace an existing `_extensions/lshtm/` directory.
  Defaults to `FALSE`.

- toc:

  Show a table of contents (`toc`). Logical, or `NULL` to leave unset.

- toc_depth:

  Deepest heading level shown in the table of contents (`toc-depth`,
  e.g. `3`). Requires `toc = TRUE` to have any effect.

- code_fold:

  Fold code blocks behind a toggle (`code-fold`). Logical.

- code_tools:

  Show the document-level code menu (`code-tools`). Logical.

- self_contained:

  Produce a single self-contained HTML file with all assets inlined
  (sets both `embed-resources` and `self-contained`). Logical.

- number_sections:

  Number section headings (`number-sections`). Logical.

- highlight_style:

  Syntax-highlighting theme for code (`highlight-style`, e.g.
  `"github"`). Single string.

- warning:

  Show R warnings in the rendered output (`execute: warning`). Logical;
  set `FALSE` to suppress.

- message:

  Show R messages in the rendered output (`execute: message`). Logical;
  set `FALSE` to suppress.

- fig_width:

  Default figure width in inches (`execute: fig-width`). Numeric.

- fig_height:

  Default figure height in inches (`execute: fig-height`). Numeric.

## Value

Invisibly returns the path to the installed extension directory.

## Optional format settings

The theme imposes no document defaults of its own. The format arguments
below are all unset (`NULL`) by default and are written into the
extension *only* when you pass a value; anything left unset is omitted
so Quarto's own default applies. You can also set any of them
per-document in your `.qmd` YAML.

## Examples

``` r
if (FALSE) { # \dontrun{
# Install at the current working directory (must be your project root)
usedepartmenttheme::lshtm()

# Explicit project root
usedepartmenttheme::lshtm(path = "~/projects/my-analysis")

# Custom logo
usedepartmenttheme::lshtm(path = "~/projects/my-analysis",
                           logo = "images/logo.png")

# Opt in to a full-featured document (nothing is enabled unless you ask)
usedepartmenttheme::lshtm(
  toc            = TRUE,
  toc_depth      = 3,
  code_fold      = TRUE,
  self_contained = TRUE,
  warning        = FALSE,
  message        = FALSE
)
} # }
```
