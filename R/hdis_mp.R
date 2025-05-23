#'@title Discord discovery using Matrix Profile
#'@description Discord discovery using Matrix Profile <doi:10.32614/RJ-2020-021>
#'@param mode mode of computing distance between sequences. Available options include: "stomp", "stamp", "simple", "mstomp", "scrimp", "valmod", "pmp"
#'@param w word size
#'@param qtd number of occurrences to be classified as discords
#'@return `hdis_mp` object
#'@examples
#'library(daltoolbox)
#'
#'#loading the example database
#'data(examples_motifs)
#'
#'#Using sequence example
#'dataset <- examples_motifs$simple
#'head(dataset)
#'
#'# setting up discord discovery method
#'model <- hdis_mp("stamp", 4, 3)
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
hdis_mp <- function(mode = "stamp", w, qtd) {
  obj <- harbinger()
  obj$mode <- mode #"stamp", "stomp", "scrimp"
  obj$w <- w
  obj$qtd <- qtd
  class(obj) <- append("hdis_mp", class(obj))
  return(obj)
}

#'@importFrom tsmp tsmp
#'@importFrom tsmp find_motif
#'@exportS3Method detect hdis_mp
detect.hdis_mp <- function(obj, serie, ...) {
  if(is.null(serie)) stop("No data was provided for computation", call. = FALSE)

  n <- length(serie)
  non_na <- which(!is.na(serie))

  serie <- stats::na.omit(serie)

  if(is.null(serie)) stop("No data was provided for computation", call. = FALSE)
  if(!(is.numeric(obj$w)&&(obj$w >=4))) stop("Window size must be at least 4", call. = FALSE)
  if(!(is.numeric(obj$qtd)&&(obj$qtd >=3))) stop("the number of selected discords must be greater than 3", call. = FALSE)

  discords <- tsmp::tsmp(serie, window_size = obj$w, mode = obj$mode)
  discords <- tsmp::find_discord(discords, qtd = obj$qtd)

  outliers <- data.frame(event = rep(FALSE, length(serie)), seq = rep(NA, length(serie)))
  for (i in 1:length(discords$discord$discord_idx)) {
    mot <- discords$discord$discord_idx[[i]]
    mot <- c(mot, discords$discord$discord_neighbor[[i]])
    outliers$event[mot] <- TRUE
    outliers$seq[mot] <- as.character(i)
  }

  detection <- data.frame(idx=1:n, event = FALSE, type="", seq=NA, seqlen = NA)
  detection$event[non_na] <- outliers$event
  detection$type[detection$event[non_na]] <- "motif"
  detection$seq[non_na] <- outliers$seq
  detection$seqlen[detection$event] <- obj$w
  return(detection)
}


