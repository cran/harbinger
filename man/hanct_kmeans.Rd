% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/hanct_kmeans.R
\name{hanct_kmeans}
\alias{hanct_kmeans}
\title{Anomaly detector using kmeans}
\usage{
hanct_kmeans(seq = 1, centers = NA)
}
\arguments{
\item{seq}{sequence size}

\item{centers}{number of centroids}
}
\value{
\code{hanct_kmeans} object
}
\description{
Anomaly detection using kmeans
The kmeans is applied to the time series.
When seq equals one, observations distant from the closest centroids are labeled as anomalies.
When seq is grater than one, sequences distant from the closest centroids are labeled as discords.
It wraps the kmeans presented in the stats library.
}
\examples{
library(daltoolbox)

#loading the example database
data(examples_anomalies)

#Using simple example
dataset <- examples_anomalies$simple
head(dataset)

# setting up time series regression model
model <- hanct_kmeans()

# fitting the model
model <- fit(model, dataset$serie)

detection <- detect(model, dataset$serie)

# filtering detected events
print(detection[(detection$event),])

}
