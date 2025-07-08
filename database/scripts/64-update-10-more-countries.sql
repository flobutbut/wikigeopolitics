-- Script de mise à jour des données détaillées pour 10 pays supplémentaires
-- Italie, Espagne, Canada, Australie, Corée du Sud, Iran, Arabie Saoudite, Afrique du Sud, Mexique, Turquie

-- Italie
UPDATE country SET 
    regimepolitique = 'republique-parlementaire',
    chefetat = 'Sergio Mattarella',
    pib = 2010430000000,
    population = 60360000,
    revenumedian = 35000,
    superficiekm2 = 301340,
    capitale = 'Rome',
    langue = 'Italien',
    monnaie = 'Euro',
    histoire = 'L''Italie, officiellement la République italienne, est née de l''unification de 1861. Le pays a connu le fascisme de 1922 à 1945, puis est devenu une république démocratique. L''Italie est un membre fondateur de l''Union européenne et de l''OTAN. Le pays est connu pour son patrimoine culturel exceptionnel, son industrie de luxe et son influence dans la mode et le design.'
WHERE id = 'italy';

-- Espagne
UPDATE country SET 
    regimepolitique = 'monarchie-constitutionnelle',
    chefetat = 'Felipe VI',
    pib = 1395000000000,
    population = 47350000,
    revenumedian = 30000,
    superficiekm2 = 505990,
    capitale = 'Madrid',
    langue = 'Espagnol',
    monnaie = 'Euro',
    histoire = 'L''Espagne, officiellement le Royaume d''Espagne, a été unifiée sous les Rois Catholiques en 1492. Le pays a connu l''empire colonial espagnol, puis la dictature franquiste de 1939 à 1975. Depuis 1978, l''Espagne est une monarchie constitutionnelle démocratique. Le pays est membre de l''Union européenne et de l''OTAN.'
WHERE id = 'spain';

-- Canada
UPDATE country SET 
    regimepolitique = 'monarchie-constitutionnelle',
    chefetat = 'Charles III',
    pib = 2139840000000,
    population = 38250000,
    revenumedian = 52000,
    superficiekm2 = 9984670,
    capitale = 'Ottawa',
    langue = 'Anglais, Français',
    monnaie = 'Dollar canadien',
    histoire = 'Le Canada, officiellement la Confédération canadienne, est né de l''union de colonies britanniques en 1867. Le pays a obtenu son indépendance progressive du Royaume-Uni et est devenu un dominion autonome. Le Canada est une monarchie constitutionnelle fédérale, membre du Commonwealth. Le pays est connu pour sa diversité culturelle, ses vastes territoires naturels et sa qualité de vie élevée.'
WHERE id = 'canada';

-- Australie
UPDATE country SET 
    regimepolitique = 'monarchie-constitutionnelle',
    chefetat = 'Charles III',
    pib = 1675416000000,
    population = 25690000,
    revenumedian = 65000,
    superficiekm2 = 7692024,
    capitale = 'Canberra',
    langue = 'Anglais',
    monnaie = 'Dollar australien',
    histoire = 'L''Australie, officiellement le Commonwealth d''Australie, a été colonisée par les Britanniques en 1788. Le pays a obtenu son indépendance en 1901 et est devenu une fédération. L''Australie est une monarchie constitutionnelle fédérale, membre du Commonwealth. Le pays est connu pour sa biodiversité unique, ses ressources naturelles abondantes et son économie développée.'
WHERE id = 'australia';

-- Corée du Sud
UPDATE country SET 
    regimepolitique = 'democratie-representative',
    chefetat = 'Yoon Suk-yeol',
    pib = 1674000000000,
    population = 51740000,
    revenumedian = 35000,
    superficiekm2 = 100210,
    capitale = 'Séoul',
    langue = 'Coréen',
    monnaie = 'Won sud-coréen',
    histoire = 'La Corée du Sud, officiellement la République de Corée, a été fondée en 1948 après la division de la péninsule coréenne. Le pays a connu une croissance économique spectaculaire depuis les années 1960, devenant l''un des "Tigres asiatiques". La Corée du Sud est une démocratie parlementaire développée, leader dans les technologies et l''innovation.'
