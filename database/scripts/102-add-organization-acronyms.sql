-- Script pour ajouter les acronymes aux organisations
-- Basé sur les acronymes déjà mentionnés dans les noms et les acronymes standards

-- Organisations avec acronymes déjà mentionnés dans le nom
UPDATE organization SET acronyme = 'AIE' WHERE id = 'org_iea';
UPDATE organization SET acronyme = 'IRENA' WHERE id = 'org_irena';
UPDATE organization SET acronyme = 'ASEAN' WHERE id = 'org_asean';
UPDATE organization SET acronyme = 'CAE' WHERE id = 'org_eac';
UPDATE organization SET acronyme = 'SADC' WHERE id = 'org_sadc';
UPDATE organization SET acronyme = 'CEI' WHERE id = 'org_commonwealth_independent';
UPDATE organization SET acronyme = 'CEDEAO' WHERE id = 'org_ecowas';
UPDATE organization SET acronyme = 'CCG' WHERE id = 'org_gulf_cooperation';
UPDATE organization SET acronyme = 'FMI' WHERE id = 'org_imf';
UPDATE organization SET acronyme = 'FPEG' WHERE id = 'org_gas_exporting';
UPDATE organization SET acronyme = 'OCDE' WHERE id = 'org_oecd';
UPDATE organization SET acronyme = 'OACI' WHERE id = 'org_icao';
UPDATE organization SET acronyme = 'OPEP' WHERE id = 'org_opec';
UPDATE organization SET acronyme = 'OTAN' WHERE id = 'org_nato';
UPDATE organization SET acronyme = 'OTSC' WHERE id = 'org_csto';
UPDATE organization SET acronyme = 'OIF' WHERE id = 'org_francophonie';
UPDATE organization SET acronyme = 'ISO' WHERE id = 'org_iso';
UPDATE organization SET acronyme = 'OMI' WHERE id = 'org_imo';
UPDATE organization SET acronyme = 'OMS' WHERE id = 'org_who';
UPDATE organization SET acronyme = 'OMC' WHERE id = 'org_wto';
UPDATE organization SET acronyme = 'UA' WHERE id = 'org_african_union';
UPDATE organization SET acronyme = 'ZLECAf' WHERE id = 'org_afcfta';

-- Organisations avec acronymes standards
UPDATE organization SET acronyme = 'ALENA' WHERE id = 'rel_accord_libre_echange_na';
UPDATE organization SET acronyme = 'AEUMC' WHERE id = 'rel_accord_etats_unis_mexique_canada';
UPDATE organization SET acronyme = 'BM' WHERE id = 'org_world_bank';
UPDATE organization SET acronyme = 'CN' WHERE id = 'org_commonwealth';
UPDATE organization SET acronyme = 'CCG' WHERE id = 'rel_conseil_cooperation_golfe';
UPDATE organization SET acronyme = 'APEC' WHERE id = 'apec';
UPDATE organization SET acronyme = 'G7' WHERE id = 'g7';
UPDATE organization SET acronyme = 'G20' WHERE id = 'g20';
UPDATE organization SET acronyme = 'MERCOSUR' WHERE id = 'org_mercosur';
UPDATE organization SET acronyme = 'ONU' WHERE id = 'onu';
UPDATE organization SET acronyme = 'OEA' WHERE id = 'rel_organisation_etats_americains';
UPDATE organization SET acronyme = 'OTSC' WHERE id = 'rel_organisation_traite_securite_collective';
UPDATE organization SET acronyme = 'UE' WHERE id = 'ue';

-- Vérification des acronymes ajoutés
SELECT id, nom, acronyme, type 
FROM organization 
ORDER BY nom; 