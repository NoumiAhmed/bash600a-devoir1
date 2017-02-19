###############################################################
#
# Constante a completer pour la remise de votre travail:
#  - CODES_PERMANENTS
#
###############################################################

### Vous devez completer l'une ou l'autre des definitions.   ###

# Deux etudiants:
# Si vous etes deux etudiants: Indiquer vos codes permanents.
CODES_PERMANENTS='TOMO11098405,NOUMA06078902'


# Un etudiant:
# Si vous etes seul: Supprimer le diese en debut de ligne et
# indiquer votre code permanent (sans changer le nom de la variable).
#CODES_PERMANENTS='ABCD01020304'

#--------------------------------------------------------

########################################################################
PGM=./ga.sh
########################################################################

.IGNORE:

# Constantes/cibles a modifier selon votre avancement (exemple, test)
# et selon la commande en cours de developpement.

WIP=lister

NIVEAU_TEST=NIVEAU=base ruby
#NIVEAU_TEST=NIVEAU=intermediaire ruby
#NIVEAU_TEST=NIVEAU=avance ruby
#NIVEAU_TEST=ruby   # Tous les niveaux!

wip: wip_ex
wip: wip_test
wip: test_all

#-------------------
wip_ex: ex_$(WIP)  # ATTENTION: Certaines commandes ont des tests mais pas d'exemples.

wip_test:
	$(NIVEAU_TEST) Tests/$(WIP)_test.rb


##################################
# Cibles pour les exexmples d'execution.
##################################
ex ex_all: 
	@echo ""
	make ex_ajouter
	@echo ""
	make ex_lister
	@echo ""
	make ex_nb_credits
	@echo ""
	make ex_prealables
	@echo ""
	make ex_supprimer
	@echo ""
	make ex_trouver

ex_ajouter: ex_init
	$(PGM) ajouter INF2160 "Paradigmes de programmation" 3 INF1130 INF2120
	# Il devrait y avoir 5 cours
	$(PGM) lister

ex_init:
	@cp -f cours.txt.init .cours.txt

ex_lister: ex_init
	# Il devrait y avoir 4 cours.
	$(PGM) lister

ex_prealables: ex_init
	# Il devrait y avoir deux prealables: INF1130 et INF2120
	$(PGM) prealables INF3105

ex_supprimer: ex_init
	$(PGM) supprimer INF3105
	# Il devrait y avoir 3 cours
	$(PGM) lister

ex_trouver: ex_init
	# Les 4 cours actifs devraient etre affiches
	$(PGM) trouver INF
	# Seul le cours INF3105 devrait etre affiche
	$(PGM) trouver 3105

ex_nb_credits: ex_init
	# Devrait indiquer 6 credits
	$(PGM) nb_credits INF1120 INF2120


##################################
# Cibles pour les vrais test.
##################################

test: test_all

test_all:
	@echo "++ RESULTATS DES TESTS ++" > resultats.txt
	@#
	@echo "-- ruby Tests/ajouter_test.rb" >> resultats.txt
	ruby Tests/ajouter_test.rb | tee -a resultats.txt
	@#
	@echo "-- ruby Tests/desactiver_reactiver_test.rb" >> resultats.txt
	ruby Tests/desactiver_reactiver_test.rb | tee -a resultats.txt
	@#
	@echo "-- ruby Tests/init_test.rb" >> resultats.txt
	ruby Tests/init_test.rb | tee -a resultats.txt
	@#
	@echo "-- ruby Tests/lister_test.rb" >> resultats.txt
	ruby Tests/lister_test.rb | tee -a resultats.txt
	@#
	@echo "-- ruby Tests/nb_credits_test.rb" >> resultats.txt
	ruby Tests/nb_credits_test.rb | tee -a resultats.txt
	@#
	@echo "-- ruby Tests/prealables_test.rb" >> resultats.txt
	ruby Tests/prealables_test.rb | tee -a resultats.txt
	@#
	@echo "-- ruby Tests/supprimer_test.rb" >> resultats.txt
	ruby Tests/supprimer_test.rb | tee -a resultats.txt
	@#
	@echo "-- ruby Tests/trouver_test.rb" >> resultats.txt
	ruby Tests/trouver_test.rb | tee -a resultats.txt

test_base:
	NIVEAU=base make test_all

test_intermediaire:
	NIVEAU=intermediaire make test_all

test_avance:
	NIVEAU=avance make test_all


##################################
# Nettoyage.
##################################
clean:
	@-
	rm -f *.aux *.dvi *.ps *.log *.bbl *.blg *.pdf *.out
	@+
	rm -f *~ *.bak
	rm -rf tmp

########################################################################
########################################################################

BOITE=INF600A
remise:
	PWD=$(shell pwd)
	ssh oto.labunix.uqam.ca oto rendre_tp tremblay_gu $(BOITE) $(CODES_PERMANENTS) $(PWD)
	ssh oto.labunix.uqam.ca oto confirmer_remise tremblay_gu $(BOITE) $(CODES_PERMANENTS)

########################################################################
########################################################################

