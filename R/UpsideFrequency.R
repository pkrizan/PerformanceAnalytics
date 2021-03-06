#' upside frequency of the return distribution
#'
#' To calculate Upside Frequency, we take the subset of returns that are
#' more than the target (or Minimum Acceptable Returns (MAR)) returns and
#' divide the length of this subset by the total number of returns.
#'
#' \deqn{ UpsideFrequency(R , MAR) = \sum^{n}_{t=1}\frac{max[(R_{t} - MAR),
#'  0]}{R_{t}*n}}{UpsideFrequency(R, MAR) = length(subset of returns above MAR) /
#' length(total returns)}
#'
#' where \eqn{n} is the number of observations of the entire series
#'
#' @aliases UpsideFrequency
#' @param R an xts, vector, matrix, data frame, timeSeries or zoo object of
#' asset returns
#' @param MAR Minimum Acceptable Return, in the same periodicity as your
#' returns
#' @param \dots any other passthru parameters
#' @author Matthieu Lestel
#' @references Carl Bacon, \emph{Practical portfolio performance measurement 
#' and attribution}, second edition 2008 p.94
#' 
###keywords ts multivariate distribution models
#' @examples
#' data(portfolio_bacon)
#' MAR = 0.005
#' print(UpsideFrequency(portfolio_bacon[,1], MAR)) #expected 0.542
#'
#' data(managers)
#' print(UpsideFrequency(managers['1996']))
#' print(UpsideFrequency(managers['1996',1])) #expected 0.75
#'
#' @export

UpsideFrequency <- function (R, MAR = 0, ...)
{
    R = checkData(R)

    if (ncol(R)==1 || is.null(R) || is.vector(R)) {
       R = na.omit(R)
       r = R[which(R > MAR)]

        if(!is.null(dim(MAR))){
            if(is.timeBased(index(MAR))){
                MAR <-MAR[index(r)] #subset to the same dates as the R data
            } 
	    else{
                MAR = mean(checkData(MAR, method = "vector"))
                # we have to assume that Ra and a vector of Rf passed in for MAR both cover the same time period
            }
        }
	result = length(r) / length(R)
        return(result)
    }
    else {
        result = apply(R, MARGIN = 2, UpsideFrequency, MAR = MAR, ...)
        result<-t(result)
        colnames(result) = colnames(R)
        rownames(result) = paste("Upside Frequency (MAR = ",MAR,"%)", sep="")
        return(result)
    }
}

###############################################################################
# R (http://r-project.org/) Econometrics for Performance and Risk Analysis
#
# Copyright (c) 2004-2018 Peter Carl and Brian G. Peterson
#
# This R package is distributed under the terms of the GNU Public License (GPL)
# for full details see the file COPYING
#
# $Id$
#
###############################################################################
