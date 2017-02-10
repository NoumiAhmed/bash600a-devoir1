gem 'minitest'
require 'minitest/autorun'
require 'minitest/spec'
require 'minitest/mock'
require 'open3'

#########################################################
# Methodes auxiliaires pour les tests du devoir 1.
#########################################################

#
# Extensions de la classe Object pour definir des methodes auxiliaires
# de test.
#
class Object
  # Pour desactiver temporairement une suite de tests.
  def _describe( test )
    puts "--- On saute les tests pour \"#{test}\" ---"
  end

  # Pour desactiver temporairement un test.
  def _it_( test, niveau = :base )
    puts "--- On saute le test \"#{test}\" ---"
  end

  # Des alias pour style RSpec
  alias_method :context, :describe
  alias_method :_context, :_describe


  # Une methode de test auxiliaire pour tenir compte du niveau de test
  # en cours.
  def it_( test, niveau = :base, &bloc )
    return if (niveau_a_tester = ENV['NIVEAU']) && niveau_a_tester.to_sym != niveau

    it( test, &bloc )
  end
end


#
# Cree un fichier temporaire avec le contenu indique.  Execute ensuite
# le bloc recu, puis supprime le fichier temporaire.
#
# @param [String] nom_fichier
# @param [Array<String>] contenu lignes contenues dans le fichier
# @return [void]
# @yield [void]
#
def avec_fichier( nom_fichier, lignes = [], conserver = nil )
  # On cree le fichier.
  File.open( nom_fichier, "w" ) do |fich|
    lignes.each do |ligne|
      fich.puts  ligne
    end
  end

  # On execute le bloc.
  yield

  # On supprime le fichier sauf si indique autrement, auquel cas on
  # retourne son contenu.
  if conserver
    contenu_fichier( nom_fichier )
  else
    FileUtils.rm_f nom_fichier
  end
end

#
# Execute le script ./ga.sh avec commande, options et arguments
# indiques puis retourne les lignes emises sur stdout et stderr suite
# a l'execution de cette commande, ainsi que le code de statut.
#
# @param [String] cmd La commande a executer avec ses options et
# arguments  (sans './ga.sh')
# @return [Array[Array<String>, Array<String>, Fixnum] Les lignes
#produites sur stdout, stderr et le code de statut
#
def ga( cmd )
 stdout = stderr = wt = nil
 Open3.popen3( "./ga.sh #{cmd}" ) do |i, o, e, w|
   i.close
   stdout = o.readlines.map!(&:chomp!)
   stderr = e.readlines.map!(&:chomp!)
   wt = w
 end
 [stdout, stderr, wt.value.exitstatus]
end

#
# Retourne le contenu d'un fichier sous forme d'une liste de lignes,
# sans les sauts de lignes.
#
# @param [String] nom_fichier
# @return [Array<String>] ou les "\n" finaux ont ete supprimes
#
def contenu_fichier( nom_fichier )
  IO.readlines(nom_fichier).map(&:chomp)
end

#
# Methodes avec assertions plus complexes, pour simplifier les tests.
#

# Execute une commande specifiee par le bloc, qui doit *matcher* l'erreur indiquee.
def genere_erreur( erreur )
  out, err, statut = yield
  out.must_be_empty
  statut.wont_equal 0
  err.join.must_match erreur
end

# Execute une commande specifiee par le bloc, qui ne doit generer ni sortie, ni erreur
def execute_sans_sortie_ou_erreur
  out, err, statut = yield
  out.must_be_empty
  err.must_be_empty
  statut.must_equal 0
end

# Execute une commande specifiee par le bloc, qui doit generer une sortie bien precise.
def genere_sortie( attendu )
  out, err, statut = yield
  out.must_equal attendu
  err.must_be_empty
  statut.must_equal 0
end

# Execute une commande specifiee par le bloc, qui doit generer une sortie bien precise.
def genere_sortie_et_erreur( attendu, erreur )
  out, err, statut = yield
  out.must_equal attendu
  err.join.must_match erreur
  statut.wont_equal 0
end
