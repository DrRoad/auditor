#' @title Model diagnostic plots
#'
#' @description This function provides several diagnostic plots for regression and classification models.
#'
#' @param x object of class modelAudit, modelResiduals or observationInfluence.
#' @param ... other arguments dependent on the type of plot or additionl objects of class modelAudit
#' @param type the type of plot. Possible values: 'ACF', 'Autocorrelation', 'CooksDistance', 'HalfNormal', 'Residuals', 'LIFT',
#' ModelPCA', 'ModelRanking', ModelCorrelation', 'Prediction', 'REC', 'Resiual', 'ResidualBoxplot',ResidualDensity', 'ROC', 'RROC',
#' ScaleLocation', 'TwoSidedECDF' (for detailed description see functions in see also section).
#' @param ask logical; if TRUE, the user is asked before each plot, see \code{\link[graphics]{par}(ask=)}.
#' @param grid logical; if TRUE plots will be plotted on the grid.
#'
#' @seealso \code{\link{plotACF}, \link{plotAutocorrelation}, \link{plotCooksDistance},
#' \link{plotHalfNormal}, \link{plotResidual}, \link{plotResidualBoxplot}, \link{plotLIFT}, \link{plotModelPCA}, \link{plotModelRanking}, \link{plotModelCorrelation},
#' \link{plotPrediction}, \link{plotREC}, \link{plotResidualDensity}, \link{plotResidual}, \link{plotROC},
#' \link{plotRROC}, \link{plotScaleLocation}, \link{plotTwoSidedECDF}}
#'
#' @examples
#' library(car)
#' lm_model <- lm(prestige~education + women + income, data = Prestige)
#' lm_au <- audit(lm_model, data = Prestige, y = Prestige$prestige)
#' plot(lm_au)
#'
#' library(randomForest)
#' rf_model <- randomForest(prestige~education + women + income, data = Prestige)
#' rf_au <- audit(rf_model, data = Prestige, y = Prestige$prestige)
#' plot(lm_au, rf_au, type = "ModelRanking")
#'
#'
#' @importFrom grDevices devAskNewPage
#' @importFrom graphics plot
#' @importFrom gridExtra grid.arrange
#'
#' @method plot modelAudit
#'
#' @export

plot.modelAudit <- function(x, ..., type="Residual", ask = TRUE, grid = TRUE){
  if("observationInfluence" %in% class(x)) type <- "CooksDistance"
  if("modelPerformance" %in% class(x)) type <- "ModelRanking"
  if("modelFit" %in% class(x)) type <- "HalfNormal"
  object <- x

  plotNames <- c('ACF', 'Autocorrelation', 'CooksDistance', 'HalfNormal', 'Residual', 'LIFT',
                 'ModelPCA', 'ModelRanking', 'ModelCorrelation', 'Prediction', 'REC', 'ResidualBoxplot', 'ResidualDensity', 'Residual', 'ROC', 'RROC',
                 'ScaleLocation', 'TwoSidedECDF')

  if(!all(type %in% plotNames)){
    stop(paste0("Invalid plot type. Possible values are: ", paste(plotNames, collapse = ", "),"."))
  }

  if (length(type)==1) {
    return(plotTypePlot(object, ..., type = type))
  }

  if (ask & length(type) & (grid == FALSE)) {
    oask <- devAskNewPage(TRUE)
    on.exit(devAskNewPage(oask))
  }

  plotsList <- sapply(type, function(x) NULL)

  if(grid == TRUE) {
    for(name in type){
      plotsList[[name]] <- plotTypePlot(object, ..., type = name)
    }
    do.call(grid.arrange, args = plotsList)
  } else {
    for(name in type){
      plotsList[[name]] <- plotTypePlot(object, ..., type = name)
      plot(plotsList[[name]])
    }
    class(plotsList) <- c("auditorPlotList", "list")
    return(plotsList)
  }

}

plotTypePlot <- function(x, ..., type){
  switch(type,
         ACF = { return(plotACF(x, ...)) },
         Autocorrelation = { return(plotAutocorrelation(x, ...)) },
         CooksDistance = { return(plotCooksDistance(x, ...)) },
         HalfNormal = { return(plotHalfNormal(x, ...)) },
         LIFT = {return(plotLIFT(x, ...))},
         ModelPCA = {return(plotModelPCA(x, ...))},
         ModelRanking = {return(plotModelRanking(x, ...))},
         ModelCorrelation = {return(plotModelCorrelation(x, ...))},
         Prediction = {return(plotPrediction(x, ...))},
         REC = { return(plotREC(x, ...)) },
         ResidualBoxplot = {return(plotResidualBoxplot(x, ...))},
         ResidualDensity = { return(plotResidualDensity(x, ...)) },
         Residual = { return(plotResidual(x, ...)) },
         ROC = { return(plotROC(x, ...)) },
         RROC = { return(plotRROC(x, ...)) },
         ScaleLocation = { return(plotScaleLocation(x, ...)) },
         TwoSidedECDF = { return(plotTwoSidedECDF(x, ...)) }
  )
}


