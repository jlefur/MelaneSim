\name{weed.simule}
\alias{weed.simule}
\title{Simulations en s\'erie du mod\`ele "Weed"}
\usage{weed.simule(X, decision=weed.decision, sortie="rdt.total",
     nom.sortie, tout=FALSE)
}
\description{Simulations en s�rie du mod�le "Weed"}
\note{Le param�tre 'sortie' peut �tre:
\itemize{
\item soit une fonction calculant la ou les variables de sortie de chaque
simulation � partir du tableau n x 5 des sorties de 'weed.model';
\item soit un mot-cle pr�-d�fini:
\itemize{
\item{annee.finale}{pour avoir les 5 sorties de la derni�re ann�e;}
\item{rdt.total}{pour avoir la somme des rendements sur les n annees (defaut);}
\item{banque.finale}{pour avoir la banque de graines en derniere annee.}
}}
Pour rappel, les 5 sorties de 'weed.model' sont:
\itemize{
\item{S}{production de graines par eqn(m^2)}
\item{d}{densit� d'adventices � l'�mergence (plantes par eqn(m^2))}
\item{SSBa}{banque de graines en surface apr�s travail du sol (graines par eqn(m^2))}
\item{DSBa}{banque de graines en profondeur apr�s travail du sol (graines par eqn(m^2))}
\item{Yield}{rendement (t par ha)}
}}
\value{un data.frame incluant en colonnes la ou les sorties retenues. Suivant la
valeur de 'tout', les entr�es sont restitu�es ou non.}
\arguments{\item{X}{matrice ou data.frame des jeux de param�tres:
mu, v, phi, beta.1, beta.0, chsi.1, chsi.0,
delta.new, delta.old, mh, mc, Smax.1, Smax.0,
Ymax, rmax, gamma
et des variables d'�tat initiales
d.im1, S.im1, SSBa.im1, DSBa.im1 (d,S,SSBa,DSBa)}
\item{decision}{data.frame � 3 colonnes Soil, Crop, Herb et n
lignes, o� n est le nombre d'ann�es simul�es}
\item{sortie}{fonction ou mot-cl� donnant la nature de la ou des variables
en sortie de chaque simulation (voir DETAILS)}
\item{nom.sortie}{noms de la ou des variables de sortie retenues}
\item{tout}{TRUE si l'on veut les entr�es ET les sorties dans le tableau de sortie}
}
\examples{jeux.param <- rbind(weed.factors$binf, weed.factors$nominal, weed.factors$bsup)
weed.simule( jeux.param, sortie=function(x){sum(x[,5])}, nom.sortie="rdt.total")
weed.simule( jeux.param, sortie="annee.finale", nom.sortie="rdt.total")}

