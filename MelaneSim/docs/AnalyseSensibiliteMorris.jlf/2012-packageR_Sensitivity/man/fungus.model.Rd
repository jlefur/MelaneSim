\name{fungus.model}
\alias{fungus.model}
\title{Mod\`ele "fungus" (croissance champignon selon l'humidit\'e)...}
\usage{fungus.model(param=fungus.factors$nominal, temperature=10)
}
\description{Mod�le "fungus" (croissance champignon selon l'humidit�)}
\note{Des valeurs min, max et nominales des param�tres sont donnees
dans fungus.factors. Elles correspondent � Alternaria
Brassicae, ravageur du colza (Magarey et al, 2005).}
\value{scalaire ou vecteur de longueur egale au nombre de temperatures}
\references{Magarey RD, Sutton TB, Thayer CL (2005). A simple generic infection
model for foliar fungal plant pathogens. Phytopathology 95, 92-100.}
\arguments{\item{param}{vecteur de longueur 5 comprenant un jeu de valeurs de Tmin, Topt, Tmax, Wmin, Wmax}
\item{temperature}{scalaire ou vecteur de temperatures}
}
\examples{fungus.model( fungus.factors$nominal, temperature=c(10,15,18,21,30) )}

