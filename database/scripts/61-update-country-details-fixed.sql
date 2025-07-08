-- Script de mise à jour des données détaillées pour 6 pays
-- Utilise les vrais noms de colonnes de la table country

-- France
UPDATE country SET 
    regimepolitique = 'democratie',
    chefetat = 'Emmanuel Macron',
    pib = 2782900000000,
    population = 67390000,
    revenumedian = 42000,
    superficiekm2 = 551695,
    capitale = 'Paris',
    langue = 'Français',
    monnaie = 'Euro',
    histoire = 'La France, officiellement la République française, est un pays d''Europe occidentale. Fondée en 987, elle est devenue une puissance majeure sous les rois capétiens. La Révolution française de 1789 a transformé la monarchie en république. Au XIXe siècle, la France a étendu son empire colonial. Après les deux guerres mondiales, elle est devenue un membre fondateur de l''Union européenne et une puissance nucléaire.'
WHERE id = 'france';

-- Royaume-Uni
UPDATE country SET 
    regimepolitique = 'democratie',
    chefetat = 'Charles III',
    pib = 3070667000000,
    population = 67220000,
    revenumedian = 46000,
    superficiekm2 = 242495,
    capitale = 'Londres',
    langue = 'Anglais',
    monnaie = 'Livre sterling',
    histoire = 'Le Royaume-Uni de Grande-Bretagne et d''Irlande du Nord est né de l''union de l''Angleterre et de l''Écosse en 1707. Au XIXe siècle, l''Empire britannique est devenu le plus vaste empire de l''histoire. Le pays a joué un rôle crucial dans les deux guerres mondiales. En 1973, il rejoint la CEE, mais quitte l''Union européenne en 2020 (Brexit).'
WHERE id = 'uk';

-- États-Unis
UPDATE country SET 
    regimepolitique = 'democratie',
    chefetat = 'Joe Biden',
    pib = 25462700000000,
    population = 331900000,
    revenumedian = 74000,
    superficiekm2 = 9833517,
    capitale = 'Washington D.C.',
    langue = 'Anglais',
    monnaie = 'Dollar américain',
    histoire = 'Les États-Unis d''Amérique sont nés de la déclaration d''indépendance de 1776. La Constitution de 1787 a établi un système fédéral. Le XIXe siècle a vu l''expansion territoriale vers l''ouest et la guerre civile (1861-1865). Au XXe siècle, les États-Unis sont devenus une superpuissance mondiale, leader de l''économie capitaliste et de l''innovation technologique.'
WHERE id = 'usa';

-- Corée du Nord
UPDATE country SET 
    regimepolitique = 'dictature',
    chefetat = 'Kim Jong-un',
    pib = 18000000000,
    population = 25780000,
    revenumedian = 1300,
    superficiekm2 = 120540,
    capitale = 'Pyongyang',
    langue = 'Coréen',
    monnaie = 'Won nord-coréen',
    histoire = 'La Corée du Nord, officiellement République populaire démocratique de Corée, a été fondée en 1948 après la division de la péninsule coréenne. Dirigée par la dynastie Kim depuis 1948, le pays suit l''idéologie du Juche (autosuffisance). Isolée internationalement, la Corée du Nord a développé un programme nucléaire controversé et maintient un régime totalitaire.'
WHERE id = 'north-korea';

-- Inde
UPDATE country SET 
    regimepolitique = 'democratie',
    chefetat = 'Droupadi Murmu',
    pib = 3385089000000,
    population = 1408000000,
    revenumedian = 2200,
    superficiekm2 = 3287263,
    capitale = 'New Delhi',
    langue = 'Hindi',
    monnaie = 'Roupie indienne',
    histoire = 'L''Inde, officiellement la République de l''Inde, a obtenu son indépendance du Royaume-Uni en 1947. Plus grande démocratie du monde, l''Inde a connu une croissance économique rapide depuis les réformes de 1991. Le pays est marqué par sa diversité culturelle, religieuse et linguistique. L''Inde est devenue une puissance régionale majeure en Asie du Sud.'
WHERE id = 'india';

-- Islande
UPDATE country SET 
    regimepolitique = 'democratie',
    chefetat = 'Guðni Th. Jóhannesson',
    pib = 25691000000,
    population = 372000,
    revenumedian = 67000,
    superficiekm2 = 103000,
    capitale = 'Reykjavik',
    langue = 'Islandais',
    monnaie = 'Couronne islandaise (ISK)',
    histoire = 'L''Islande, officiellement la République d''Islande, a été colonisée par les Vikings norvégiens au IXe siècle. Le pays a obtenu son indépendance du Danemark en 1944. L''Islande est connue pour ses paysages volcaniques, ses sources géothermiques et ses aurores boréales. Le pays a surmonté la crise financière de 2008 et est devenu un modèle de développement durable.'
WHERE id = 'iceland'; 