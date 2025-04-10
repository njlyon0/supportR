% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/array_melt.R
\name{array_melt}
\alias{array_melt}
\title{Melt an Array into a Dataframe}
\usage{
array_melt(array = NULL)
}
\arguments{
\item{array}{(array) array object to melt into a dataframe}
}
\value{
(dataframe) object containing the "flattened" array in dataframe format
}
\description{
Melts an array of dimensions x, y, and z into a dataframe containing columns \code{x}, \code{y}, \code{z}, and \code{value} where \code{value} is whatever was stored in the array at those coordinates.
}
\examples{
# First we need to create an array to melt
## Make data to fill the array
vec1 <- c(5, 9, 3)
vec2 <- c(10:15)

## Create dimension names (x = col, y = row, z = which matrix)
x_vals <- c("Col_1","Col_2","Col_3")
y_vals <- c("Row_1","Row_2","Row_3")
z_vals <- c("Mat_1","Mat_2")

## Make an array from these components
g <- array(data = c(vec1, vec2), dim = c(3, 3, 2),
           dimnames = list(x_vals, y_vals, z_vals))

## "Melt" the array into a dataframe
supportR::array_melt(array = g)

}
