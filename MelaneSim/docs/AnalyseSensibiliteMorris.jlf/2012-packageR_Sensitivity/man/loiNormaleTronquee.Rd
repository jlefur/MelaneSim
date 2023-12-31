\name{loiNormaleTronquee}
\alias{loiNormaleTronquee}
\alias{loiNormaleTronquee}
\title{The Truncated Normal distribution}
\usage{dtnorm(x, mean = 0, sd = 1, min = -1e6, max = 1e6)

ptnorm(q, mean = 0, sd = 1, min = -1e6, max = 1e6)

qtnorm(p, mean = 0, sd = 1, min = -1e6, max = 1e6)

rtnorm(n, mean = 0, sd = 1, min = -1e6, max = 1e6)}
\description{Fonctions associ�es � la loi Normale tronqu�e}
\alias{dtnorm}
\alias{ptnorm}
\alias{qtnorm}
\alias{rtnorm}
\value{densit�s, probabilit�s, quantiles, �chantillon al�atoire}
\arguments{\item{x}{vecteur de quantiles}
\item{q}{vecteur de quantiles}
\item{p}{vecteur de probabilit�s}
\item{n}{taille de l'�chantillon al�atoire � g�n�rer}
\item{mean}{moyenne de la loi � tronquer}
\item{sd}{�cart-type de la loi � tronquer}
\item{min}{borne inf�rieure de la troncature}
\item{max}{borne sup�rieure de la troncature}
}

