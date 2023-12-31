# ECOLE-CHERCHEURS MEXICO, GIENS 2012

# Fichier source des fonctions et structures associees aux modeles
# fungus, ishigami, weed et wwdm

#' Facteurs d'entr�e du mod�le "fungus" (croissance champignon selon l'humidit�)
#' @docType data
#' @title Facteurs d'entr�e de l'AS du mod�le "fungus"
#' @return data.frame � 5 lignes (facteurs) et 4 colonnes (sp�cifs)
#' @note Les valeurs dans fungus.factors correspondent � Alternaria Brassicae,
#' ravageur du colza (Magarey et al, 2005)

fungus.factors <-
		structure(list(nominal = c(4.5, 9, 20, 4.5, 9.5),
                               binf = c(2.6, 8, 18, 4, 8),
                               bsup = c(6, 10, 22, 5, 11),
                               name = structure(c(2L, 3L, 1L, 5L, 4L),
                                 .Label = c("Tmax", "Tmin", "Topt", "Wmax", "Wmin"),
                                 class = "factor")),
                          .Names = c("nominal", "binf", "bsup", "name"),
                          row.names = c("Tmin", "Topt", "Tmax", "Wmin", "Wmax"),
                          class = "data.frame")

#' Mod�le "fungus" (croissance champignon selon l'humidit�)
#' @param param vecteur de longueur 5 comprenant un jeu de valeurs de Tmin, Topt, Tmax, Wmin, Wmax
#' @param temperature scalaire ou vecteur de temperatures
#' @note Des valeurs min, max et nominales des param�tres sont donnees
#'  dans fungus.factors. Elles correspondent � Alternaria
#'  Brassicae, ravageur du colza (Magarey et al, 2005).
#' @return scalaire ou vecteur de longueur egale au nombre de temperatures
#' @references Magarey RD, Sutton TB, Thayer CL (2005). A simple generic infection
#'  model for foliar fungal plant pathogens. Phytopathology 95, 92-100.
#' @examples  fungus.model( fungus.factors$nominal, temperature=c(10,15,18,21,30) )

fungus.model <-
function(param=fungus.factors$nominal, temperature=10)
  {
   if(class(param)=="numeric"){param <- as.data.frame(as.list(param))}
    names(param) = fungus.factors$name

    Tmin = param$Tmin
    Tmax= param$Tmax
    Topt=param$Topt
    Wmin=param$Wmin
    Wmax=param$Wmax


    FdeT=((Tmax - temperature)/(Tmax-Topt))*
      ((temperature-Tmin)/(Topt-Tmin))** ((Topt-Tmin)/(Tmax-Topt))


    W = Wmin/FdeT
    # On corrige lorsqu'on est en dehors du domaine
    W[temperature >= Tmax] = Wmax
    W[temperature <= Tmin ] = Wmax
    # Correction de base
    W[W > Wmax] = Wmax


    W
  }

#' Simulation du mod�le "fungus"
#' @param X vecteur de longueur 5 ou matrice N x 5 comprenant un
#'          ou plusieurs jeux de valeurs de
#'          Tmin, Topt, Tmax, Wmin, Wmax
#' @param temperature scalaire ou vecteur de temperatures
#' @param tout TRUE si l'on veut les entr�es ET les sorties dans le tableau de sortie
#' @note  Des valeurs min, max et nominales des param�tres sont donnees
#'  dans fungus.factors. Elles correspondent � Alternaria
#'  Brassicae, ravageur du colza (Magarey et al, 2005).
#' @return Data.frame a N lignes et p colonnes, ou p est la longueur de 'temperature'
#' @references Magarey RD, Sutton TB, Thayer CL (2005). A simple generic infection
#'  model for foliar fungal plant pathogens. Phytopathology 95, 92-100.
#' @examples
#' scenarios <- rbind(fungus.factors$binf,fungus.factors$nominal,fungus.factors$bsup)
#' fungus.simule( scenarios, temperature=c(10,15,18,21,30) )

fungus.simule <-
		function(X, temperature=10, tout=FALSE)
{
	if(is.null(dim(X))) X = matrix(X,nrow=1)

	res = t(apply(X,1,fungus.model,temperature=temperature))
	res=as.data.frame(res)
	names(res) <- paste("T.",temperature,sep="")

	if (tout) res  = cbind(X,res)
	return(res)
}

#' Facteurs d'entr�e du mod�le Ishigami, d�crit dans \cite{Saltelli et al., 2000}
#' @docType data
#' @return data.frame � 3 lignes (facteurs) et 4 colonnes (sp�cifs)
#' @title Facteurs d'entr�e du mod�le Ishigami

