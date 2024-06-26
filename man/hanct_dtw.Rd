% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/hanct_dtw.R
\name{hanct_dtw}
\alias{hanct_dtw}
\title{Anomaly detector using DTW}
\usage{
hanct_dtw(seq = 1, centers = NA)
}
\arguments{
\item{seq}{sequence size}

\item{centers}{number of centroids}
}
\value{
\code{hanct_dtw} object
}
\description{
Anomaly detection using DTW
The DTW is applied to the time series.
When seq equals one, observations distant from the closest centroids are labeled as anomalies.
When seq is grater than one, sequences distant from the closest centroids are labeled as discords.
It wraps the tsclust presented in the dtwclust library.
}
\examples{
library(daltoolbox)

#loading the example database
data(examples_anomalies)

#Using simple example
dataset <- examples_anomalies$simple
head(dataset)

# setting up time series regression model
model <- hanct_dtw()

# fitting the model
model <- fit(model, dataset$serie)

detection <- detect(model, dataset$serie)

# filtering detected events
print(detection[(detection$event),])

}
