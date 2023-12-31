\name{loiGumbelTronquee}
\alias{loiGumbelTronquee}
\alias{loiGumbelTronquee}
\title{The Truncated Gumbel distribution}
\usage{dtgumbel(x, loc = 0, scale = 1, min = -1e6, max = 1e6)

ptgumbel(q, loc = 0, scale = 1, min = -1e6, max = 1e6)

qtgumbel(p, loc = 0, scale = 1, min = -1e6, max = 1e6)

rtgumbel(n, loc = 0, scale = 1, min = -1e6, max = 1e6)}
\description{Fonctions associ�es � la loi de Gumbel tronqu�e}
\alias{dtgumbel}
\alias{ptgumbel}
\alias{qtgumbel}
\alias{rtgumbel}
\value{densit�s, probabilit�s, quantiles, �chantillon al�atoire}
\arguments{\item{x}{vecteur de quantiles}
\item{q}{vecteur de quantiles}
\item{p}{vecteur de probabilit�s}
\item{n}{taille de l'�chantillon al�atoire � g�n�rer}
\item{loc}{param�tre de position de la loi � tronquer}
\item{scale}{param�tre d'�chelle de la loi � tronquer}
\item{min}{borne inf�rieure de la troncature}
\item{max}{borne sup�rieure de la troncature}
}