ishigami.factors <-
structure(list(nominal = c(0, 0, 0), binf = c(-3.14159265358979,
-3.14159265358979, -3.14159265358979), bsup = c(3.14159265358979,
3.14159265358979, 3.14159265358979), name = structure(1:3, .Label = c("x1",
"x2", "x3"), class = "factor")), .Names = c("nominal", "binf",
"bsup", "name"), row.names = c("x1", "x2", "x3"), class = "data.frame")

#' Mod�le d'Ishigami
#' @title Mod�le d'Ishigami, d�crit dans Saltelli et al., 2000
#' @param param vecteur de longueur 3 ou  matrice N x 3 des param�tres
#'          chacun des param�tres doit varier entre -pi et +pi
#' @return scalaire, ou vecteur de longueur N
#' @note Appelle la fonction ishigami.fun de la librairie sensitivity
#' @examples
#'  ishigami.model( c(-1,0,-1) )
#'  ishigami.model( rbind( c(1,1,1),c(-1,0,-1) )  )

ishigami.model <-
		function(param=ishigami.factors$nominal)
{
	if(length(param) == length(ishigami.factors$nominal) ){
		x = matrix(param,nrow=1)
	}
	else x <- param
	return(ishigami.fun(x))
}

#' Simulation du mod�le d'Ishigami
#' @title Simulation du mod�le d'Ishigami, d�crit dans Saltelli et al., 2000
#' @param X matrice ou dataframe N x 3 des valeurs d'entr�e, comprises entre -pi et +pi
#' @param tout TRUE si l'on veut les entr�es ET les sorties dans le tableau de sortie
#' @return matrice ou dataframe si 'tout==TRUE', un vecteur sinon
#' @note Appelle la fonction ishigami.fun de la librairie sensitivity
#' @examples
#'  ishigami.simule( c(-1,0,-1) )
#'  ishigami.simule( rbind( c(1,1,1),c(-1,0,-1) )  )

ishigami.simule <-
		function(X, tout=FALSE)
{

	if(is.null(dim(X))) X = matrix(X,nrow=1)

	res = t(apply(X,1,ishigami.model))
	res = c(res)  #res=as.data.frame(res)
	if (tout) res  = cbind(X,res)
	return(res)
}

#' Dataframe des d�cisions par d�faut pour le mod�le "Weed"
#' @docType data
#' @return data.frame � 8 lignes (ann�es) et 3 colonnes (facteurs)
#' @title D�cisions par d�faut pour le mod�le "Weed"

weed.decision <-
structure(list(Soil.vec = c(1, 1, 1, 0, 1, 0, 1, 0), Crop.vec = c(1,
1, 1, 1, 1, 1, 0, 1), Herb.vec = c(1, 1, 1, 1, 1, 1, 1, 1)), .Names = c("Soil.vec",
"Crop.vec", "Herb.vec"), row.names = c(NA, -8L), class = "data.frame")

#' Facteurs d'entr�e du mod�le "Weed" (ou "mauvaises herbes")
#' @docType data
#' @return data.frame � 20 lignes (facteurs) et 4 colonnes (sp�cifs)
#' @title Facteurs d'entr�e du mod�le "Weed"

weed.factors <-
structure(list(nominal = c(0.84, 0.6, 0.55, 0.95, 0.2, 0.3, 0.05,
0.15, 0.3, 0.98, 0, 445, 296, 8, 0.002, 0.005, 400, 10000, 3350,
280), binf = c(0.756, 0.54, 0.495, 0.855, 0.18, 0.27, 0.045,
0.135, 0.27, 0.882, 0, 400.5, 266.4, 7.2, 0.0018, 0.0045, 300,
7500, 2512.5, 210), bsup = c(0.924, 0.66, 0.605, 1.045, 0.22,
0.33, 0.055, 0.165, 0.33, 1.078, 0.5, 489.5, 325.6, 8.8, 0.0022,
0.0055, 500, 12500, 4187.5, 350), name = structure(1:20, .Label = c("mu",
"v", "phi", "beta.1", "beta.0", "chsi.1", "chsi.0", "delta.new",
"delta.old", "mh", "mc", "Smax.1", "Smax.0", "Ymax", "rmax",
"gamma", "d", "S", "SSBa", "DSBa"), class = "factor"), continu = c(TRUE,
TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE,
TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE), initialisation = c(FALSE,
FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,
FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, TRUE, TRUE, TRUE
), info = c("", "", "", "", "", "", "", "", "", "", "", "", "",
"", "", "", "Seedling density (plants/m2)", "Seed production (grains/m2)",
"Surface seed bank (grains/m2)", "Deep seed bank (grains/m2)"
)), .Names = c("nominal", "binf", "bsup", "name", "continu",
"initialisation", "info"), row.names = c("mu", "v", "phi", "beta.1",
"beta.0", "chsi.1", "chsi.0", "delta.new", "delta.old", "mh",
"mc", "Smax.1", "Smax.0", "Ymax", "rmax", "gamma", "d", "S",
"SSBa", "DSBa"), class = "data.frame")

