require_relative 'test_helper'

describe "GestionAcademique" do
  describe "trouver" do
    it_ "signale une erreur si fichier inexistant", :intermediaire do
      FileUtils.rm_f '.cours.txt'
      genere_erreur /fichier.*[.]cours.txt.*existe pas/ do
        ga( 'trouver' )
      end
    end

    it_ "retourne rien si fichier vide" do
      avec_fichier '.cours.txt' do
        execute_sans_sortie_ou_erreur do
          ga( 'trouver .' )
        end
      end
    end

    
   _it_ "signale une erreur si argument en trop", :intermediaire do
      avec_fichier '.cours.txt' do
        genere_sortie_et_erreur [], /Argument.*en trop/ do
          ga( 'trouver "." foo' )
        end
      end
    end

    context "banque de cours avec plusieurs cours" do
      let(:lignes) { IO.readlines("Tests/cours.txt.5+1") }

      it_ "trouve toutes les lignes avec un caractere quelconque" do
        avec_fichier '.cours.txt', lignes do
          genere_sortie lignes.select { |l| l !~ /INACTIF/ }.map(&:chomp) do
            ga( 'trouver .' )
          end
        end
      end

     it_ "trouve toutes les lignes avec n'importe quoi" do
        avec_fichier '.cours.txt', lignes do
          genere_sortie lignes.select { |l| l !~ /INACTIF/ }.map(&:chomp) do
            ga( "trouver '.*'" )
          end
        end
      end

      _it_ "trouve les lignes matchant une chaine specifique mais parmi les actifs seulement" do
        avec_fichier '.cours.txt', lignes do
          attendu = ['INF1120,Programmation I,3,,ACTIF',
                     'INF1130,Mathematiques pour informaticien,3,,ACTIF',
                     'INF2120,Programmation II,3,INF1120,ACTIF']

          genere_sortie attendu do
            ga( 'trouver mat' )
          end
        end
      end

      _it_ "trouve les lignes matchant une chaine specifique parmi toutes y compris les inactifs", :intermediaire do
        avec_fichier '.cours.txt', lignes do
          attendu = ['MAT3140,Algebre et logique,3,,INACTIF',
                     'INF1120,Programmation I,3,,ACTIF',
                     'INF1130,Mathematiques pour informaticien,3,,ACTIF',
                     'INF2120,Programmation II,3,INF1120,ACTIF',
                    ]

          genere_sortie attendu do
            ga( 'trouver --avec_inactifs MAT' )
          end
        end
      end

      _it_ "trouve les lignes matchant une chaine specifique parmi toutes y compris les inactifs en ordre de sigle", :avance do
        avec_fichier '.cours.txt', lignes do
          attendu = ['INF1120,Programmation I,3,,ACTIF',
                     'INF1130,Mathematiques pour informaticien,3,,ACTIF',
                     'INF2120,Programmation II,3,INF1120,ACTIF',
                     'MAT3140,Algebre et logique,3,,INACTIF',]

          genere_sortie attendu do
            ga( 'trouver --avec_inactifs --cle_tri=sigle MAT' )
          end
        end
      end

      _it_ "trouve les lignes matchant une chaine specifique parmi toutes y compris les inactifs en ordre de titre", :avance do
        avec_fichier '.cours.txt', lignes do
          attendu = ['MAT3140,Algebre et logique,3,,INACTIF',
                     'INF1130,Mathematiques pour informaticien,3,,ACTIF',
                     'INF1120,Programmation I,3,,ACTIF',
                     'INF2120,Programmation II,3,INF1120,ACTIF',]


          genere_sortie attendu do
            ga( 'trouver --avec_inactifs --cle_tri=titre MAT' )
          end
        end
      end

      _it_ "affiche tous les cours selon le format indique", :avance do
        avec_fichier '.cours.txt', lignes do
          attendu = ["INF1120 => 'Programmation I' (3 cr.)",
                     "INF1130 => 'Mathematiques pour informaticien' (3 cr.)",
                     "INF2120 => 'Programmation II' (3 cr.)",
                     "INF3105 => 'Structures de donnees et algorithmes' (3 cr.)",
                     "INF3135 => 'Construction et maintenance de logiciels' (3 cr.)",
                    ]

          genere_sortie attendu do
            ga( "trouver --format=\"%S => '%T' (%C cr.)\" '.'" )
          end
        end
      end
    end
  end
end
