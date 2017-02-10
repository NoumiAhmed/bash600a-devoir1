Skip to content
This repository
Search
Pull requests
Issues
Gist
 @turkguy
 Unwatch 2
  Star 0
  Fork 0 NoumiAhmed/bash600a-devoir1
 Code  Issues 0  Pull requests 0  Projects 0  Wiki  Pulse  Graphs
Branch: master Find file Copy pathbash600a-devoir1/ga.sh
ed4036d  3 hours ago
@NoumiAhmed NoumiAhmed ajout commentaire dans le main
3 contributors @NoumiAhmed @turkguy @tremblay-guy
RawBlameHistory     
Executable File  339 lines (289 sloc)  7.45 KB
#!/bin/bash -
#
# Gestion de cours de programme d'etudes.


# Nom de fichier pour depot par defaut.
DEPOT_DEFAUT=.cours.txt

##########################################################################
# Fonctions pour debogage et traitement des erreurs.
##########################################################################

# Pour generer des traces de debogage avec la function debug, il
# suffit de supprimer le <<#>> au debut de la ligne suivante.
#DEBUG=1

#-------
# Affiche une trace de deboggage.
#
# Arguments: [chaine...]
#-------
function debug {
    [[ $DEBUG ]] || return

    echo -n "[debug] "
    for arg in "$@"
    do
        echo -n "'$arg' "
    done
    echo ""
}

#-------
# Affiche un message d'erreur.
#
# Arguments: msg
#-------
function erreur {
    msg=$1

    # A COMPLETER: Les erreurs doivent etre emises stderr...
    # mais ce n'est pas le cas pour l'instant!
    echo "*** Erreur: $msg"
    echo ""

    # On emet le message d'aide si commande fournie invalide.
    # Par contre, ce message doit etre emis sur stdout.
    [[ ! $msg =~ Commande\ inconnue ]] || aide
    
    exit 1
}


