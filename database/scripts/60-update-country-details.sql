-- Mise à jour des informations détaillées pour 6 pays majeurs

UPDATE country SET
  regimePolitique = 'République unitaire semi-présidentielle',
  chefEtat = 'Emmanuel Macron',
  pib = 2639000000000,
  population = 68373433,
  revenuMedian = 25000,
  superficieKm2 = 551695,
  capitale = 'Paris',
  langue = 'Français',
  monnaie = 'Euro (EUR)',
  histoire = 'La France, héritière de la Gaule romaine, devient un royaume puissant au Moyen Âge puis une grande monarchie européenne. La Révolution française de 1789 marque la naissance de la République. Depuis, la France a connu plusieurs régimes politiques, deux guerres mondiales, la décolonisation et s’est imposée comme une puissance mondiale, membre fondateur de l’Union européenne.'
WHERE id = 'france';

UPDATE country SET
  regimePolitique = 'Monarchie constitutionnelle parlementaire',
  chefEtat = 'Charles III',
  pib = 3332000000000,
  population = 67736802,
  revenuMedian = 36000,
  superficieKm2 = 243610,
  capitale = 'Londres',
  langue = 'Anglais',
  monnaie = 'Livre sterling (GBP)',
  histoire = 'Le Royaume-Uni trouve ses origines dans l’union de l’Angleterre, de l’Écosse, du Pays de Galles et de l’Irlande du Nord. Puissance maritime et coloniale majeure du XIXe siècle, il a donné naissance à l’Empire britannique. Après deux guerres mondiales et la décolonisation, le Royaume-Uni reste une monarchie constitutionnelle influente sur la scène internationale.'
WHERE id = 'uk';

UPDATE country SET
  regimePolitique = 'République fédérale présidentielle',
  chefEtat = 'Joe Biden',
  pib = 27940000000000,
  population = 335893238,
  revenuMedian = 74580,
  superficieKm2 = 9833520,
  capitale = 'Washington, D.C.',
  langue = 'Anglais',
  monnaie = 'Dollar américain (USD)',
  histoire = 'Les États-Unis naissent en 1776 de la déclaration d’indépendance des treize colonies britanniques. Devenus une république fédérale, ils s’étendent vers l’ouest, abolissent l’esclavage après la guerre de Sécession, puis s’imposent comme première puissance économique et militaire mondiale au XXe siècle.'
WHERE id = 'usa';

UPDATE country SET
  regimePolitique = 'République socialiste à parti unique',
  chefEtat = 'Kim Jong-un',
  pib = 28000000000,
  population = 25971909,
  revenuMedian = NULL,
  superficieKm2 = 120538,
  capitale = 'Pyongyang',
  langue = 'Coréen',
  monnaie = 'Won nord-coréen (KPW)',
  histoire = 'La Corée du Nord est fondée en 1948 après la Seconde Guerre mondiale et la division de la péninsule coréenne. Dirigée par la dynastie Kim, elle adopte un régime communiste autoritaire, marqué par l’isolement international, la militarisation et des tensions récurrentes avec la Corée du Sud et les États-Unis.'
WHERE id = 'north-korea';

UPDATE country SET
  regimePolitique = 'République fédérale parlementaire',
  chefEtat = 'Droupadi Murmu',
  pib = 3730000000000,
  population = 1428627663,
  revenuMedian = 2400,
  superficieKm2 = 3287263,
  capitale = 'New Delhi',
  langue = 'Hindi, anglais',
  monnaie = 'Roupie indienne (INR)',
  histoire = 'Berceau d’anciennes civilisations, l’Inde est colonisée par le Royaume-Uni au XIXe siècle. Elle obtient son indépendance en 1947 sous la conduite de Gandhi et Nehru. République fédérale, l’Inde est aujourd’hui la plus grande démocratie du monde et une puissance émergente.'
WHERE id = 'india';

UPDATE country SET
  regimePolitique = 'République parlementaire',
  chefEtat = 'Guðni Th. Jóhannesson',
  pib = 28500000000,
  population = 383726,
  revenuMedian = 50000,
  superficieKm2 = 103000,
  capitale = 'Reykjavik',
  langue = 'Islandais',
  monnaie = 'Couronne islandaise (ISK)',
  histoire = 'L’Islande est colonisée par les Vikings au IXe siècle et adopte l’Althing, l’un des plus anciens parlements du monde. Après des siècles sous domination norvégienne puis danoise, l’Islande devient une république indépendante en 1944. Elle est aujourd’hui reconnue pour sa stabilité politique et son haut niveau de vie.'
WHERE id = 'iceland'; 