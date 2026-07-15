# cran-comments

## R CMD check results

0 errors | 0 warnings | 0 notes

* This is a new release.

## Notes for reviewers

* The package's purpose is to copy a Quarto extension into a user-specified
  project directory. All functions write only to the directory the user
  explicitly passes (default: the current working directory, as with
  usethis-style setup helpers). Examples are wrapped in `\dontrun{}` and
  tests write only to `tempdir()`.
