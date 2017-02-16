require_relative 'test_helper'

describe "GestionAcademique" do
  describe "supprimer" do
    _it_ "signale une erreur si depot inexistant", :intermediaire do
      FileUtils.rm_f '.cours.txt'
      genere_erreur /fichier.*[.]cours.txt.*existe pas/ do
        ga( 'supprimer INF1120' )
      end
    end

    context "banque de cours avec plusieurs cours" do
      let(:lignes) { IO.readlines("Tests/cours.txt.5+1") }
      let(:attendu) { ['INF1120 "Programmation I" ()',
                       'INF1130 "Mathematiques pour informaticien" ()',
                       'INF2120 "Programmation II" (INF1120)',
                       'INF3105 "Structures de donnees et algorithmes" (INF1130:INF2120)',
                       'INF3135 "Construction et maintenance de logiciels" (INF1120)',
                      ]
      }

      _it_ "signale une erreur si le sigle n'existe pas", :intermediaire do
        avec_fichier '.cours.txt', lignes do
          genere_erreur /Aucun cours.*INF9999/ do
            ga( "supprimer INF9999" )
          end
        end
      end

      _it_ "signale une erreur si argument en trop", :intermediaire do
        avec_fichier '.cours.txt', lignes do
          genere_sortie_et_erreur [], /Argument.*en trop/ do
            ga( 'supprimer INF2120 foo' )
          end
        end
      end

      it_ "supprime le cours si le sigle existe" do
        nouveau_contenu = avec_fichier '.cours.txt', lignes, :conserver do
          execute_sans_sortie_ou_erreur do
            ga( "supprimer INF2120" )
          end
        end

        nouveau_contenu.find { |l| l =~ /^INF2120/ }.must_be_nil
        nouveau_contenu.size.must_equal 5
        FileUtils.rm_f '.cours.txt'
      end
    end
  end
end
