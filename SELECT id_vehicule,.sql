SELECT id_vehicule,
       marque,
       modele,
       annee_construction,
       categorie,
       motorisation,
       carburant,
       puissance_ch,
       boite_vitesse,
       couleur,
       kilometrage,
       prix_eur,
       pays_origine
FROM public.vehicules
LIMIT 1000;