##########################################################################
# Fonction d'aide: fournie, pour uniformite.
#
# Arguments: Aucun
#
# Emet l'information sur stdout
##########################################################################
function aide {
    cat <<EOF
NOM
  $0 -- Script pour gestion academique (banque de cours)
SYNOPSIS
  $0 [--depot=fich] commande [options-commande] [argument...]
COMMANDES
  aide          - Emet la liste des commandes
  ajouter       - Ajoute un cours dans la banque de cours 
                  (les prealables doivent exister)
  desactiver    - Rend inactif un cours actif 
                  (ne peut plus etre utilise comme nouveau prealable)
  init          - Cree une nouvelle base de donnees pour gerer des cours
                  (dans './$DEPOT_DEFAUT' si --depot n'est pas specifie)
  lister        - Liste l'ensemble des cours de la banque de cours 
                  (ordre croissant de sigle)
  nb_credits    - Nombre total de credits pour les cours indiques
  prealables    - Liste l'ensemble des prealables d'un cours
                  (par defaut: les prealables directs seulement)
  reactiver     - Rend actif un cours inactif
  supprimer     - Supprime un cours de la banque de cours
  trouver       - Trouve les cours qui matchent un motif
EOF
}

##########################################################################
# Fonctions pour manipulation du depot.
#
# Fournies pour simplifier le devoir et assurer au depart un
# fonctionnement minimal du logiciel.
##########################################################################

#-------
# Verifie que le depot indique existe, sinon signale une erreur.
#
# Arguments: depot
#-------
function assert_depot_existe {
    depot=$1
    [[ -f $depot ]] || erreur "Le fichier '$depot' n'existe pas!"
}


#-------
# Commande init.
#
# Arguments:  depot [--detruire]
#
# Erreurs:
#  - Le depot existe deja et l'option --detruire n'a pas ete indiquee
#-------
function init {
    depot=$1; 
    echo $1
    shift
    nb_arguments=0
    # A COMPLETER: traitement de la switch --detruire!
    #echo $1
    if [[ $1 =~ ^--detruire$ ]]; then
        ((nb_arguments++))
    fi

    if [[ -f $depot ]]; then
        # Depot existe deja.
        # On le detruit quand --detruire est specifie.
         if [[ $nb_arguments == 1 ]]; then 
          rm -f $depot
        else
          erreur "Le fichier '$depot' existe. Si vous voulez le detruire, utilisez 'init --detruire'." 
        fi
    fi

    # On 'cree' le fichier vide.
    touch $depot

    return $nb_arguments
}

##########################################################################
# Les fonctions pour les diverses commandes de l'application.
#
# A COMPLETER!
#
##########################################################################


# Separateur pour les champs d'un enregistrement specificant un cours.
readonly SEPARATEUR=,
readonly SEP=$SEPARATEUR # Alias, pour alleger le code

# Separateur pour les prealables d'un cours.
readonly SEPARATEUR_PREALABLES=:


#-------
# Commande lister
#
# Arguments: depot [--avec_inactifs]
#
# Erreurs:
# - depot inexistant
#-------
function lister {
    return 0
}


#-------
# Commande ajouter
#
# Arguments: depot sigle titre nb_credits [prealable...]
#
# Erreurs:
# - depot inexistant
# - nombre insuffisant d'arguments
# - sigle de forme invalide ou inexistant
# - sigles des prealables de forme invalide ou inexistants
# - cours avec meme sigle existe deja
#-------


function ajouter {
    return 0
}


#-------
# Commande trouver
#
# Arguments: depot [--avec_inactifs] [--cle_tri=sigle|titre] [--format=un_format] motif
# 
# Erreurs:
# - depot inexistant
# - nombre incorrect d'arguments
# - cle_tri de valeur invalide
# - item de format invalide
#-------
function trouver {
    return 0
}

#-------
# Commande nb_credits
#
# Arguments: depot [sigle...]
# Erreurs:
# - depot inexistant
# - sigle inexistant
#-------
function nb_credits {
    return 0
}


#-------
# Commande supprimer
#
# Arguments: depot sigle
# Erreurs:
# - depot inexistant
# - nombre incorrect d'arguments
# - sigle inexistant
#-------
function supprimer {
    return 0
}


#-------
# Commande desactiver
#
# Arguments: depot sigle
# 
# Erreurs:
# - depot inexistant
# - nombre incorrect d'arguments
# - sigle inexistant
# - cours deja inactif
#-------
function desactiver {
    return 0
}

#-------
# Commande reactiver
#
# Arguments: depot sigle
# 
# Erreurs:
# - depot inexistant
# - nombre incorrect d'arguments
# - sigle inexistant
# - cours deja actif
#-------
function reactiver {
    return 0
}


#-------
# Commande prealables
#
# Arguments: depot [--directs|--tous] sigle
#
# Erreurs:
# - depot inexistant
# - nombre incorrect d'arguments
# - sigle inexistant
#-------
function prealables {
    return 0
}

##########################################################################
# Le programme principal
#
# La strategie utilisee pour uniformiser le trairement des commande
# est la suivante : Une commande est mise en oeuvre par une fonction
# auxiliaire du meme nom que la commande. Cette fonction retourne
# comme statut le nombre d'arguments ou d'options (du programme
# principal) utilises par la commande --- mais  on ne compte pas l'argument
# $depot, transmis a chacune des fonctions.
#
# Ceci permet par la suite, dans le corps de la fonction principale,
# de "shifter" les arguments et, donc, de verifier si des arguments
# superflus ont ete fournis.
#
##########################################################################

function main {
  # On definit le depot a utiliser.
  # A COMPLETER: il faut verifier si le flag --depot=... a ete specifie.
  # Si oui, il faut modifier depot en consequence!
  depot=$DEPOT_DEFAUT

  debug "On utilise le depot suivant:", $depot

#on verifie s'il y a une option
###############################
  if [[ $1 =~ ^--depot=.* ]]; then
    depot=${1#--depot=}
   shift
    if [[ $1 != "init" ]]; then
    assert_depot_existe $depot
    fi
  fi
###############################
#
  # On analyse la commande (= dispatcher).
  commande=$1
  shift
  case $commande in
      ''|aide)
          aide;;

      ajouter|\
      desactiver|\
      init|\
      lister|\
      nb_credits|\
      prealables|\
      reactiver|\
      supprimer|\
      trouver)
          $commande $depot "$@";;

      *) 
          erreur "Commande inconnue: '$commande'";;
  esac
  shift $?
  
  [[ $# == 0 ]] || erreur "Argument(s) en trop: '$@'"
}

main "$@"
exit 0
Contact GitHub API Training Shop Blog About
© 2017 GitHub, Inc. Terms Privacy Security Status Help