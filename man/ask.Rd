% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/browse.R
\name{ask}
\alias{ask}
\title{Retrieve info about the most recent NPPES Data Dissemination release}
\usage{
ask(save = FALSE, dir = NULL)
}
\arguments{
\item{save}{write to csv?; default is FALSE}

\item{dir}{directory to save to}
}
\value{
tibble with
}
\description{
Retrieve info about the most recent NPPES Data Dissemination release
}
\examples{
nppez::ask()
}
