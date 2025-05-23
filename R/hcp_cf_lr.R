#'@title Change Finder using LR
#'@description Change-point detection is related to event/trend change detection. Change Finder LR detects change points based on deviations relative to linear regression model <doi:10.1109/TKDE.2006.1599387>.
#'@param sw_size Sliding window size
#'@return `hcp_cf_lr` object
#'@examples
#'library(daltoolbox)
#'
#'#loading the example database
#'data(examples_changepoints)
#'
#'#Using simple example
#'dataset <- examples_changepoints$simple
#'head(dataset)
#'
#'# setting up change point method
#'model <- hcp_cf_lr()
#'
#'# fitting the model
#'model <- fit(model, dataset$serie)
#'
# making detection using hanr_ml
#'detection <- detect(model, dataset$serie)
#'
#'# filtering detected events
#'print(detection[(detection$event),])
#'
#'@export
hcp_cf_lr <- function(sw_size = 30) {
  obj <- harbinger()

  obj$sw_size <- sw_size
  class(obj) <- append("hcp_cf_lr", class(obj))
  return(obj)
}

#'@importFrom stats lm
#'@importFrom stats na.omit
#'@importFrom stats residuals
#'@exportS3Method detect hcp_cf_lr
detect.hcp_cf_lr <- function(obj, serie, ...) {
  linreg <- function(serie) {
    data <- data.frame(t = 1:length(serie), x = serie)
    return(stats::lm(x~t, data))
  }

  obj <- obj$har_store_refs(obj, serie)

  #Adjusting a model to the entire series
  model <- linreg(obj$serie)

  #Adjustment error on the entire series
  res <- stats::residuals(model)

  res <- obj$har_distance(res)
  anomalies <- obj$har_outliers(res)

  anomalies <- obj$har_outliers_check(anomalies, res)

  anomalies[1:obj$sw_size] <- FALSE

  y <- mas(res, obj$sw_size)

  #Adjusting to the entire series
  M2 <- linreg(y)

  #Adjustment error on the whole window
  u <- obj$har_distance(stats::residuals(M2))

  u <- mas(u, obj$sw_size)
  cp <- obj$har_outliers(u)
  cp <- obj$har_outliers_check(cp, u)
  cp[1:obj$sw_size] <- FALSE
  cp <- c(rep(FALSE, length(res)-length(u)), cp)

  detection <- obj$har_restore_refs(obj, anomalies = anomalies, change_points = cp, res = res)

  return(detection)
}

