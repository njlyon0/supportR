% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/replace_non_ascii.R
\name{replace_non_ascii}
\alias{replace_non_ascii}
\title{Replace Non-ASCII Characters with Comparable ASCII Characters}
\usage{
replace_non_ascii(x = NULL, include_letters = FALSE)
}
\arguments{
\item{x}{(character) vector in which to replace non-ASCII characters}

\item{include_letters}{(logical) whether to include letters with accents (e.g., u with an umlaut, etc.). Defaults to \code{FALSE}}
}
\value{
(character) vector where all non-ASCII characters have been replaced by ASCII equivalents
}
\description{
Finds all non-ASCII (American Standard Code for Information Interchange) characters in a character vector and replaces them with ASCII characters that are as visually similar as possible. For example, various special dash types (e.g., em dash, en dash, etc.) are replaced with a hyphen. The function will return a warning if it finds any non-ASCII characters for which it does not have a hard-coded replacement. Please open a \href{https://github.com/njlyon0/supportR/issues}{GitHub Issue} if you encounter this warning and have a suggestion for what the replacement character should be for that particular character.
}
\examples{
# Make a vector of the hexadecimal codes for several non-ASCII characters
## This function accepts the characters themselves but CRAN checks do not
non_ascii <- c("\u201C", "\u00AC", "\u00D7")

# Invoke function
(ascii <- supportR::replace_non_ascii(x = non_ascii))

}
