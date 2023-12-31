\name{lhs.plan}
\alias{lhs.plan}
\title{Tire selon le plan hyper-cube latin un \'echantillon de valeurs de param\`etres...}
\usage{lhs.plan(taille, plage, repet, tout=FALSE)
}
\description{Tire selon le plan hyper-cube latin un �chantillon de valeurs de param�tres}
\value{la matrice \eqn{N \times p} de l'�chantillon si \code{tout=FALSE}
ou une liste � 2 composantes, plan et lhs.tirage, si \code{tout=TRUE}}
\note{L'objet .factors donn� dans l'argument plage sert � sp�cifier le nom
des facteurs et les bornes de leurs intervalles d'incertitude.
L'argument repet permet d'inclure un facteur suppl�mentaire qualitatif, dont les
modalit�s sont obtenues par des tirages al�atoires ind�pendants avec remise.}
\arguments{\item{taille}{de l'�chantillon}
\item{plage}{objet de type .factors}
\item{repet}{NULL ou une ligne d'un objet de type .factors}
\item{tout}{TRUE si l'on veut conserver l'�chantillon de base dans \eqn{[0,1]^p}}
}
\examples{lhs.plan( taille = 10, plage = fungus.factors, repet = NULL, tout = FALSE)
lhs.plan( taille = 10, plage = wwdm.factors[1:7,],
                       repet = wwdm.factors[8,], tout = FALSE)}

