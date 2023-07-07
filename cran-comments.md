## R CMD check results

There were no ERRORs or WARNINGs. `devtools::check_win_devel()` and `devtools::check()` return no NOTEs but `devtools::check_rhub()` returns the following two NOTEs.

```
checking for non-standard things in the check directory ... NOTE
  Found the following files/directories:
    ''NULL''
```

Per [R-hub issue #560](https://github.com/r-hub/rhub/issues/560), this NOTE can be safely ignored. 

```
  checking for detritus in the temp directory ... NOTE
  Found the following files/directories:
    'lastMiKTeXException'
```

Per [R-hub issue #503](https://github.com/r-hub/rhub/issues/503), this could be due to a bug/crash in MiKTeX and can also likely be ignored.

## Downstream dependencies

There are currently no downstream dependencies for this package.
