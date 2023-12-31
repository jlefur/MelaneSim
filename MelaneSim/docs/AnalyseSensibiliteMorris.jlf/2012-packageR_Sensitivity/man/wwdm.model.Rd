\name{wwdm.model}
\alias{wwdm.model}
\alias{wwdm.model}
\title{Mod\`ele "wwdm" pour un jeu de param\`etres}
\usage{wwdm.model(param, year, climate=wwdm.climates)
}
\description{Mod�le wwdm (winter wheat dry matter) de croissance du bl�,
mod�le de culture tr�s simple, dynamique � pas de temps journalier}
\note{Le mod�le a deux variables d'�tat, l'indice de surface foliaire (LAI) et
la biomasse a�rienne du bl� d'hiver. La sortie de la fonction est le gain de
poids journalier de la mati�re s�che en 'g per m2 per day'.
Une simulation correspond � une ann�e climatique. Par d�faut, les donn�es
climatiques sont lues dans le data.frame wwdm.climates, qui contient 14
ann�es climatiques, et l'ann�e doit �tre sp�cifi�e par un nombre entre 1 et 14.
Il y a deux fa�ons de faire cela, soit par l'argument \code{year}, soit
par la 8�me coordonn�e de l'argument \code{param} si \code{year=NULL}. Lorsque
\code{year=NULL} et qu'il n'y a que 7 coordonn�es dans \code{param}, l'ann�e
utilis�e est l'ann�e num�ro 3}
\value{vecteur des 223 gains journaliers de biomasse calcul�s par WWDM}
\references{Makowski, D., Jeuffroy, M.-H., Gu�rif, M., 2004 Bayesian methods for
updating crop model predictions, applications for predicting biomass and
grain protein content. In: Bayesian Statistics and Quality Modelling in
the Agro-Food Production Chain (van Boeakel et al. eds), pp. 57-68.
Kluwer, Dordrecht.

Monod, H., Naud, C., Makowski, D., 2006 Uncertainty and sensitivity
analysis for crop models. In: Working with Dynamic Crop Models (Wallach
D., Makowski D. and Jones J. eds), pp. 55-100. Elsevier, Amsterdam}
\arguments{\item{param}{vecteur de param�tres de wwdm de longueur 7 ou 8}
\item{year}{soit NULL soit un nombre compris entre 1 et 14}
\item{climate}{nom du data.frame contenant les donn�es climatiques}
}
\examples{#data()
#wwdm.model()
#sum( wwdm.model() )  #biomasse cumulee
#wwdm.model(param=wwdm.factors$nominal, year=NULL, climate=wwdm.climates)
#wwdm.model(param=wwdm.factors$nominal, year=5)}

