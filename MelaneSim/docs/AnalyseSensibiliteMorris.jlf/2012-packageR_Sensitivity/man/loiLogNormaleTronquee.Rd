\name{loiLogNormaleTronquee}
\alias{loiLogNormaleTronquee}
\alias{loiLogNormaleTronquee}
\title{The Truncated LogNormal distribution}
\usage{dtlnorm(x, meanlog = 0, sdlog = 1, min = -1e6, max = 1e6)

ptlnorm(q, meanlog = 0, sdlog = 1, min = -1e6, max = 1e6)

qtlnorm(p, meanlog = 0, sdlog = 1, min = -1e6, max = 1e6)

rtlnorm(n, meanlog = 0, sdlog = 1, min = -1e6, max = 1e6)}
\description{Fonctions associ�es � la loi LogNormale tronqu�e}
\alias{dtlnorm}
\alias{ptlnorm}
\alias{qtlnorm}
\alias{rtlnorm}
\value{densit�s, probabilit�s, quantiles, �chantillon al�atoire}
\arguments{\item{x}{vecteur de quantiles}
\item{q}{vecteur de quantiles}
\item{p}{vecteur de probabilit�s}
\item{n}{taille de l'�chantillon al�atoire � g�n�rer}
\item{meanlog}{moyenne de la loi � tronquer}
\item{sdlog}{�cart-type de la loi � tronquer}
\item{min}{borne inf�rieure de la troncature}
\item{max}{borne sup�rieure de la troncature}
}

