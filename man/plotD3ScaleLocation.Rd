% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plotD3ScaleLocation.R
\name{plotD3ScaleLocation}
\alias{plotD3ScaleLocation}
\title{Plot2 TODO}
\usage{
plotD3ScaleLocation(object, ..., variable = NULL, smooth = FALSE,
  peaks = FALSE, point_count = NULL, single_plot = TRUE,
  scale_plot = FALSE, background = FALSE)
}
\arguments{
\item{object}{An object of class modelAudit or modelResiduals.}

\item{...}{Other modelAudit or modelResiduals objects to be plotted together.}

\item{variable}{Name of model variable to order residuals. If value is NULL data order is taken or variable from modelResiduals object. If value is "Predicted response" or "Fitted values" then data is ordered by fitted values. If value is "Observed response" the data is ordered by a vector of actual response (\code{y} parameter passed to the \code{\link{audit}} function).}

\item{smooth}{Logical, indicates whenever smoothed lines should be added. By default it's FALSE.}

\item{peaks}{Logical, indicates whenever peak observations should be highlighted. By defaul it's FALSE.}

\item{point_count}{Number of points to be plotted per model. Points will be chosen randomly. By default plot all of them.}

\item{single_plot}{Logical, indicates whenever single or facets should be plotted. By default it's TRUE.}

\item{scale_plot}{Logical, indicates whenever the plot should scale with height. By default it's FALSE.}

\item{background}{Logical, available only if single_plot = FALSE. Indicates whenever backgroud plots should be plotted. By default it's FALSE.}
}
\value{
an `r2d3` object.
}
\description{
If the picture is not displayed in the viewer, please update your RStudio.
}
\examples{
library("auditor")
library("DALEX")

lm_model <- lm(m2.price ~., data = apartments)
lm_au <- audit(lm_model, label = "lm")
plotD3ScaleLocation(lm_au, peaks = TRUE, variable = "construction.year")

library(randomForest)
rf_model <- randomForest(m2.price ~., data = apartments)
rf_au <- audit(rf_model, label = "rf")
rf_mr <- modelResiduals(rf_au, "construction.year")
plotD3ScaleLocation(lm_au, rf_mr, variable = "construction.year", smooth = TRUE)
plotD3ScaleLocation(lm_au, rf_mr, variable = "construction.year",
                                  smooth = TRUE, single_plot = FALSE)

}
\seealso{
\code{\link{plotScaleLocation}}
}
