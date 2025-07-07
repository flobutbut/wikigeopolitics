-- Attribution des régimes politiques pour les pays restants (2024)
-- Chaque choix est commenté pour vérification/ajustement éventuel

-- Afghanistan : régime autoritaire (Talibans)
UPDATE country SET current_regime_id = 'regime-autoritaire' WHERE id = 'afghanistan' AND current_regime_id IS NULL;

-- Algérie : régime autoritaire
UPDATE country SET current_regime_id = 'regime-autoritaire' WHERE id = 'algeria' AND current_regime_id IS NULL;

-- Argentine : démocratie représentative
UPDATE country SET current_regime_id = 'democratie-representative' WHERE id = 'argentina' AND current_regime_id IS NULL;

-- Bangladesh : démocratie représentative (parlementaire, mais parfois contestée)
UPDATE country SET current_regime_id = 'democratie-representative' WHERE id = 'bangladesh' AND current_regime_id IS NULL;

-- Bolivie : démocratie représentative
UPDATE country SET current_regime_id = 'democratie-representative' WHERE id = 'bolivia' AND current_regime_id IS NULL;

-- Botswana : démocratie représentative
UPDATE country SET current_regime_id = 'democratie-representative' WHERE id = 'botswana' AND current_regime_id IS NULL;

-- Burkina Faso : régime autoritaire (junte militaire)
UPDATE country SET current_regime_id = 'regime-autoritaire' WHERE id = 'burkina-faso' AND current_regime_id IS NULL;

-- Chili : démocratie représentative
UPDATE country SET current_regime_id = 'democratie-representative' WHERE id = 'chile' AND current_regime_id IS NULL;

-- Cuba : régime autoritaire (communiste)
UPDATE country SET current_regime_id = 'regime-autoritaire' WHERE id = 'cuba' AND current_regime_id IS NULL;

-- Indonésie : démocratie représentative
UPDATE country SET current_regime_id = 'democratie-representative' WHERE id = 'indonesia' AND current_regime_id IS NULL;

-- Irak : régime hybride (démocratie fragile, instabilité)
UPDATE country SET current_regime_id = 'regime-hybride' WHERE id = 'iraq' AND current_regime_id IS NULL;

-- Kazakhstan : régime autoritaire
UPDATE country SET current_regime_id = 'regime-autoritaire' WHERE id = 'kazakhstan' AND current_regime_id IS NULL;

-- Libye : régime hybride (gouvernement divisé, instabilité)
UPDATE country SET current_regime_id = 'regime-hybride' WHERE id = 'libya' AND current_regime_id IS NULL;

-- Mali : régime autoritaire (junte militaire)
UPDATE country SET current_regime_id = 'regime-autoritaire' WHERE id = 'mali' AND current_regime_id IS NULL;

-- Maroc : monarchie constitutionnelle
UPDATE country SET current_regime_id = 'monarchie-constitutionnelle' WHERE id = 'morocco' AND current_regime_id IS NULL;

-- Mexique : démocratie représentative
UPDATE country SET current_regime_id = 'democratie-representative' WHERE id = 'mexico' AND current_regime_id IS NULL;

-- Namibie : démocratie représentative
UPDATE country SET current_regime_id = 'democratie-representative' WHERE id = 'namibia' AND current_regime_id IS NULL;

-- Niger : régime autoritaire (junte militaire)
UPDATE country SET current_regime_id = 'regime-autoritaire' WHERE id = 'niger' AND current_regime_id IS NULL;

-- Nouvelle-Calédonie : démocratie représentative (territoire français)
UPDATE country SET current_regime_id = 'democratie-representative' WHERE id = 'new-caledonia' AND current_regime_id IS NULL;

-- Ouganda : régime autoritaire
UPDATE country SET current_regime_id = 'regime-autoritaire' WHERE id = 'uganda' AND current_regime_id IS NULL;

-- Ouzbékistan : régime autoritaire
UPDATE country SET current_regime_id = 'regime-autoritaire' WHERE id = 'uzbekistan' AND current_regime_id IS NULL;

-- Papouasie-Nouvelle-Guinée : démocratie représentative
UPDATE country SET current_regime_id = 'democratie-representative' WHERE id = 'papua-new-guinea' AND current_regime_id IS NULL;

-- Philippines : démocratie représentative
UPDATE country SET current_regime_id = 'democratie-representative' WHERE id = 'philippines' AND current_regime_id IS NULL;

-- Pérou : démocratie représentative
UPDATE country SET current_regime_id = 'democratie-representative' WHERE id = 'peru' AND current_regime_id IS NULL;

-- Qatar : monarchie absolue
UPDATE country SET current_regime_id = 'monarchie-absolue' WHERE id = 'qatar' AND current_regime_id IS NULL;

-- Rwanda : régime autoritaire
UPDATE country SET current_regime_id = 'regime-autoritaire' WHERE id = 'rwanda' AND current_regime_id IS NULL;

-- République centrafricaine : régime autoritaire
UPDATE country SET current_regime_id = 'regime-autoritaire' WHERE id = 'central-african-republic' AND current_regime_id IS NULL;

-- République du Congo : régime autoritaire
UPDATE country SET current_regime_id = 'regime-autoritaire' WHERE id = 'congo' AND current_regime_id IS NULL;

-- République démocratique du Congo : régime autoritaire
UPDATE country SET current_regime_id = 'regime-autoritaire' WHERE id = 'democratic-republic-of-congo' AND current_regime_id IS NULL;

-- Singapour : régime hybride (démocratie autoritaire)
UPDATE country SET current_regime_id = 'regime-hybride' WHERE id = 'singapore' AND current_regime_id IS NULL;

-- Somalie : régime hybride (état failli)
UPDATE country SET current_regime_id = 'regime-hybride' WHERE id = 'somalia' AND current_regime_id IS NULL;

-- Soudan du Sud : régime hybride (instabilité)
UPDATE country SET current_regime_id = 'regime-hybride' WHERE id = 'south-sudan' AND current_regime_id IS NULL;

-- Sri Lanka : démocratie représentative
UPDATE country SET current_regime_id = 'democratie-representative' WHERE id = 'sri-lanka' AND current_regime_id IS NULL;

-- Taïwan : démocratie représentative
UPDATE country SET current_regime_id = 'democratie-representative' WHERE id = 'taiwan' AND current_regime_id IS NULL;

-- Tchad : régime autoritaire
UPDATE country SET current_regime_id = 'regime-autoritaire' WHERE id = 'chad' AND current_regime_id IS NULL;

-- Vietnam : régime autoritaire (communiste)
UPDATE country SET current_regime_id = 'regime-autoritaire' WHERE id = 'vietnam' AND current_regime_id IS NULL;

-- Égypte : régime autoritaire
UPDATE country SET current_regime_id = 'regime-autoritaire' WHERE id = 'egypt' AND current_regime_id IS NULL;

-- Émirats arabes unis : monarchie absolue
UPDATE country SET current_regime_id = 'monarchie-absolue' WHERE id = 'uae' AND current_regime_id IS NULL;

-- Érythrée : régime autoritaire
UPDATE country SET current_regime_id = 'regime-autoritaire' WHERE id = 'eritrea' AND current_regime_id IS NULL;

-- Îles Marshall : démocratie représentative
UPDATE country SET current_regime_id = 'democratie-representative' WHERE id = 'marshall-islands' AND current_regime_id IS NULL;

-- Îles Salomon : démocratie représentative
UPDATE country SET current_regime_id = 'democratie-representative' WHERE id = 'solomon-islands' AND current_regime_id IS NULL; 