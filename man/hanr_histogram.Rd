% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/hanr_hist.R
\name{hanr_histogram}
\alias{hanr_histogram}
\title{Anomaly detector using histogram}
\usage{
hanr_histogram(density_threshold = 0.05)
}
\arguments{
\item{density_threshold}{It is the minimum frequency for a bin to not be considered an anomaly. Default value is 5\%.}
}
\value{
hanr_histogram object
histogram based method to detect anomalies in time series. Bins with smaller amount of observations are considered anomalies. Values below first bin or above last bin are also considered anomalies.>.
}
\description{
Anomaly detector using histogram
}
\examples{
library(daltoolbox)

#loading the example database
data(examples_anomalies)

#Using simple example
dataset <- examples_anomalies$simple
head(dataset)

# setting up time series regression model
model <- hanr_histogram()

# fitting the model
model <- fit(model, dataset$serie)

detection <- detect(model, dataset$serie)

# filtering detected events
print(detection[(detection$event),])

}
