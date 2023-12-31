\name{TP1pavage}
\alias{TP1pavage}
\title{Construction du plan avec tirage dans les pav\'es d\'efini par un plan P...}
\usage{TP1pavage(P, nrep=3, Nbclass=2, binf, bsup)
}
\description{Construction du plan avec tirage dans les pav�s d�fini par un plan P}
\value{liste contenant les matrices des coordonn�es enti�res (Plan.rep) et
r�elles (xx) des points tir�s au hasard}
\arguments{\item{P}{matrice � Nbfac colonnes  cod�e par des entiers de 1 � Nbclass}
\item{nrep}{nbre de tirages par pav� [entier]}
\item{Nbclass}{niveau de discr�tisation des gammes des facteurs}
\item{binf}{vecteur des bornes inf des gammes des facteurs}
\item{bsup}{= vecteur des bornes sup des gammes des facteurs}
}
\examples{TP1pavage( rbind(1:3,c(2,2,2)),binf=c(-10,0,100),bsup=c(10,5,600),Nbclass=5)}