#' Fonction de base du mod�le "Weed": calcul sur 1 ann�e du mod�le "Weed".
#' @title Fonction de base du mod�le "Weed"
#' @param decision data.frame � 1 ligne et 3 colonnes Soil, Crop, Herb
#' @param param vecteur des param�tres:
#'             mu, v, phi, beta.1, beta.0, chsi.1, chsi.0,
#'             delta.new, delta.old, mh, mc, Smax.1, Smax.0,
#'             Ymax, rmax, gamma
#'          et des variables d'�tat initiales
#'             d.im1, S.im1, SSBa.im1, DSBa.im1 (d,S,SSBa,DSBa)
#' @return un vecteur de longueur 5 compos� de:
#'  \itemize{
#'    \item{S}{production de graines par eqn(m^2)}
#'    \item{d}{densit� d'adventices � l'�mergence (plantes par eqn(m^2))}
#'    \item{SSBa}{banque de graines en surface apr�s travail du sol (graines par eqn(m^2))}
#'    \item{DSBa}{banque de graines en profondeur apr�s travail du sol (graines par eqn(m^2))}
#'    \item{Yield}{rendement (t par ha)}
#' }

weed.fun <-
		function(decision, param)
{
	p = as.data.frame( matrix(param,nrow=1))
	names(p) = weed.factors$name
	init = p[,weed.factors$initialisation]

	beta <- p$beta.1*decision$Soil + p$beta.0*(1-decision$Soil)
	chsi <- p$chsi.1*decision$Soil + p$chsi.0*(1-decision$Soil)
	Smax <- p$Smax.1*decision$Crop + p$Smax.0*(1-decision$Crop)
	alpha<- Smax/160000

	SSBb.i <- (1-p$mu)*(init$SSBa - init$d) + p$v*(1-p$phi)*init$S
	DSBb.i <- (1-p$mu)*init$DSBa

	SSBa.i <- (1-beta)*SSBb.i + chsi*DSBb.i
	DSBa.i <- (1-chsi)*DSBb.i + beta*SSBb.i

	d.i <- p$delta.new*p$v*(1-p$phi)*(1-beta)*init$S +
			p$delta.old*(SSBa.i-init$S*p$v*(1-p$phi)*(1-beta))
	D.i <- (1-p$mh*decision$Herb)*(1-p$mc)*d.i
	S.i <- Smax*D.i/(1+alpha*D.i)
	Yield.i <- p$Ymax*(1-(p$rmax*D.i/(1+p$gamma*D.i)))

	return(c(d.i, S.i, SSBa.i, DSBa.i, Yield.i))
}

#' Mod�le "Weed" pour un jeu de param�tres et un jeu de d�cisions sur n ann�es
#' @title Mod�le "Weed" pour un jeu de param�tres et un jeu de d�cisions
#' @param param vecteur des param�tres:
#'             mu, v, phi, beta.1, beta.0, chsi.1, chsi.0,
#'             delta.new, delta.old, mh, mc, Smax.1, Smax.0,
#'             Ymax, rmax, gamma
#'          et des variables d'�tat initiales
#'             d.im1, S.im1, SSBa.im1, DSBa.im1 (d,S,SSBa,DSBa)
#' @param decision data.frame � 3 colonnes Soil, Crop, Herb de valeurs 0-1
#'        et n lignes, o� n est le nombre d'ann�es simul�es
#' @param tout TRUE si l'on veut les entr�es ET les sorties dans le tableau de sortie
#' @note Voir weed.factors pour les valeurs min, max et nominal des parametres
#' @return une matrice n x 5 compos�e de:
#'  \itemize{
#'    \item{S}{production de graines par eqn(m^2)}
#'    \item{d}{densit� d'adventices � l'�mergence (plantes par eqn(m^2))}
#'    \item{SSBa}{banque de graines en surface apr�s travail du sol (graines par eqn(m^2))}
#'    \item{DSBa}{banque de graines en profondeur apr�s travail du sol (graines par eqn(m^2))}
#'    \item{Yield}{rendement (t par ha)}
#' }
#' @examples
#'  decision <- data.frame(Soil=c(0,1),Crop=c(0,1),Herb=c(0,1))
#'  weed.model( weed.factors$nominal, decision=decision )

