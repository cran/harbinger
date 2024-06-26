% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/hmo_mp.R
\name{hmo_mp}
\alias{hmo_mp}
\title{Motif discovery using Matrix Profile}
\usage{
hmo_mp(mode = "stamp", w, qtd)
}
\arguments{
\item{mode}{mode of computing distance between sequences. Available options include: "stomp", "stamp", "simple", "mstomp", "scrimp", "valmod", "pmp"}

\item{w}{word size}

\item{qtd}{number of occurrences to be classified as motifs}
}
\value{
\code{hmo_mp} object
}
\description{
Motif discovery using Matrix Profile \url{doi:10.32614/RJ-2020-021}
}
\examples{
library(daltoolbox)

#loading the example database
data(examples_motifs)

#Using sequence example
dataset <- examples_motifs$simple
head(dataset)

# setting up motif discovery method
model <- hmo_mp("stamp", 4, 3)

# fitting the model
model <- fit(model, dataset$serie)

detection <- detect(model, dataset$serie)

# filtering detected events
print(detection[(detection$event),])

}
