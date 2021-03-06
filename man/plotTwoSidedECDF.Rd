% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plotTwoSidedECDF.R
\name{plotTwoSidedECDF}
\alias{plotTwoSidedECDF}
\title{Two-sided Cumulative Distribution Function}
\usage{
plotTwoSidedECDF(object, ..., error.scaled = TRUE, outliers = NA,
  residuals = TRUE, y.reversed = FALSE)
}
\arguments{
\item{object}{An object of class ModelAudit.}

\item{...}{Other modelAudit objects to be plotted together.}

\item{error.scaled}{A logical value indicating whether ECDF should be scaled by proportions of positive and negative proportions.}

\item{outliers}{Number of outliers to be marked.}

\item{residuals}{A logical value indicating whether residuals should be marked.}

\item{y.reversed}{A logical value indicating whether values on y axis should be reversed.}
}
\value{
ggplot object
}
\description{
Cumulative Distribution Function for positive and negative residuals.
}
\examples{
library(car)
lm_model <- lm(prestige~education + women + income, data = Prestige)
lm_au <- audit(lm_model, data = Prestige, y = Prestige$prestige)
plotTwoSidedECDF(lm_au)

library(randomForest)
rf_model <- randomForest(prestige~education + women + income, data = Prestige)
rf_au <- audit(rf_model, data = Prestige, y = Prestige$prestige)
plotTwoSidedECDF(lm_au, rf_au, y.reversed = TRUE)

}
\seealso{
\code{\link{plot.modelAudit}}
}