weed.model <-
		function(param, decision = weed.decision, tout = FALSE)
{
	init = param[weed.factors$initialisation==TRUE]
	NumY = nrow(decision)

	sortie = matrix(NA,nrow=NumY,ncol=5)
	dimnames(sortie) = list(paste("Annee",1:NumY,sep="."), c("d","S","SSBa","DSBa","Yield"))
	for(i in 1:NumY) {
		sortie[i,] = weed.fun(decision[i,],param)
		param[weed.factors$initialisation==TRUE] = sortie[i,1:4]
	}
	sortie
}

#' Simulations en s�rie du mod�le "Weed"
#' @title Simulations en s�rie du mod�le "Weed"
#' @param X matrice ou data.frame des jeux de param�tres:
#'             mu, v, phi, beta.1, beta.0, chsi.1, chsi.0,
#'             delta.new, delta.old, mh, mc, Smax.1, Smax.0,
#'             Ymax, rmax, gamma
#'          et des variables d'�tat initiales
#'             d.im1, S.im1, SSBa.im1, DSBa.im1 (d,S,SSBa,DSBa)
#' @param decision data.frame � 3 colonnes Soil, Crop, Herb et n
#'             lignes, o� n est le nombre d'ann�es simul�es
#' @param sortie fonction ou mot-cl� donnant la nature de la ou des variables
#'           en sortie de chaque simulation (voir DETAILS)
#' @param nom.sortie noms de la ou des variables de sortie retenues
#' @param tout TRUE si l'on veut les entr�es ET les sorties dans le tableau de sortie
#' @note
#'  Le param�tre 'sortie' peut �tre:
#'  \itemize{
#'   \item soit une fonction calculant la ou les variables de sortie de chaque
#'     simulation � partir du tableau n x 5 des sorties de 'weed.model';
#'   \item soit un mot-cle pr�-d�fini:
#'      \itemize{
#'       \item{annee.finale}{pour avoir les 5 sorties de la derni�re ann�e;}
#'       \item{rdt.total}{pour avoir la somme des rendements sur les n annees (defaut);}
#'       \item{banque.finale}{pour avoir la banque de graines en derniere annee.}
#' }}
#'  Pour rappel, les 5 sorties de 'weed.model' sont:
#'  \itemize{
#'    \item{S}{production de graines par eqn(m^2)}
#'    \item{d}{densit� d'adventices � l'�mergence (plantes par eqn(m^2))}
#'    \item{SSBa}{banque de graines en surface apr�s travail du sol (graines par eqn(m^2))}
#'    \item{DSBa}{banque de graines en profondeur apr�s travail du sol (graines par eqn(m^2))}
#'    \item{Yield}{rendement (t par ha)}
#' }
#' @return
#'  un data.frame incluant en colonnes la ou les sorties retenues. Suivant la
#'  valeur de 'tout', les entr�es sont restitu�es ou non.
#' @examples
#'  jeux.parametres <- rbind(weed.factors$binf, weed.factors$nominal, weed.factors$bsup)
#'  weed.simule( jeux.parametres, sortie=function(x){sum(x[,5])}, nom.sortie="rdt.total")
#'  weed.simule( jeux.parametres, sortie="annee.finale", nom.sortie="rdt.total")

weed.simule <-
function(X, decision = weed.decision, sortie = "rdt.total", nom.sortie = NULL,
           tout = FALSE)
  {
    if(class(sortie)=="character"){
      if(sortie == "annee.finale"){
        sortie <- function(x){ x[nrow(x),] }
        nom.sortie <- c("d.FIN","S.FIN","SSBa.FIN","DSBa.FIN","Yield.FIN") }
      else if(sortie == "banque.finale"){
        sortie <- function(x){ sum(x[nrow(x),c(3,4)]) }
        nom.sortie <- c("BqGr") }
      else if(sortie == "rdt.total"){
        sortie <- function(x){ sum(x[,5]) }
        nom.sortie <- c("Y") }
    }
    res = t(apply(X, 1,
      function(v){ out <- weed.model(v,decision = decision) ;
                                    sortie(out) } ))
    if(length(res) != nrow(X)){
      res <- as.data.frame(res)
      names(res) = nom.sortie
    }
    else res <- c(res)

    if (tout) res  = cbind(X,res)
    return(res)
  }

