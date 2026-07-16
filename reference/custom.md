# Install a custom-branded Quarto theme

The generic counterpart to the built-in department themes
([`lshtm()`](https://jackwgoodall.github.io/usedepartmenttheme/reference/lshtm.md),
[`lshtm_mrcg()`](https://jackwgoodall.github.io/usedepartmenttheme/reference/lshtm_mrcg.md),
[`florey()`](https://jackwgoodall.github.io/usedepartmenttheme/reference/florey.md)).
Supply your own logo and a single base colour and the package works out
the rest:

## Usage

``` r
custom(
  colour,
  logo = NULL,
  name = "custom",
  title = NULL,
  path = ".",
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

- colour:

  Primary brand colour as a hex string (e.g. `"#003865"` or `"#abc"`).
  Lighter and paler tints, and a readable header text colour, are
  derived automatically.

- logo:

  Path to a PNG, SVG, or JPEG logo file. If `NULL`, the header bar is
  rendered without a logo.

- name:

  Theme name. Used (after sanitising to lowercase letters, digits, and
  hyphens) as the extension folder name and the format key, so
  `name = "My Lab"` installs `_extensions/my-lab/` and is used as
  `format: my-lab-html`. Defaults to `"custom"`.

- title:

  Human-readable title recorded in the extension's `_extension.yml`.
  Defaults to `"<name> HTML Format"`.

- path:

  Project root directory. Defaults to the current working directory.
  Should be the top-level folder of your project so that all `.qmd`
  files in subfolders can resolve the extension.

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

## Details

- lighter and paler tints of `colour` are derived automatically and used
  for sidebar backgrounds, heading accents, and borders;

- header text is set to white or near-black depending on whether
  `colour` is perceptually dark (WCAG relative luminance), so the header
  bar stays readable whatever colour you pick;

- the logo is embedded as a base64 data URI so it renders correctly from
  `.qmd` files anywhere in the project tree, and doubles as the
  browser-tab favicon.

The extension is installed to `_extensions/<name>/` under `path`, and a
`_quarto.yml` is created at `path` if one does not already exist. Use
`format: <name>-html` in your `.qmd` YAML.

## Optional format settings

The theme imposes no document defaults of its own. The format arguments
below are all unset (`NULL`) by default and are written into the
extension *only* when you pass a value; anything left unset is omitted
so Quarto's own default applies. You can also set any of them
per-document in your `.qmd` YAML.

## Examples

``` r
if (FALSE) { # \dontrun{
# Your organisation's logo and brand colour — the package derives the rest
usedepartmenttheme::custom(colour = "#003865", logo = "images/logo.png")

# A named theme, opting in to a table of contents and self-contained output
usedepartmenttheme::custom(
  colour         = "#6E2585",
  logo           = "images/my-lab.svg",
  name           = "My Lab",
  toc            = TRUE,
  self_contained = TRUE
)

# No logo: the header bar simply omits the image
usedepartmenttheme::custom(colour = "#B45C1F")
} # }
```
