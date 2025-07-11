-- Génération des relations pays-régimes politiques
-- Distribution aléatoire des pays entre les régimes politiques

-- 1. Vérifier les régimes politiques disponibles
SELECT id, name FROM political_regime ORDER BY name;

-- 2. Créer une fonction pour générer les relations par paquets
CREATE OR REPLACE FUNCTION generate_country_regime_relations(batch_size INTEGER DEFAULT 15)
RETURNS VOID AS $$
DECLARE
    country_record RECORD;
    regime_record RECORD;
    regime_count INTEGER;
    current_batch INTEGER := 0;
    total_countries INTEGER;
    processed_countries INTEGER := 0;
BEGIN
    -- Compter le nombre total de pays
    SELECT COUNT(*) INTO total_countries FROM country;
    
    -- Récupérer tous les régimes politiques
    SELECT COUNT(*) INTO regime_count FROM political_regime;
    
    RAISE NOTICE 'Début de la génération des relations pour % pays avec % régimes', total_countries, regime_count;
    
    -- Pour chaque pays, assigner un régime politique aléatoire
    FOR country_record IN SELECT id, nom FROM country ORDER BY nom LOOP
        -- Sélectionner un régime politique aléatoire
        SELECT * INTO regime_record 
        FROM political_regime 
        ORDER BY RANDOM() 
        LIMIT 1;
        
        -- Insérer la relation
        INSERT INTO country_political_regime (country_id, regime_id, current_regime, start_year, notes)
        VALUES (
            country_record.id, 
            regime_record.id, 
            true, 
            EXTRACT(YEAR FROM CURRENT_DATE),
            'Généré automatiquement - ' || country_record.nom || ' -> ' || regime_record.name
        );
        
        processed_countries := processed_countries + 1;
        current_batch := current_batch + 1;
        
        -- Afficher le progrès tous les 15 pays
        IF current_batch >= batch_size THEN
            RAISE NOTICE 'Paquet % terminé: % pays traités sur %', 
                (processed_countries / batch_size), processed_countries, total_countries;
            current_batch := 0;
        END IF;
    END LOOP;
    
    RAISE NOTICE 'Génération terminée: % pays traités', processed_countries;
END;
$$ LANGUAGE plpgsql;

-- 3. Exécuter la génération
SELECT generate_country_regime_relations(15);

-- 4. Vérifier les résultats
SELECT 
    pr.name as regime_name,
    COUNT(cpr.country_id) as country_count
FROM political_regime pr
LEFT JOIN country_political_regime cpr ON pr.id = cpr.regime_id
WHERE cpr.current_regime = true
GROUP BY pr.id, pr.name
ORDER BY country_count DESC;

-- 5. Afficher quelques exemples
SELECT 
    c.nom as country_name,
    pr.name as regime_name,
    cpr.start_year,
    cpr.notes
FROM country_political_regime cpr
JOIN country c ON cpr.country_id = c.id
JOIN political_regime pr ON cpr.regime_id = pr.id
WHERE cpr.current_regime = true
ORDER BY c.nom
LIMIT 10; 