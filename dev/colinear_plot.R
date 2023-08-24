## ------------------------------------------- ##
# Colinearity Checker Plot
## ------------------------------------------- ##

# Load needed packages
libarian::shelf(tidyverse)

# Clear environment
rm(list = ls())








spokePlot <- function(pos, neg=NULL, ontop='pos', labels=NULL, shrink=1, labelOffset=1.02, nudge=1, pch=16,
                      cexPoints=1, cexLabel=1, lwdPos=1, lwdNeg=1, ltyPos='solid', ltyNeg='dashed',
                      colPos='black', colNeg='black', colPoints='black', colLabel='black', ...) {
  # spokePlot Creates a "spoke" plot to help visualize networks or correlation matrices. Factors are arranged in a circle, and lines connect them if they are linked in some manner (e.g., highly correlated). Two types of spokes can be drawn, one for "positive" associations (denoted with arguments that have "X") and "negative" associations ("Y").
  #
  # ARGUMENTS
  # pos			Binary matrix with 1s indicating row (label) is associated with column (label)
  # neg			As pos, but indicating "negative" associations (however defined)
  # ontop			'pos' ==> plot positive association spokes first; 'neg' ==> plot negative associations first
  # labels		Character vector of names to add to plot.  If NULL then column names of pos will be used.
  # shrink		Numeric, relative size of non-label part of plot... useful is labels are too long to fit onto a plot.  Default = 1.
  # labelOffset	Value (usually > 1) indicating how far from points labels are placed.  If 1, then labels are placed on points and <1 inside points.
  # nudge			Factor by which to multiple y-coordinates of labels. Default is 1. Useful if there are many labels and they tend to overlap one another.
  # pch			Integer, point style (leave as NA to no plot points)
  # cexPoints		Integer, size of points
  # cexLabel	 	Integer, size of labels
  # lwdPos, lwdNeg Integer, line width of spokes
  # ltyPos, ltyNeg Integer or character, line style of spokes (see ?lines)
  # colPos, colNeg Integer or character, color of spokes
  # colPoints		Integer or vector, color of points
  # colLabel		Integer or vector, color of labels
  # ...			Furtehr arguments to pass to plot(), points(), lines(), or text()
  #
  # VALUES
  # None.  By-product is a spoke plot.
  # 
  # REQUIRED DEPENDANCIES
  #
  #
  # OPTIONAL DEPENDANCIES
  #
  #
  # BAUHAUS
  # 
  #
  # EXAMPLE
  # FUNCTION()
  #
  # SOURCE	source('C:/ecology/Drive/Workshops/SDM from Start to Finish (KSU, 2016-02)/Scripts/Spoke Plot.r')
  #
  # TESTING
  #
  #
  # LICENSE
  # This document is copyright ?2014 by Adam B. Smith.  This document is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3, or (at your option) any later version.  This document is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details. Copies of the GNU General Public License versions are available at http://www.R-project.org/Licenses/.
  #
  # AUTHOR	Adam B. Smith | Missouri Botanical Garden, St. Louis, Missouri | adamDOTsmithATmobotDOTorg
  # DATE		
  # REVISIONS 
  
  ############################
  ## FUNCTIONS AND PACKAGES ##
  ############################
  
  offset <- 0.2 # amount by which to slide entire plot to left and lower to ensure it's more toward the center of the plotting region
  
  ####################
  ## PRE-PROCESSING ##
  ####################
  
  par(pty='s')
  # plot(x=0, y=0, col=par('bg'), type='n', axes=FALSE, xlab=NA, ylab=NA, xlim=c(-1.1 * shrink * labelOffset, shrink * labelOffset, major * labelOffset, minor * labelOffset), ylim=c(-1.1 * shrink * labelOffset, shrink * labelOffset, major * labelOffset, minor * labelOffset), ...)
  # plot(x=0, y=0, col=par('bg'), type='n', axes=FALSE, xlab=NA, ylab=NA, xlim=c(-1.1 * max(shrink, major) * labelOffset, max(shrink, major) * labelOffset), ylim=c(-1.1 * max(shrink, major) * labelOffset, max(shrink, major) * labelOffset))
  plot(x=0, y=0, col=par('bg'), type='n', axes=FALSE, xlab=NA, ylab=NA, xlim=c(-1.1 * shrink * labelOffset, shrink * labelOffset), ylim=c(-1.1 * shrink * labelOffset, shrink * labelOffset))
  
  ##########
  ## MAIN ##
  ##########
  
  ## get coordinates for connection points
  xLink <- rev(shrink * cos(seq(pi / 2, 2 * pi + pi / 2, length.out=ncol(pos) + 1)))
  yLink <- rev(shrink * sin(seq(pi / 2, 2 * pi + pi / 2, length.out=ncol(pos) + 1)))
  
  ## add points
  if (!is.na(pch)) points(xLink - offset * shrink, yLink, pch=pch, cex=cexPoints, col=colPoints, xpd=NA, ...)
  
  if (ontop=='pos') {
    
    ## add negative spokes
    if (!is.null(neg)) {
      for (i in 1:nrow(neg)) {
        for (j in 1:ncol(neg)) {
          if (!is.na(neg[i, j]) && neg[i, j]==1) lines(x=c(xLink[i] - offset * shrink, xLink[j] - offset * shrink), y=c(yLink[i], yLink[j]), col=colNeg, lwd=lwdNeg, lty=ltyNeg, xpd=NA, ...)
        }
      }
    }
    
    ## add positive spokes
    for (i in 1:nrow(pos)) {
      for (j in 1:ncol(pos)) {
        if (!is.na(pos[i, j]) && pos[i, j]==1) lines(x=c(xLink[i] - offset * shrink, xLink[j] - offset * shrink), y=c(yLink[i], yLink[j]), col=colPos, lwd=lwdPos, lty=ltyPos, xpd=NA, ...)
      }
    }
    
  } else {
    
    ## add positive spokes
    for (i in 1:nrow(pos)) {
      for (j in 1:ncol(pos)) {
        if (!is.na(pos[i, j]) && pos[i, j]==1) lines(x=c(xLink[i] - offset * shrink, xLink[j] - offset * shrink), y=c(yLink[i], yLink[j]), col=colPos, lwd=lwdPos, lty=ltyPos, xpd=NA, ...)
      }
    }
    
    ## add negative spokes
    if (!is.null(neg)) {
      for (i in 1:nrow(neg)) {
        for (j in 1:ncol(neg)) {
          if (!is.na(neg[i, j]) && neg[i, j]==1) lines(x=c(xLink[i] - offset * shrink, xLink[j] - offset * shrink), y=c(yLink[i], yLink[j]), col=colNeg, lwd=lwdNeg, lty=ltyNeg, xpd=NA, ...)
        }
      }
    }
    
  }
  
  ## add labels
  if (is.null(labels)) if (class(pos)=='matrix') { labels <- colnames(pos) } else { labels <- names(pos) }
  
  xLabel <- rev(shrink * labelOffset * cos(seq(pi / 2, 2 * pi + pi / 2, length.out=ncol(pos) + 1)))
  yLabel <- rev(shrink * labelOffset * sin(seq(pi / 2, 2 * pi + pi / 2, length.out=ncol(pos) + 1)))
  yLabel <- yLabel * nudge
  
  position <- rep(1, ncol(pos))
  position[xLabel > 0] <- 4
  position[xLabel < 0] <- 2
  position[xLabel < 10^-5 & xLabel > -10^-5 & yLabel > 0] <- 3
  position[xLabel < 10^-5 & xLabel > -10^-5 & yLabel < 0] <- 1
  
  text(x=xLabel - offset * shrink, y=yLabel, labels=labels, pos=position, cex=cexLabel, col=colLabel, xpd=NA, ...)
  
  #####################
  ## POST-PROCESSING ##
  #####################
  
  
}





# End ----