#' Mod�le wwdm (winter wheat dry matter) de croissance du bl�,
#' mod�le de culture tr�s simple, dynamique � pas de temps journalier
#' @title Mod�le "wwdm" pour un jeu de param�tres
#' @name wwdm.model
#' @param param vecteur de param�tres de wwdm de longueur 7 ou 8
#' @param year soit NULL soit un nombre compris entre 1 et 14
#' @param climate nom du data.frame contenant les donn�es climatiques
#' @note
#'  Le mod�le a deux variables d'�tat, l'indice de surface foliaire (LAI) et
#'  la biomasse a�rienne du bl� d'hiver. La sortie de la fonction est le gain de
#'  poids journalier de la mati�re s�che en 'g per m2 per day'.
#'  Une simulation correspond � une ann�e climatique. Par d�faut, les donn�es
#'  climatiques sont lues dans le data.frame wwdm.climates, qui contient 14
#'  ann�es climatiques, et l'ann�e doit �tre sp�cifi�e par un nombre entre 1 et 14.
#'  Il y a deux fa�ons de faire cela, soit par l'argument \code{year}, soit
#'  par la 8�me coordonn�e de l'argument \code{param} si \code{year=NULL}. Lorsque
#'  \code{year=NULL} et qu'il n'y a que 7 coordonn�es dans \code{param}, l'ann�e
#'  utilis�e est l'ann�e num�ro 3
#' @return vecteur des 223 gains journaliers de biomasse calcul�s par WWDM
#' @references
#'   Makowski, D., Jeuffroy, M.-H., Gu�rif, M., 2004 Bayesian methods for
#'    updating crop model predictions, applications for predicting biomass and
#'    grain protein content. In: Bayesian Statistics and Quality Modelling in
#'    the Agro-Food Production Chain (van Boeakel et al. eds), pp. 57-68.
#'    Kluwer, Dordrecht.
#'
#'   Monod, H., Naud, C., Makowski, D., 2006 Uncertainty and sensitivity
#'    analysis for crop models. In: Working with Dynamic Crop Models (Wallach
#'    D., Makowski D. and Jones J. eds), pp. 55-100. Elsevier, Amsterdam
#' @examples
#'  #data()
#'  #wwdm.model()
#'  #sum( wwdm.model() )  #biomasse cumulee
#'  #wwdm.model(param=wwdm.factors$nominal, year=NULL, climate=wwdm.climates)
#'  #wwdm.model(param=wwdm.factors$nominal, year=5)

wwdm.model <-
    function(param, year=NULL, climate=wwdm.climates)
{

    if(class(param)=="numeric"){param <- as.data.frame(as.list(param))}
    names(param) = wwdm.factors$name[seq(length(param))]

    Eb    <- param$Eb
    Eimax <- param$Eimax
    K     <- param$K
    Lmax  <- param$Lmax
    A     <- param$A
    B     <- param$B
    TI    <- param$TI
    if (is.null(year)){
        if(ncol(param) == 8) year <- param$Clim
        else year <- 3
    }
    ## Calcul de PAR et de ST	 � partir des fichiers climatiques
    PAR <- 0.5*0.01*climate$RG[climate$ANNEE==year]
    Tmean <- (climate$Tmin[climate$ANNEE==year]+climate$Tmax[climate$ANNEE==year])/2
    Tmean[Tmean<0] <- 0
    ST <- Tmean
    for (i in (2:length(Tmean)))
    {
        ST[i] <- ST[i-1]+Tmean[i]
    }

    ## Calcul de LAI
    Tr <- (1/B)*log(1+exp(A*TI))
    LAI <- Lmax*((1/(1+exp(-A*(ST-TI))))-exp(B*(ST-(Tr))))
    LAI[LAI<0] <- 0

    ## Calcul de la biomasse (g/m2)
    U <- Eb*Eimax*(1-exp(-K*LAI))*PAR
    ## BIOMASSE <-sum(U)

    return(U)
}

