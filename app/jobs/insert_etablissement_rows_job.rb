$sirets_processed ||= []

class InsertEtablissementRowsJob
  attr_accessor :lines

  def initialize(lines)
    @lines = lines
  end

  def perform
    etablissements = []

    for line in lines do
      etablissements << etablissement_attrs_from_line(line)
    end


    ar_keys = ['created_at', 'updated_at']
    ar_keys << etablissements.first.keys.map(&:to_s)
    ar_keys.flatten

    ar_values_string = etablissements.map{ |h| value_string_from_enterprise_hash(h) }.join(', ')

    ar_query_string = " INSERT INTO etablissements (#{ar_keys.join(',')})
                        VALUES
                        #{ar_values_string}; "

    ActiveRecord::Base.connection.execute(ar_query_string)
    true
  end

  def value_string_from_enterprise_hash(hash)
    # Used for updated_at and created_at that etablissement model requires
    now_string = Time.now.utc.to_s

    between_parenthesis = hash.values.map do |v|
      if v.nil?
        "NULL"
      else
        "'#{v.gsub("'","''")}'"
      end
    end.join(',')

    "('#{now_string}', '#{now_string}', #{between_parenthesis})"
  end

  def etablissement_attrs_from_line(line)
    siret = line[:siren] + line[:nic]

    etablissement_attrs = {
      siren: line[:siren],
      siret: siret,
      nic: line[:nic],
      l1_normalisee: line[:l1_normalisee],
      l2_normalisee: line[:l2_normalisee],
      l3_normalisee: line[:l3_normalisee],
      l4_normalisee: line[:l4_normalisee],
      l5_normalisee: line[:l5_normalisee],
      l6_normalisee: line[:l6_normalisee],
      l7_normalisee: line[:l7_normalisee],
      l1_declaree: line[:l1_declaree],
      l2_declaree: line[:l2_declaree],
      l3_declaree: line[:l3_declaree],
      l4_declaree: line[:l4_declaree],
      l5_declaree: line[:l5_declaree],
      l6_declaree: line[:l6_declaree],
      l7_declaree: line[:l7_declaree],
      numero_voie: line[:numvoie],
      indice_repetition: line[:indrep],
      type_voie: line[:typvoie],
      libelle_voie: line[:libvoie],
      code_postal: line[:codpos],
      cedex: line[:cedex],
      region: line[:rpet],
      libelle: line[:libreg],
      departement: line[:depet],
      arrondissement: line[:arronet],
      canton: line[:ctonet],
      commune: line[:comet],
      libelle_commune: line[:libcom],
      departement_unite_urbaine: line[:du],
      taille_unite_urbaine: line[:tu],
      numero_unite_urbaine: line[:uu],
      etablissement_public_cooperation_intercommunale: line[:epci],
      tranche_commune_detaillee: line[:tcd],
      zone_emploi: line[:zemet],
      is_siege: line[:siege],
      enseigne: line[:enseigne],
      indicateur_champ_publipostage: line[:ind_publipo],
      statut_diffusion: line[:diffcom],
      date_introduction_base_diffusion: line[:amintret],
      nature_entrepreneur_individuel: line[:natetab],
      libelle_nature_entrepreneur_individuel: line[:libnatetab],
      activite_principale: line[:apet700],
      libelle_activite_principale: line[:libapet],
      date_validite_activite_principale: line[:dapte],
      tranche_effectif_salarie: line[:tefet],
      libelle_tranche_effectif_salarie: line[:libtefet],
      tranche_effectif_salarie_centaine_pret: line[:efetcent],
      date_validite_effectif_salarie: line[:defet],
      origine_creation: line[:origine],
      date_creation: line[:dcret],
      date_debut_activite: line[:ddebact],
      nature_activite: line[:activnat],
      lieu_activite: line[:lieuact],
      type_magasin: line[:actisurf],
      is_saisonnier: line[:saisonat],
      modalite_activite_principale: line[:modet],
      caractere_productif: line[:prodet],
      participation_particuliere_production: line[:prodpart],
      caractere_auxiliaire: line[:auxilt],
      nom_raison_sociale: line[:nomen_long],
      sigle: line[:sigle],
      nom: line[:nom],
      prenom: line[:prenom],
      civilite: line[:civilite],
      numero_rna: line[:rna],
      nic_siege: line[:nicsiege],
      region_siege: line[:rpen],
      departement_commune_siege: line[:depcomen],
      email: line[:adr_mail],
      nature_juridique_entreprise: line[:nj],
      libelle_nature_juridique_entreprise: line[:libnj],
      activite_principale_entreprise: line[:apen700],
      libelle_activite_principale_entreprise: line[:libapen],
      date_validite_activite_principale_entreprise: line[:dapen],
      activite_principale_registre_metier: line[:aprm],
      is_ess: line[:ess],
      date_ess: line[:dateess],
      tranche_effectif_salarie_entreprise: line[:tefen],
      libelle_tranche_effectif_salarie_entreprise: line[:libtefen],
      tranche_effectif_salarie_entreprise_centaine_pret: line[:efencent],
      date_validite_effectif_salarie_entreprise: line[:defen],
      categorie_entreprise: line[:categorie],
      date_creation_entreprise: line[:dcren],
      date_introduction_base_diffusion_entreprise: line[:amintren],
      indice_monoactivite_entreprise: line[:monoact],
      modalite_activite_principale_entreprise: line[:moden],
      caractere_productif_entreprise: line[:proden],
      date_validite_rubrique_niveau_entreprise_esa: line[:esaann],
      tranche_chiffre_affaire_entreprise_esa: line[:tca],
      activite_principale_entreprise_esa: line[:esaapen],
      premiere_activite_secondaire_entreprise_esa: line[:esasec1n],
      deuxieme_activite_secondaire_entreprise_esa: line[:esasec2n],
      troisieme_activite_secondaire_entreprise_esa: line[:esasec3n],
      quatrieme_activite_secondaire_entreprise_esa: line[:esasec4n],
      nature_mise_a_jour: line[:vmaj],
      indicateur_mise_a_jour_1: line[:vmaj1],
      indicateur_mise_a_jour_2: line[:vmaj2],
      indicateur_mise_a_jour_3: line[:vmaj3],
      date_mise_a_jour: line[:datemaj],
      type_evenement: line[:eve],
      date_evenement: line[:dateve],
      type_creation: line[:typcreh],
      date_reactivation_etablissement: line[:dreactet],
      date_reactivation_entreprise: line[:dreacten],
      indicateur_mise_a_jour_enseigne_entreprise: line[:madresse],
      indicateur_mise_a_jour_activite_principale_etablissement: line[:menseigne],
      indicateur_mise_a_jour_adresse_etablissement: line[:mapet],
      indicateur_mise_a_jour_caractere_productif_etablissement: line[:mprodet],
      indicateur_mise_a_jour_caractere_auxiliaire_etablissement: line[:mauxilt],
      indicateur_mise_a_jour_nom_raison_sociale: line[:mnomen],
      indicateur_mise_a_jour_sigle: line[:msigle],
      indicateur_mise_a_jour_nature_juridique: line[:mnj],
      indicateur_mise_a_jour_activite_principale_entreprise: line[:mapen],
      indicateur_mise_a_jour_caractere_productif_entreprise: line[:mproden],
      indicateur_mise_a_jour_nic_siege: line[:mnicsiege],
      siret_predecesseur_successeur: line[:siretps],
      telephone: line[:tel]
    }
  end
end