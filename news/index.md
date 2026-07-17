# Changelog

## usedepartmenttheme 0.1.0

- Initial release.
- Four built-in department themes:
  [`lshtm()`](https://jackwgoodall.github.io/usedepartmenttheme/reference/lshtm.md),
  [`lshtm_mrcg()`](https://jackwgoodall.github.io/usedepartmenttheme/reference/lshtm_mrcg.md),
  [`lshtm_mrcu()`](https://jackwgoodall.github.io/usedepartmenttheme/reference/lshtm_mrcu.md),
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
  header bar. A dedicated favicon can be supplied with `favicon =`;
  otherwise a bundled per-department `favicon.png` is used when present,
  falling back to the logo.
- The branded header bar now shows the full Quarto title block — title,
  subtitle, simple or rich authors (with affiliations, ORCID, and
  email), date, and any other native metadata — by relocating and
  recolouring Quarto’s own title block rather than rebuilding selected
  fields.
- README notes that Quarto’s native branding (`_brand.yml`) covers many
  of the same needs.
