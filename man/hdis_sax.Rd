% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/hdis_sax.R
\name{hdis_sax}
\alias{hdis_sax}
\title{Discord discovery using SAX}
\usage{
hdis_sax(a, w, qtd = 2)
}
\arguments{
\item{a}{alphabet size}

\item{w}{word size}

\item{qtd}{number of occurrences to be classified as discords}
}
\value{
\code{hdis_sax} object
}
\description{
Discord discovery using SAX \url{doi:10.1007/s10618-007-0064-z}
}
\examples{
library(daltoolbox)

#loading the example database
data(examples_motifs)

#Using sequence example
dataset <- examples_motifs$simple
head(dataset)

# setting up discord discovery method
model <- hdis_sax(26, 3, 3)

# fitting the model
model <- fit(model, dataset$serie)

detection <- detect(model, dataset$serie)

# filtering detected events
print(detection[(detection$event),])

}
