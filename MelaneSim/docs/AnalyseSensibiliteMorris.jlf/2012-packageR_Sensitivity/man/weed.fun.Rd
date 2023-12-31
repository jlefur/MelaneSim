\name{weed.fun}
\alias{weed.fun}
\title{Fonction de base du mod\`ele "Weed"}
\usage{weed.fun(decision, param)
}
\description{Fonction de base du mod�le "Weed": calcul sur 1 ann�e du mod�le "Weed".}
\value{un vecteur de longueur 5 compos� de:
\itemize{
\item{S}{production de graines par eqn(m^2)}
\item{d}{densit� d'adventices � l'�mergence (plantes par eqn(m^2))}
\item{SSBa}{banque de graines en surface apr�s travail du sol (graines par eqn(m^2))}
\item{DSBa}{banque de graines en profondeur apr�s travail du sol (graines par eqn(m^2))}
\item{Yield}{rendement (t par ha)}
}}
\arguments{\item{decision}{data.frame � 1 ligne et 3 colonnes Soil, Crop, Herb}
\item{param}{vecteur des param�tres:
mu, v, phi, beta.1, beta.0, chsi.1, chsi.0,
delta.new, delta.old, mh, mc, Smax.1, Smax.0,
Ymax, rmax, gamma
et des variables d'�tat initiales
d.im1, S.im1, SSBa.im1, DSBa.im1 (d,S,SSBa,DSBa)}
}

