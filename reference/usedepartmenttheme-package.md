# usedepartmenttheme: Quarto HTML themes for LSHTM departments

Installs a branded Quarto HTML extension (`format: dept-html`) into your
project with one function call. Four department themes are provided,
plus a generic option:

## Details

- [`lshtm()`](https://jackwgoodall.github.io/usedepartmenttheme/reference/lshtm.md)
  — LSHTM teal (`#0D5257`), white header text

- [`lshtm_mrcg()`](https://jackwgoodall.github.io/usedepartmenttheme/reference/lshtm_mrcg.md)
  — LSHTM / MRC Gambia joint branding, same teal

- [`lshtm_mrcu()`](https://jackwgoodall.github.io/usedepartmenttheme/reference/lshtm_mrcu.md)
  — LSHTM / MRC Uganda joint branding, same teal

- [`florey()`](https://jackwgoodall.github.io/usedepartmenttheme/reference/florey.md)
  — Florey Institute black header, white logo

- [`custom()`](https://jackwgoodall.github.io/usedepartmenttheme/reference/custom.md)
  — bring your own logo and base colour; tints and readable header text
  are derived automatically

The themes impose no document defaults of their own. Optional Quarto
settings — table of contents, code folding, self-contained output,
`warning`/`message` suppression, and more — are opt-in arguments on each
install function: pass a value to enable a setting, leave it unset to
fall back to Quarto's own default. The primary colour and logo can be
overridden for any theme, and the logo is also used as the browser-tab
favicon.

Much of this can also be achieved with Quarto's own branding support
(`_brand.yml`); see
<https://quarto.org/docs/reference/metadata/brand.html>. This package
packages a few opinionated department themes as an installable extension
so collaborators can render with a single `format:` key and no
per-project setup.

## See also

Useful links:

- <https://github.com/jackwgoodall/usedepartmenttheme>

- <https://jackwgoodall.github.io/usedepartmenttheme/>

- Report bugs at
  <https://github.com/jackwgoodall/usedepartmenttheme/issues>

## Author

**Maintainer**: Jack Goodall <jack.goodall@lshtm.ac.uk>
([ORCID](https://orcid.org/0000-0003-0997-5528))