WHERE id = 'south-korea';

-- Iran
UPDATE country SET 
    regimepolitique = 'theocratie',
    chefetat = 'Ali Khamenei',
    pib = 367970000000,
    population = 85000000,
    revenumedian = 5500,
    superficiekm2 = 1648195,
    capitale = 'Téhéran',
    langue = 'Persan',
    monnaie = 'Rial iranien',
    histoire = 'L''Iran, officiellement la République islamique d''Iran, a une histoire millénaire remontant à l''Empire perse. En 1979, la Révolution islamique a renversé la monarchie et établi une république islamique. L''Iran est une théocratie où le pouvoir religieux et politique sont fusionnés. Le pays est une puissance régionale majeure au Moyen-Orient.'
WHERE id = 'iran';

-- Arabie Saoudite
UPDATE country SET 
    regimepolitique = 'monarchie-absolue',
    chefetat = 'Salmane ben Abdelaziz Al Saoud',
    pib = 1010000000000,
    population = 35950000,
    revenumedian = 25000,
    superficiekm2 = 2149690,
    capitale = 'Riyad',
    langue = 'Arabe',
    monnaie = 'Riyal saoudien',
    histoire = 'L''Arabie Saoudite, officiellement le Royaume d''Arabie saoudite, a été unifiée en 1932 par Abdelaziz Al Saoud. Le pays est une monarchie absolue gouvernée par la famille Al Saoud. L''Arabie Saoudite est le plus grand exportateur de pétrole au monde et un leader du monde arabe. Le pays est le gardien des lieux saints de l''islam.'
WHERE id = 'saudi-arabia';

-- Afrique du Sud
UPDATE country SET 
    regimepolitique = 'republique-parlementaire',
    chefetat = 'Cyril Ramaphosa',
    pib = 405870000000,
    population = 59310000,
    revenumedian = 6000,
    superficiekm2 = 1221037,
    capitale = 'Pretoria',
    langue = 'Anglais, Afrikaans, Zoulou',
    monnaie = 'Rand sud-africain',
    histoire = 'L''Afrique du Sud, officiellement la République d''Afrique du Sud, a été colonisée par les Européens au XVIIe siècle. Le pays a connu l''apartheid de 1948 à 1994. En 1994, Nelson Mandela est devenu le premier président noir démocratiquement élu. L''Afrique du Sud est la première économie d''Afrique et un leader continental.'
WHERE id = 'south-africa';

-- Mexique
UPDATE country SET 
    regimepolitique = 'republique-federale',
    chefetat = 'Andrés Manuel López Obrador',
    pib = 1417000000000,
    population = 128900000,
    revenumedian = 9500,
    superficiekm2 = 1964375,
    capitale = 'Mexico',
    langue = 'Espagnol',
    monnaie = 'Peso mexicain',
    histoire = 'Le Mexique, officiellement les États-Unis mexicains, a été colonisé par l''Espagne au XVIe siècle. Le pays a obtenu son indépendance en 1821. Le Mexique est une république fédérale démocratique. Le pays est la deuxième économie d''Amérique latine et un partenaire commercial majeur des États-Unis.'
WHERE id = 'mexico';

-- Turquie
UPDATE country SET 
    regimepolitique = 'regime-hybride',
    chefetat = 'Recep Tayyip Erdoğan',
    pib = 905987000000,
    population = 84780000,
    revenumedian = 9500,
    superficiekm2 = 783562,
    capitale = 'Ankara',
    langue = 'Turc',
    monnaie = 'Livre turque',
    histoire = 'La Turquie, officiellement la République de Turquie, a été fondée en 1923 par Mustafa Kemal Atatürk après la chute de l''Empire ottoman. Le pays a adopté un système laïc et occidental. La Turquie est un pont géographique entre l''Europe et l''Asie. Le pays est membre de l''OTAN et candidat à l''Union européenne.'
WHERE id = 'turkey'; 