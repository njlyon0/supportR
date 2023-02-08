## R CMD check results
There were no ERRORs or WARNINGs. There are two NOTEs.

- One NOTE is that this is the first submission of this package to CRAN
- The other NOTE is returned by `devtools::check_rhub` and is as follows: 

```
* checking for detritus in the temp directory ... NOTE
Found the following files/directories:
  'lastMiKTeXException'
```
As noted in [R-hub issue #503](https://github.com/r-hub/rhub/issues/503), this could be due to a bug/crash in MiKTeX and can likely be ignored.

## Downstream dependencies
There are currently no downstream dependencies for this package.

## Modifications from Last Submission Comments

- Added definitions of what is returned by the functions that were missing that information on first submission (`diff_check`, `nms_ord`, `pcoa_ord`, `rmd_export`, and `theme_lyon`)
- Wrapped long examples (>5 sec) in `donttest` (`nms_ord`, `pcoa_ord`)
- Added `ape` package to "Suggests" as it is not a direct dependency but is related to one of the functions (`pcoa_ord`)
- Wrapped interactive example in `dontrun` (`rmd_export` requires Google Drive authentication and an R Markdown file to act on so cannot run as an example non-interactively)
