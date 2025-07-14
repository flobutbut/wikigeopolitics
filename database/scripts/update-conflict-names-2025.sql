-- =====================================================
-- Mise à jour des noms des conflits armés pour un affichage plus clair
-- Noms au format "Pays A - Pays B" ou "Région - Conflit"
-- =====================================================

-- Mise à jour des noms de conflits existants
UPDATE armed_conflict SET name = 'Russie - Ukraine' WHERE id = 1;
UPDATE armed_conflict SET name = 'Gaza - Israël' WHERE id = 2;
UPDATE armed_conflict SET name = 'Soudan - Guerre civile' WHERE id = 3;
UPDATE armed_conflict SET name = 'Éthiopie - Tigré' WHERE id = 4;
UPDATE armed_conflict SET name = 'Myanmar - Révolution' WHERE id = 5;
UPDATE armed_conflict SET name = 'Mali - Rébellion' WHERE id = 6;
UPDATE armed_conflict SET name = 'Syrie - Guerre civile' WHERE id = 7;
UPDATE armed_conflict SET name = 'Yémen - Guerre civile' WHERE id = 8;
UPDATE armed_conflict SET name = 'Afghanistan - Taliban' WHERE id = 9;
UPDATE armed_conflict SET name = 'Somalie - Al-Shabaab' WHERE id = 10;

-- Vérification des noms mis à jour
SELECT id, name, status, startyear FROM armed_conflict ORDER BY id;