#' Fonction g�rant une s�rie de simulations de wwdm, mod�le de culture dynamique
#' � pas de temps journalier, pour le bl�
#' @title Simulations en s�rie du mod�le "wwdm"
#' @name wwdm.simule
#' @param X dataframe � 7 ou 8 colonnes de valeurs des param�tres de wwdm
#' @param year soit NULL, soit une valeur unique entre 1 et 14
#' @param tout TRUE si l'on veut les entr�es ET les sorties dans le tableau de sortie
#' @param transfo TRUE si X contient des valeurs cod�es entre 0 et 1
#' @param b1 vecteur des 7 ou 8 bornes inf�rieures des param�tres si transfo=TRUE
#' @param b2 vecteur des 7 ou 8 bornes sup�rieures des param�tres si transfo=TRUE
#' @note
#'  Le mod�le a deux variables d'�tat, l'indice de surface foliaire (LAI) et
#'  la biomasse a�rienne du bl� d'hiver. La fonction wwdm.simule ne donne
#'  en sortie que la biomasse a�rienne accumul�e avant la r�colte, en 'g per m2'.
#'  Une simulation correspond � une ann�e climatique. Il est possible de
#'  pr�ciser l'ann�e climatique, soit simulation par simulation en ajoutant une
#'  colonne 'year' � 'X', soit globalement en utilisant l'argument 'year'
#' @return
#'  Biomasse a�rienne accumul�e avant la r�colte, en g per m2
#' @references
#'   Makowski, D., Jeuffroy, M.-H., Gu�rif, M., 2004 Bayseian methods for
#'    updating crop model predictions, applications for predicting biomass and
#'    grain protein content. In: Bayseian Statistics and Quality Modelling in
#'    the Agro-Food Production Chain (van Boeakel et al. eds), pp. 57-68.
#'    Kluwer, Dordrecht
#'
#'   Monod, H., Naud, C., Makowski, D., 2006 Uncertainty and sensitivity
#'    analysis for crop models. In: Working with Dynamic Crop Models (Wallach
#'    D., Makowski D. and Jones J. eds), pp. 55-100. Elsevier, Amsterdam
#' @examples
#'  jeux.parametres <- as.data.frame(rbind(wwdm.factors$binf,wwdm.factors$nominal, wwdm.factors$bsup))
#'  names(jeux.parametres) <- wwdm.factors$name
#'  wwdm.simule(jeux.parametres)

wwdm.simule <- function(X, year=NULL, tout=FALSE,
                        transfo = FALSE,
                        b1=wwdm.factors$binf[1:Nbfac],
                        b2=wwdm.factors$bsup[1:Nbfac]){
#  � utiliser pour analyser  la FC wwdm  avec morris() de sensitivity
#  transfo = T : recodage de la matrice X cod�e dans [0,1]
#  binf = vecteur des bornes inf�rieures des gammes des facteurs
#  bsup = vecteur des bornes sup�rieures des gammes des facteurs
  if(transfo){
      Nbfac <- ncol(X)
      X <- t(b1 + t(X)*(b2-b1))
  }
  if(is.null(year))
      sortie <- apply(X,1, function(v) sum(wwdm.model(v[1:7],v[8])) )
   else
      sortie <- apply(X,1,function(v) sum(wwdm.model(v[1:7],year=year)))

  if(tout) sortie = cbind(X,Biomasse = sortie)

  return(sortie)
}

#' S�ries climatiques sur 14 ann�es, utilis�es par le mod�le wwdm
#' @title S�ries climatiques sur 14 ann�es, utilis�es par le mod�le wwdm
#' @docType data
#' @name wwdm.climates
#' @return data.frame � N lignes (1 par jour) et 4 colonnes (ANNEE, RG, Tmin, Tmax)

NULL # Voir dans le r�pertoire data

#' Facteurs d'entr�e du mod�le "wwdm"
#' @docType data
#' @title Facteurs d'entr�e du mod�le "wwdm"
#' @return data.frame � 8 lignes (facteurs) et 4 colonnes (sp�cifs)

wwdm.factors <-
    structure(list(nominal = c(1.85, 0.94, 0.7, 7.5, 0.0065, 0.00205,
                   900, 3),
                   binf = c(0.9, 0.9, 0.6, 3, 0.0035, 0.0011, 700, 1),
                   bsup = c(2.8, 0.99, 0.8, 12, 0.01, 0.0025, 1100, 14),
                   name = c("Eb", "Eimax", "K", "Lmax", "A", "B", "TI", "Clim"),
                   continu = c(TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, FALSE)),
              .Names = c("nominal", "binf", "bsup", "name", "continu"),
              row.names = c("Eb", "Eimax", "K", "Lmax", "A", "B", "TI", "Clim"),
              class = "data.frame")

