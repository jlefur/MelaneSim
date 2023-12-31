\name{wwdm.simule}
\alias{wwdm.simule}
\alias{wwdm.simule}
\title{Simulations en s\'erie du mod\`ele "wwdm"}
\usage{wwdm.simule(X, year, tout=FALSE, transfo=FALSE, 
    b1=wwdm.factors$binf[1:Nbfac], b2=wwdm.factors$bsup[1:Nbfac])
}
\description{Fonction g�rant une s�rie de simulations de wwdm, mod�le de culture dynamique
� pas de temps journalier, pour le bl�}
\note{Le mod�le a deux variables d'�tat, l'indice de surface foliaire (LAI) et
la biomasse a�rienne du bl� d'hiver. La fonction wwdm.simule ne donne
en sortie que la biomasse a�rienne accumul�e avant la r�colte, en 'g per m2'.
Une simulation correspond � une ann�e climatique. Il est possible de
pr�ciser l'ann�e climatique, soit simulation par simulation en ajoutant une
colonne 'year' � 'X', soit globalement en utilisant l'argument 'year'}
\value{Biomasse a�rienne accumul�e avant la r�colte, en g per m2}
\references{Makowski, D., Jeuffroy, M.-H., Gu�rif, M., 2004 Bayseian methods for
updating crop model predictions, applications for predicting biomass and
grain protein content. In: Bayseian Statistics and Quality Modelling in
the Agro-Food Production Chain (van Boeakel et al. eds), pp. 57-68.
Kluwer, Dordrecht

Monod, H., Naud, C., Makowski, D., 2006 Uncertainty and sensitivity
analysis for crop models. In: Working with Dynamic Crop Models (Wallach
D., Makowski D. and Jones J. eds), pp. 55-100. Elsevier, Amsterdam}
\arguments{\item{X}{dataframe � 7 ou 8 colonnes de valeurs des param�tres de wwdm}
\item{year}{soit NULL, soit une valeur unique entre 1 et 14}
\item{tout}{TRUE si l'on veut les entr�es ET les sorties dans le tableau de sortie}
\item{transfo}{TRUE si X contient des valeurs cod�es entre 0 et 1}
\item{b1}{vecteur des 7 ou 8 bornes inf�rieures des param�tres si transfo=TRUE}
\item{b2}{vecteur des 7 ou 8 bornes sup�rieures des param�tres si transfo=TRUE}
}
\examples{jeux.parametres <- as.data.frame(rbind(wwdm.factors$binf,
                     wwdm.factors$nominal, wwdm.factors$bsup))
names(jeux.parametres) <- wwdm.factors$name
wwdm.simule(jeux.parametres)}

