-- Script de mise à jour des données détaillées pour 5 pays supplémentaires
-- Chine, Allemagne, Japon, Brésil, Russie

-- Chine
UPDATE country SET 
    regimepolitique = 'regime-autoritaire',
    chefetat = 'Xi Jinping',
    pib = 17963170000000,
    population = 1439000000,
    revenumedian = 12500,
    superficiekm2 = 9596961,
    capitale = 'Pékin',
    langue = 'Mandarin',
    monnaie = 'Yuan renminbi',
    histoire = 'La Chine, officiellement la République populaire de Chine, est l''une des plus anciennes civilisations du monde. L''histoire chinoise remonte à plus de 4000 ans avec les dynasties successives. En 1949, Mao Zedong proclame la République populaire de Chine après la victoire communiste. Depuis les réformes économiques de 1978, la Chine est devenue la deuxième économie mondiale et une puissance majeure sur la scène internationale.'
WHERE id = 'china';

-- Allemagne
UPDATE country SET 
    regimepolitique = 'republique-parlementaire',
    chefetat = 'Frank-Walter Steinmeier',
    pib = 4072191000000,
    population = 83290000,
    revenumedian = 52000,
    superficiekm2 = 357022,
    capitale = 'Berlin',
    langue = 'Allemand',
    monnaie = 'Euro',
    histoire = 'L''Allemagne, officiellement la République fédérale d''Allemagne, a été unifiée en 1871 sous l''Empire allemand. Après la défaite de 1945, l''Allemagne a été divisée en RFA et RDA. La chute du mur de Berlin en 1989 a permis la réunification en 1990. L''Allemagne est aujourd''hui la première économie européenne et un leader de l''Union européenne.'
WHERE id = 'germany';

-- Japon
UPDATE country SET 
    regimepolitique = 'monarchie-constitutionnelle',
    chefetat = 'Naruhito',
    pib = 4231141000000,
    population = 125700000,
    revenumedian = 42000,
    superficiekm2 = 377975,
    capitale = 'Tokyo',
    langue = 'Japonais',
    monnaie = 'Yen japonais',
    histoire = 'Le Japon, officiellement l''État du Japon, est une monarchie constitutionnelle avec une histoire millénaire. Après la défaite de 1945, le Japon a adopté une constitution pacifiste et s''est reconstruit pour devenir la troisième économie mondiale. Le pays est connu pour son innovation technologique, sa culture traditionnelle et son système éducatif performant.'
WHERE id = 'japan';

-- Brésil
UPDATE country SET 
    regimepolitique = 'republique-federale',
    chefetat = 'Luiz Inácio Lula da Silva',
    pib = 1920095000000,
    population = 214300000,
    revenumedian = 8900,
    superficiekm2 = 8515767,
    capitale = 'Brasília',
    langue = 'Portugais',
    monnaie = 'Real brésilien',
    histoire = 'Le Brésil, officiellement la République fédérative du Brésil, a été colonisé par le Portugal au XVIe siècle. Le pays a obtenu son indépendance en 1822 et est devenu une république en 1889. Plus grand pays d''Amérique du Sud, le Brésil est une puissance émergente avec une économie diversifiée et une influence croissante sur la scène internationale.'
WHERE id = 'brazil';

-- Russie
UPDATE country SET 
    regimepolitique = 'regime-autoritaire',
    chefetat = 'Vladimir Poutine',
    pib = 2240910000000,
    population = 144100000,
    revenumedian = 12000,
    superficiekm2 = 17098246,
    capitale = 'Moscou',
    langue = 'Russe',
    monnaie = 'Rouble russe',
    histoire = 'La Russie, officiellement la Fédération de Russie, est le plus grand pays du monde par sa superficie. L''histoire russe remonte à la principauté de Moscou au XIIIe siècle. L''Empire russe s''est étendu jusqu''à devenir l''URSS en 1922. Après la chute de l''URSS en 1991, la Russie est devenue une fédération indépendante. Le pays reste une puissance nucléaire et un acteur majeur de la géopolitique mondiale.'
WHERE id = 'russia'; 