% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/hanc_ml.R
\name{hanc_ml}
\alias{hanc_ml}
\title{Anomaly detector based on machine learning classification}
\usage{
hanc_ml(model, threshold = 0.5)
}
\arguments{
\item{model}{DALToolbox classification model}

\item{threshold}{threshold for classification}
}
\value{
\code{hanc_ml} object
}
\description{
Anomaly detection using daltoolbox classification.
A training and test set should be used. The training set must contain labeled events.
A set of preconfigured of classification methods are described in \url{https://cefet-rj-dal.github.io/daltoolbox/}.
They include: cla_majority, cla_dtree, cla_knn, cla_mlp, cla_nb, cla_rf, cla_svm
}
\examples{
library(daltoolbox)

#loading the example database
data(examples_anomalies)

#Using example tt
dataset <- examples_anomalies$tt
dataset$event <- factor(dataset$event, labels=c("FALSE", "TRUE"))
slevels <- levels(dataset$event)

# separating into training and test
train <- dataset[1:80,]
test <- dataset[-(1:80),]

# normalizing the data
norm <- minmax()
norm <- fit(norm, train)
train_n <- daltoolbox::transform(norm, train)

# establishing decision tree method
model <- hanc_ml(cla_dtree("event", slevels))

# fitting the model
model <- fit(model, train_n)

# evaluating the detections during testing
test_n <- daltoolbox::transform(norm, test)

detection <- detect(model, test_n)
print(detection[(detection$event),])

}
