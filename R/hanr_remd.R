#'@title Anomaly detector using REMD
#'@description Anomaly detection using REMD
#'The EMD model adjusts to the time series. Observations distant from the model are labeled as anomalies.
#'It wraps the EMD model presented in the forecast library.
#'@param noise nosie
#'@param trials trials
#'@return `hanr_remd` object
#'
#'@examples
#'library(daltoolbox)
#'
#'#loading the example database
#'data(examples_anomalies)
#'
#'#Using simple example
#'dataset <- examples_anomalies$simple
#'head(dataset)
#'
#'# setting up time series emd detector
#'model <- hanr_remd()
#'
#'# fitting the model
#'model <- fit(model, dataset$serie)
#'
# making detection
#'detection <- detect(model, dataset$serie)
#'
#'# filtering detected events
#'print(detection[(detection$event),])
#'
#'@export
hanr_remd <- function(noise = 0.1, trials = 5) {
  obj <- hanr_emd(noise, trials)
  class(obj) <- append("hanr_remd", class(obj))
  return(obj)
}

#'@importFrom stats median
#'@importFrom stats sd
fc_roughness <- function(x) {
  firstD = diff(x)
  normFirstD = (firstD - mean(firstD)) / sd(firstD)
  roughness = (diff(normFirstD) ** 2) / 4
  return(mean(roughness))
}

#'@importFrom stats median
#'@importFrom stats sd
#'@importFrom hht CEEMD
#'@export
detect.hanr_remd <- function(obj, serie, ...) {
  if (is.null(serie))
    stop("No data was provided for computation", call. = FALSE)

  obj <- obj$har_store_refs(obj, serie)

  id <- 1:length(obj$serie)
  obj$sw_size <-  length(obj$serie)

  suppressWarnings(ceemd.result <- hht::CEEMD(obj$serie, id, verbose = FALSE, obj$noise, obj$trials))

  obj$model <- ceemd.result
  ## calculate roughness for each imf
  vec <- vector()
  for (n in 1:obj$model$nimf) {
    vec[n] <- fc_roughness(obj$model[["imf"]][, n])
  }

  vec <- cumsum(vec)

  ## Maximum curvature
  res <- transform(fit_curvature_min(), vec)
  div <- res$x
  sum_high_freq <- obj$model[["imf"]][, 1]

  if (div > 1) {
    for (k in 2:div) {
      sum_high_freq <- sum_high_freq + obj$model[["imf"]][, k]
    }
  }

  ts <- ts_data(sum_high_freq, 0)
  io <- ts_projection(ts)
  model <- ts_arima()
  model <- fit(model, x = io$input, y = io$output)
  adjust <- predict(model, io$input)
  adjust <- as.vector(adjust)

  # Calculation of inverse probability
  res <- abs(adjust - sum_high_freq)
  probabilidades <-(1 - res / max(res))
  anomalies <- which(abs(probabilidades)<2.698*sd(probabilidades, na.rm=TRUE))
  anomalies <- obj$har_outliers_group(anomalies, length(res))

  detection <- obj$har_restore_refs(obj, anomalies = anomalies)

  return(detection)
}
