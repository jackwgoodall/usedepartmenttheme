# Changelog

## usedepartmenttheme 0.1.0

- Initial release.
- Three built-in department themes:
  [`lshtm()`](https://jackwgoodall.github.io/usedepartmenttheme/reference/lshtm.md),
  [`lshtm_mrcg()`](https://jackwgoodall.github.io/usedepartmenttheme/reference/lshtm_mrcg.md),
  and
  [`florey()`](https://jackwgoodall.github.io/usedepartmenttheme/reference/florey.md).
- Generic
  [`custom()`](https://jackwgoodall.github.io/usedepartmenttheme/reference/custom.md)
  theme: supply any logo and a single base colour; lighter/paler tints
  are derived automatically and the header text colour is chosen for
  readability from the colour’s luminance.
- Themes impose no document defaults. Quarto settings (table of
  contents, code folding, self-contained output, `warning`/`message`
  suppression, section numbering, figure sizes, highlight style) are
  opt-in arguments on every install function; anything left unset falls
  back to Quarto’s own default.
- The logo is embedded as the browser-tab favicon as well as in the
  header bar.
- README notes that Quarto’s native branding (`_brand.yml`) covers many
  of the same needs.
