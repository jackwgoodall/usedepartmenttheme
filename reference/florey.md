# Install the Florey Institute Quarto theme

Copies `_extensions/florey/` into `path`. Use `format: florey-html` in
your `.qmd` YAML.

## Usage

``` r
florey(
  path = ".",
  logo = NULL,
  colour = "#1a1a1a",
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

- colour:

  Primary brand colour. Defaults to near-black (`"#1a1a1a"`).

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

## Optional format settings

The theme imposes no document defaults of its own. The format arguments
below are all unset (`NULL`) by default and are written into the
extension *only* when you pass a value; anything left unset is omitted
so Quarto's own default applies. You can also set any of them
per-document in your `.qmd` YAML.

## Examples

``` r
if (FALSE) { # \dontrun{
usedepartmenttheme::florey(path = "~/projects/my-analysis")
} # }
```
