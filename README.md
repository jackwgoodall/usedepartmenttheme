# usedepartmenttheme

A quick and easy way to format your [Quarto](https://quarto.org/) documents with you academic department's theme and you standard Quarto preferences. 
You set these once and then they are applied by a simple tweak to the YAML.
The package currently has three default themes build in plus a function to supply your own logo and colour scheme.
To have your department added to this package please either add it yourself with a pull request or open an issue on the [GitHub page](https://github.com/jackwgoodall/usedepartmenttheme).

## Themes

| Function | Format key | Header | Default colour |
|---|---|---|---|
| `usedepartmenttheme::lshtm()` | `lshtm-html` | Teal, white text | `#0D5257` |
| `usedepartmenttheme::lshtm_mrcg()` | `lshtm-mrcg-html` | Teal, white text | `#0D5257` |
| `usedepartmenttheme::florey()` | `florey-html` | Black, white text | `#1a1a1a` |
| `usedepartmenttheme::custom()` | `<name>-html` | Derived from your colour | — (you choose) |

The themes impose no document defaults of their own but you can opt in to the
settings you want (see [Optional settings](#optional-settings) below).

## Do you need this package?

Much of what this package does (a logo, brand colours, and typography applied
across a project is now supported natively by Quarto through a `_brand.yml`
file:

> **Quarto branding:** <https://quarto.org/docs/reference/metadata/brand.html>

`usedepartmenttheme` exists to streamline this as an installable
Quarto extension, so collaborators can render with a single `format:` key and no
per-project setup. 

## Installation

```r
pak::pkg_install("jackwgoodall/usedepartmenttheme")
```

## Per-project setup

Run **once** in the project root (same directory as your `.qmd` files):

```r
usedepartmenttheme::custom(colour = "#003865")   # any organisation
usedepartmenttheme::lshtm()
usedepartmenttheme::lshtm_mrcg()
usedepartmenttheme::florey()
```

Each installs its own `_extensions/<dept>/` folder. If you commit this to version
control collaborators can render the same output without the package installed.

### Overriding colour and/or logo

```r
usedepartmenttheme::lshtm(logo = "images/logo.png")
usedepartmenttheme::lshtm(colour = "#003865")
usedepartmenttheme::florey(logo = "images/florey.png", overwrite = TRUE)
```

### Not one of the departments? Use `custom()`

Supply your own logo and a single base colour — the package figures out the
rest. Lighter and paler tints are derived from the colour, and the header
text is set to white or near-black depending on how dark your colour is, so
the header stays readable whatever you pick.
The colour must be supplied as a correctly formatted HEX code.

```r
# Installs _extensions/custom/, used as format: custom-html
usedepartmenttheme::custom(colour = "#003865", logo = "images/logo.png")

# Give it a name: installs _extensions/my-lab/, used as format: my-lab-html
usedepartmenttheme::custom(
  colour = "#6E2585",
  logo   = "images/my-lab.svg",
  name   = "My Lab"
)

# No logo? The header bar simply omits the image
usedepartmenttheme::custom(colour = "#B45C1F")
```

## Optional settings

The themes don't force any Quarto document options on you. Each install
function accepts the following opt-in arguments belwo. Pass a value to
write it into the extension, leave it unset to fall back to Quarto's own
default:

| Argument | Extension key | Notes |
|---|---|---|
| `toc` | `toc` | Show a table of contents |
| `toc_depth` | `toc-depth` | Deepest heading shown (needs `toc = TRUE`) |
| `code_fold` | `code-fold` | Fold code behind a toggle |
| `code_tools` | `code-tools` | Document-level code menu |
| `self_contained` | `embed-resources` + `self-contained` | Single self-contained HTML file |
| `number_sections` | `number-sections` | Number section headings |
| `highlight_style` | `highlight-style` | Code highlight theme, e.g. `"github"` |
| `warning` | `execute: warning` | Set `FALSE` to hide R warnings |
| `message` | `execute: message` | Set `FALSE` to hide R messages |
| `fig_width` | `execute: fig-width` | Default figure width (inches) |
| `fig_height` | `execute: fig-height` | Default figure height (inches) |

```r
usedepartmenttheme::lshtm(
  toc            = TRUE,
  toc_depth      = 3,
  code_fold      = TRUE,
  self_contained = TRUE,
  warning        = FALSE,
  message        = FALSE
)
```

You can always set these per-document in your `.qmd` YAML instead (see
[Per-document overrides](#per-document-overrides) below).

## Usage

When you set you theme the package will prompt you on how to modify the YAML.

```yaml
---
title: "Resistance Profiles"
subtitle: "MRC Gambia — 2024/25"
format: lshtm-html        # or lshtm-mrcg-html / florey-html / <your-custom>-html
---
```

### Per-document overrides

```yaml
format:
  lshtm-html:
    toc-depth: 2
    code-fold: false
```

## File layout after setup

```
your-project/
├── analysis.qmd
└── _extensions/
    └── lshtm/               # or florey/, lshtm_mrcg/, or your custom name
        ├── _extension.yml
        └── resources/
            ├── theme.scss
            ├── header.html
            ├── favicon.html    # logo embedded as the browser-tab favicon
            └── logo.png
```

The logo is embedded (as a base64 data URI) both in the header bar and as the
document's favicon, so the browser tab shows your logo too. Supply a logo with
`logo = ` on any theme, or install with no logo to skip both.

### A separate favicon

By default the logo doubles as the favicon. To use a **dedicated** favicon
instead, pass `favicon = `:

```r
usedepartmenttheme::lshtm(favicon = "images/favicon.png")
usedepartmenttheme::custom(colour = "#003865", logo = "logo.png",
                           favicon = "favicon.png")
```

The order of precedence is: the `favicon = ` argument, then a bundled
`favicon.png` shipped with the department (if it has one), then the logo. A
department without a bundled favicon simply uses its logo so bundling one is
optional.
