#'@title Anomaly detector using DTW
#'@description Anomaly detection using DTW
#'The DTW is applied to the time series.
#'When seq equals one, observations distant from the closest centroids are labeled as anomalies.
#'When seq is grater than one, sequences distant from the closest centroids are labeled as discords.
#'It wraps the tsclust presented in the dtwclust library.
#'@param seq sequence size
#'@param centers number of centroids
#'@return `hanct_dtw` object
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
#'# setting up time series regression model
#'model <- hanct_dtw()
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
hanct_dtw <- function(seq = 1, centers=NA) {
  obj <- harbinger()
  obj$seq <- seq
  obj$centers <- centers

  class(obj) <- append("hanct_dtw", class(obj))
  return(obj)
}

#'@importFrom dtwclust tsclust
#'@importFrom stats na.omit
#'@exportS3Method fit hanct_dtw
fit.hanct_dtw <- function(obj, serie, ...) {
  if (is.na(obj$centers))
    obj$centers <- ceiling(log(length(serie), 10))

  data <- tspredit::ts_data(stats::na.omit(serie), obj$seq)
  data <- as.data.frame(data)

  # Apply k-means
  clusters <- dtwclust::tsclust(series = data, type = "partitional", k = obj$centers, distance = "dtw_basic")
  centroids <- NULL
  for (i in 1:length(clusters@centroids))
    centroids <- rbind(centroids, clusters@centroids[[i]])
  obj$centroids <- centroids
  return(obj)
}

#'@importFrom stats na.omit
#'@exportS3Method detect hanct_dtw
detect.hanct_dtw <- function(obj, serie, ...) {
  if(is.null(serie)) stop("No data was provided for computation", call. = FALSE)

  obj <- obj$har_store_refs(obj, serie)

  sx <- tspredit::ts_data(obj$serie, obj$seq)
  data <- as.data.frame(sx)

  res <- apply(data, 1, function(x) sqrt(min((rowSums(t(obj$centroids - x)^2)))))
  res <- obj$har_distance(res)
  anomalies <- obj$har_outliers(res)
  anomalies <- obj$har_outliers_check(anomalies, res)
  threshold <- attr(anomalies, "threshold")

  res <- c(rep(0, obj$seq - 1), res)
  anomalies <- c(rep(FALSE, obj$seq - 1), anomalies)
  attr(anomalies, "threshold") <- threshold
  detection <- obj$har_restore_refs(obj, anomalies = anomalies, res = res)

  if (obj$seq != 1) {
    i <- detection$type=="anomaly"
    detection$type[i] <- "discord"
    detection$seq[i] <- obj$seq
    detection$seqlen[i] <- obj$seq
  }

  return(detection)
}
