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
    >&2 echo "*** Erreur: $msg"
    >&2 echo ""

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

    shift
    nb_arguments=0
  
    if [[ $1 =~ ^--detruire$ ]]; then
        ((nb_arguments++))
    fi

    if [[ -f $depot ]]; then
        # Depot existe deja.
        # On le detruit quand --detruire est specifie.

        [[ $nb_arguments > 0 ]] || erreur "Le fichier '$depot' existe. Si vous voulez le detruire, utilisez 'init --detruire'." 
        rm -f $depot
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
   args=0
   assert_depot_existe $1
   local depot=$1
   shift

    if [[ $1 =~ ^--avec_inactifs$ ]]; then
      ((args++))
    fi

    awk -F$SEP -v args=$args '/,ACTIF/ { print $1, "\""$2"\"", "("$4")" } /,INACTIF$/ && args!=0 { print $1"?", "\""$2"\"", "("$4")" }' $depot | sort

    return $args
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

   file=$1
    assert_depot_existe $file

    [[ $# -ge 2 ]] || erreur "Nombre insuffisant d'arguments"
    args=1 #au moins un argument:le cours a trouver
    shift

   if [[ $1 =~ ^--avec_inactifs$ ]]; then
     cours_inactif=1
     shift
     ((args++))
    fi

   if [[ $1 =~ ^--cle_tri= ]]; then
     tri_selon=${1##--cle_tri=}
     shift
     ((args++))
   fi

   if [[ $1 =~ ^--format= ]]; then
    format_court=${1##--format=}
    shift
    ((args++))
   fi

    return $args
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
    args=0
    file=$1
    assert_depot_existe $1
    somme_credit=0
    shift

    for a in "$@" 
    do
      assert_sigle_existant $1 $file || erreur "Aucun cours: $1"
      ((somme_credit+=$(awk -F$SEP -v sigle=$1 '$1==sigle  {print $3}' $file)))
      ((args++))
      shift
    done

    echo $somme_credit
    return $args
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
   file=$1
   shift
   assert_depot_existe $file
   
   [[ $# == 1 ]] || erreur "Argument(s) en trop: '$@'"
   assert_sigle_existant $1 $file || erreur "Aucun cours: $1"

   sed -i  "/^$1/d" $file #fonctionne sur malt mais pas sur osx le sed -i cause probleme
    return 1
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
  file=$1

  shift
  assert_depot_existe $file 

  #echo $1
  #echo $file
  assert_sigle_existant $1 $file || erreur "Aucun cours: $1"

  res=$(awk -F$SEP -v sigle="$1" '/,INACTIF/ && sigle==$1 {print $5}' $file)
  
  [[ $res == "" ]] || erreur "Cours deja inactif: $1"
  sed -i "/^$1,/ s/ACTIF/INACTIF/" $file


    return 1
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
    file=$1

  shift
  assert_depot_existe $file 

  #echo $1
  #echo $file
  assert_sigle_existant $1 $file || erreur "Aucun cours: $1"

  res=$(awk -F$SEP -v sigle="$1" '/,ACTIF/ && sigle==$1 {print $5}' $file)
  
  [[ $res == "" ]] || erreur "Cours deja actif: $1"
  sed -i "/^$1,/ s/INACTIF/ACTIF/" $file


    return 1
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
# Autre fonctions


function assert_sigle_existant {

  valid=$(grep $1 $2)
    existe=0
    if [[ $valid == '' ]]; then
        existe=1
    fi
    #echo $existe
    return $existe

}

##########################################################################


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
  if [[ $1 =~ ^--depot=* ]]; then
    depot=${1##--depot=}
    shift
  else
    depot=$DEPOT_DEFAUT
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
}

main "$@"
exit 0