import '../models/catalog.dart';
import '../models/client.dart';
import '../models/notification.dart';
import '../models/order.dart';
import '../models/product.dart';
import '../models/store.dart';
import 'app_state.dart';

/// The demo client and the store owner account the Store app logs into.
const demoClientId = 'c-yacine';
const demoStoreId = 's-fatma';

Duration _h(int hours) => Duration(hours: hours);
Duration _d(int days) => Duration(days: days);
const _m30 = Duration(minutes: 30);

/// Fresh demo data, with every time relative to [now] (the simulated clock).
/// Store content is written the way Algerian sellers write it (French + some Arabic).
AppState seed(DateTime now) {
  DateTime ago(Duration d) => now.subtract(d);

  final stores = [
    const Store(
      id: 's-fatma',
      name: 'Dar Lalla Fatma',
      description:
          'Gâteaux traditionnels faits maison depuis 20 ans : baklawa, makrout, tcharek.',
      commune: 'Kouba',
      wilaya: 'Alger',
      distanceKm: 2.5,
      reliability: 97,
      picture: StorePicture.photo,
      phone: '0661 42 18 75',
      cardNumber: '16021987450',
      activity: Service.cooking,
      ccp: '001234567842',
      pickup: (0.42, 0.58),
    ),
    const Store(
      id: 's-amina',
      name: "Les Délices d'Amina",
      description:
          'Gâteaux de fête et pâtisserie fine, sur commande ou prêts à emporter.',
      commune: 'Chéraga',
      wilaya: 'Alger',
      distanceKm: 9,
      reliability: 94,
      picture: StorePicture.photo,
    ),
    const Store(
      id: 's-yemma',
      name: 'Couscous Yemma',
      description: 'Plats et pains traditionnels, comme chez Yemma.',
      commune: 'Blida',
      wilaya: 'Blida',
      distanceKm: 38,
      reliability: 91,
      picture: StorePicture.photo,
      pro: true,
    ),
    const Store(
      id: 's-nour',
      name: 'Atelier Karakou Nour',
      description:
          'Karakou et tenues traditionnelles brodées main, sur mesure.',
      commune: 'Bab Ezzouar',
      wilaya: 'Alger',
      distanceKm: 1.2,
      reliability: 100,
      picture: StorePicture.photo,
      pro: true,
    ),
    const Store(
      id: 's-fekhar',
      name: 'Poterie Na Ouardia',
      description: 'Poterie kabyle modelée et peinte à la main par Na Ouardia.',
      commune: 'Tizi Ouzou',
      wilaya: 'Tizi Ouzou',
      distanceKm: 95,
      reliability: 88,
      picture: StorePicture.photo,
    ),
    const Store(
      id: 's-thiziri',
      name: 'Bijoux Thiziri',
      description: 'Bijoux kabyles en argent émaillé.',
      commune: 'Oran',
      wilaya: 'Oran',
      distanceKm: 410,
      reliability: 96,
      picture: StorePicture.photo,
      paused: true,
    ),
    const Store(
      id: 's-hlou',
      name: 'Hlou Qacentina',
      description:
          'Gâteaux constantinois : baklawa, kalb el louz, samsa et plateaux de fête.',
      commune: 'Hussein Dey',
      wilaya: 'Alger',
      distanceKm: 6,
      reliability: 95,
      picture: StorePicture.photo,
    ),
    const Store(
      id: 's-zohra',
      name: 'Cuisine Khalti Zohra',
      description: 'Plats et galettes de Biskra, cuisinés chaque matin.',
      commune: 'Rouiba',
      wilaya: 'Alger',
      distanceKm: 14,
      reliability: 92,
      picture: StorePicture.photo,
    ),
    const Store(
      id: 's-zineb',
      name: 'Maison Lalla Zineb',
      description:
          'Karakou, qaftan, blouza et jebba fergani brodés main, sur mesure.',
      commune: 'Tlemcen',
      wilaya: 'Tlemcen',
      distanceKm: 520,
      reliability: 98,
      picture: StorePicture.photo,
      pro: true,
    ),
    const Store(
      id: 's-tafsut',
      name: 'Atelier Tafsut',
      description: 'Robes kabyles, burnous et gandouras cousus à Azazga.',
      commune: 'Azazga',
      wilaya: 'Tizi Ouzou',
      distanceKm: 120,
      reliability: 93,
      picture: StorePicture.photo,
    ),
    const Store(
      id: 's-tinhinan',
      name: 'Bijoux Tin Hinan',
      description:
          'Bijoux touareg, amazighs et kabyles en argent, faits par nos artisanes.',
      commune: 'Tamanrasset',
      wilaya: 'Tamanrasset',
      distanceKm: 1900,
      reliability: 90,
      picture: StorePicture.photo,
      pro: true,
    ),
    const Store(
      id: 's-nedroma',
      name: 'Fekhara Nedroma',
      description:
          'Poterie tournée et peinte à la main : jarras, qollas, tbassi.',
      commune: 'Nedroma',
      wilaya: 'Tlemcen',
      distanceKm: 560,
      reliability: 89,
      picture: StorePicture.photo,
    ),
    const Store(
      id: 's-ghardaia',
      name: 'Tissages Lalla Aïcha',
      description:
          'Tapis tissés main par Lalla Aïcha et vannerie en palmier du Mzab.',
      commune: 'Ghardaïa',
      wilaya: 'Ghardaïa',
      distanceKm: 600,
      reliability: 96,
      picture: StorePicture.photo,
    ),
  ];

  final products = [
    // Dar Lalla Fatma: traditional sweets
    Product(
      id: 'p-baklawa',
      storeId: 's-fatma',
      category: Category.traditionalSweets,
      title: 'Boîte de baklawa (12 pièces)',
      description: 'Baklawa aux amandes, feuilletée fine, arrosée de miel.',
      ingredients: "Amandes, miel, beurre, eau de fleur d'oranger",
      unit: Unit.box,
      photos: 3,
      readyMade: const ReadyMade(price: 2400, stock: 5, prepTime: _m30),
      createdAt: ago(_d(60)),
      sold: 41,
    ),
    Product(
      id: 'p-makrout',
      storeId: 's-fatma',
      category: Category.traditionalSweets,
      title: 'Makrout el louz',
      description: 'Makrout aux amandes, préparé le jour même pour votre date.',
      ingredients: "Amandes, sucre glace, miel, eau de fleur d'oranger",
      unit: Unit.kg,
      photos: 2,
      madeToOrder: const MadeToOrder(
        price: 2800,
        minQty: 1,
        step: 0.5,
        maxQty: 10,
        leadTime: Duration(hours: 48),
        prepTime: Duration(hours: 24),
        availableDays: {DateTime.tuesday, DateTime.thursday, DateTime.saturday},
        optionGroups: [
          OptionGroup(
            'g-extras',
            'Extras',
            OptionType.multiple,
            choices: [
              OptionChoice(
                'c-honey',
                'Glaçage au miel',
                price: 200,
                perUnit: true,
              ),
              OptionChoice('c-gift', 'Boîte cadeau', price: 300),
            ],
          ),
        ],
      ),
      createdAt: ago(_d(90)),
      sold: 63,
    ),
    Product(
      id: 'p-griwech',
      storeId: 's-fatma',
      category: Category.traditionalSweets,
      title: 'Griwech',
      description: 'Griwech croustillant au miel et sésame.',
      ingredients: 'Farine, miel, sésame, beurre',
      unit: Unit.box,
      readyMade: const ReadyMade(
        price: 1200,
        stock: 8,
        reserved: 2,
        prepTime: _m30,
      ),
      createdAt: ago(_d(40)),
      sold: 25,
    ),
    Product(
      id: 'p-tcharek',
      storeId: 's-fatma',
      category: Category.traditionalSweets,
      title: 'Tcharek el ariane (6 pièces)',
      description: 'Cornes de gazelle glacées, farce amandes.',
      ingredients: "Amandes, farine, sucre glace, eau de fleur d'oranger",
      unit: Unit.box,
      readyMade: const ReadyMade(price: 1500, stock: 10, prepTime: _m30),
      createdAt: ago(_d(30)),
      sold: 30,
    ),
    Product(
      id: 'p-mkhabez',
      storeId: 's-fatma',
      category: Category.traditionalSweets,
      title: 'Mkhabez',
      ingredients: 'Amandes, sucre glace, citron',
      unit: Unit.box,
      status: ProductStatus.paused,
      readyMade: const ReadyMade(price: 1800, stock: 4),
      createdAt: ago(_d(20)),
      sold: 12,
    ),

    // Les Délices d'Amina: cakes
    Product(
      id: 'p-wedding',
      storeId: 's-amina',
      category: Category.cakes,
      title: 'Gâteau de mariage',
      description:
          'Pièce montée à étages, décor crème au beurre et fleurs en sucre.',
      ingredients: 'Farine, œufs, beurre, sucre, crème',
      photos: 3,
      madeToOrder: const MadeToOrder(
        price: 6000,
        maxQty: 1,
        leadTime: Duration(days: 5),
        prepTime: Duration(days: 2),
        availableDays: {DateTime.thursday, DateTime.friday, DateTime.saturday},
        optionGroups: [
          OptionGroup(
            'g-size',
            'Taille',
            OptionType.single,
            required: true,
            choices: [
              OptionChoice('c-s', 'S · 20 parts'),
              OptionChoice('c-m', 'M · 40 parts', price: 3000),
              OptionChoice('c-l', 'L · 60 parts', price: 6000),
            ],
          ),
          OptionGroup(
            'g-flavour',
            'Parfum',
            OptionType.single,
            required: true,
            choices: [
              OptionChoice('c-choco', 'Chocolat'),
              OptionChoice('c-vanilla', 'Vanille-fraise'),
              OptionChoice('c-pistachio', 'Pistache', price: 500),
            ],
          ),
          OptionGroup(
            'g-name',
            'Prénom sur le gâteau',
            OptionType.text,
            maxLength: 30,
          ),
        ],
      ),
      createdAt: ago(_d(50)),
      sold: 8,
    ),
    Product(
      id: 'p-fraisier',
      storeId: 's-amina',
      category: Category.cakes,
      title: 'Fraisier',
      description:
          'Génoise, crème mousseline vanille et fraises fraîches. 8 parts.',
      ingredients: 'Fraises, œufs, farine, beurre, sucre, vanille',
      photos: 2,
      readyMade: const ReadyMade(price: 3200, stock: 4),
      createdAt: ago(_d(45)),
      sold: 22,
    ),
    Product(
      id: 'p-tarte',
      storeId: 's-amina',
      category: Category.cakes,
      title: 'Tarte au citron meringuée',
      description: 'Pâte sablée, crème citron, meringue italienne. 8 parts.',
      ingredients: 'Citrons, œufs, beurre, farine, sucre',
      readyMade: const ReadyMade(price: 2500, stock: 6),
      madeToOrder: const MadeToOrder(
        price: 2500,
        leadTime: Duration(hours: 24),
        prepTime: Duration(hours: 12),
      ),
      createdAt: ago(_d(5)),
      sold: 18,
    ),
    Product(
      id: 'p-cupcakes',
      storeId: 's-amina',
      category: Category.cakes,
      title: 'Cupcakes (boîte de 6)',
      description: 'Vanille et chocolat, glaçage crème au beurre.',
      ingredients: 'Farine, œufs, beurre, sucre, cacao',
      unit: Unit.box,
      freeDelivery: true,
      readyMade: const ReadyMade(price: 1300, stock: 10),
      createdAt: ago(_d(3)),
      sold: 9,
    ),

    // Couscous Yemma: traditional food + breads (Pro)
    Product(
      id: 'p-couscous',
      storeId: 's-yemma',
      category: Category.traditionalFood,
      title: 'Couscous au poulet',
      description: 'Graine roulée main, légumes de saison et poulet fermier.',
      ingredients:
          'Semoule, poulet, carottes, navets, courgettes, pois chiches',
      unit: Unit.portion,
      photos: 2,
      readyMade: const ReadyMade(price: 900, stock: 2),
      createdAt: ago(_d(70)),
      sold: 57,
    ),
    Product(
      id: 'p-msemen',
      storeId: 's-yemma',
      category: Category.breads,
      title: 'Msemen',
      description: 'Feuilletés carrés cuits à la poêle, nature.',
      ingredients: 'Semoule, farine, beurre, sel',
      readyMade: const ReadyMade(price: 60, stock: 0),
      madeToOrder: const MadeToOrder(
        price: 60,
        minQty: 10,
        step: 5,
        leadTime: Duration(hours: 24),
        prepTime: Duration(hours: 6),
        availableDays: {
          DateTime.saturday,
          DateTime.sunday,
          DateTime.monday,
          DateTime.tuesday,
          DateTime.wednesday, //
          DateTime.thursday,
        },
      ),
      createdAt: ago(_d(80)),
      sold: 120,
    ),
    Product(
      id: 'p-rechta',
      storeId: 's-yemma',
      category: Category.traditionalFood,
      title: 'Rechta',
      description: 'Rechta algéroise, sauce blanche au poulet et navets.',
      ingredients: 'Pâtes fraîches, poulet, navets, pois chiches, cannelle',
      unit: Unit.portion,
      readyMade: const ReadyMade(price: 1100, stock: 4),
      createdAt: ago(_d(35)),
      sold: 33,
    ),
    Product(
      id: 'p-kesra',
      storeId: 's-yemma',
      category: Category.breads,
      title: 'Kesra (galette)',
      description: 'Galette de semoule cuite au tajine.',
      ingredients: 'Semoule, huile d\'olive, sel',
      readyMade: const ReadyMade(price: 200, stock: 15, prepTime: _m30),
      createdAt: ago(_d(25)),
      sold: 70,
    ),
    Product(
      id: 'p-chakhchoukha',
      storeId: 's-yemma',
      category: Category.traditionalFood,
      title: 'Chakhchoukha',
      description: 'Galette émiettée, sauce rouge et viande d\'agneau.',
      ingredients: 'Semoule, agneau, tomates, pois chiches, piment',
      unit: Unit.portion,
      readyMade: const ReadyMade(price: 1000, stock: 0),
      createdAt: ago(_d(15)),
      sold: 19,
    ),

    // Atelier Karakou Nour: sewing (Pro)
    Product(
      id: 'p-karakou',
      storeId: 's-nour',
      category: Category.traditionalClothing,
      title: 'Karakou brodé main',
      description:
          'Veste en velours brodée au fil doré (medjboud), sarouel assorti.',
      photos: 3,
      madeToOrder: const MadeToOrder(
        price: 45000,
        maxQty: 1,
        leadTime: Duration(days: 21),
        prepTime: Duration(days: 14),
        optionGroups: [
          OptionGroup(
            'g-ksize',
            'Taille',
            OptionType.single,
            required: true,
            choices: [
              OptionChoice('c-ks', 'S'),
              OptionChoice('c-km', 'M'),
              OptionChoice('c-kl', 'L'),
              OptionChoice('c-kxl', 'XL', price: 2000),
            ],
          ),
          OptionGroup(
            'g-colour',
            'Couleur du velours',
            OptionType.colour,
            required: true,
            choices: [
              OptionChoice('c-bordeaux', 'Bordeaux', swatch: 0),
              OptionChoice('c-black', 'Noir', swatch: 1),
              OptionChoice('c-emerald', 'Vert émeraude', swatch: 2),
              OptionChoice('c-night', 'Bleu nuit', swatch: 3),
            ],
          ),
        ],
      ),
      createdAt: ago(_d(55)),
      sold: 6,
    ),
    Product(
      id: 'p-gandoura',
      storeId: 's-nour',
      category: Category.childrenClothing,
      title: 'Gandoura fillette (4–8 ans)',
      description: 'Gandoura en coton brodé, légère pour l\'été.',
      photos: 2,
      readyMade: const ReadyMade(price: 3500, stock: 3, prepTime: _m30),
      createdAt: ago(_d(10)),
      sold: 11,
    ),

    // Poterie Na Ouardia: pottery
    Product(
      id: 'p-tajine',
      storeId: 's-fekhar',
      category: Category.pottery,
      title: 'Tajine kabyle en terre cuite',
      description: 'Tajine tourné main, diamètre 30 cm, prêt à culotter.',
      readyMade: const ReadyMade(price: 2800, stock: 6),
      createdAt: ago(_d(65)),
      sold: 14,
    ),
    Product(
      id: 'p-jarre',
      storeId: 's-fekhar',
      category: Category.pottery,
      title: 'Jarre peinte à la main',
      description: 'Motifs kabyles traditionnels, hauteur 40 cm.',
      madeToOrder: const MadeToOrder(
        price: 4500,
        leadTime: Duration(days: 10),
        prepTime: Duration(days: 7),
      ),
      createdAt: ago(_d(12)),
      sold: 4,
    ),

    // Bijoux Thiziri: jewellery (store paused)
    Product(
      id: 'p-bracelet',
      storeId: 's-thiziri',
      category: Category.jewellery,
      title: 'Bracelet kabyle en argent',
      description: 'Argent massif émaillé, corail.',
      readyMade: const ReadyMade(price: 8500, stock: 3),
      createdAt: ago(_d(100)),
      sold: 7,
    ),
    Product(
      id: 'p-fibule',
      storeId: 's-thiziri',
      category: Category.jewellery,
      title: 'Fibule (tabzimt) émaillée',
      madeToOrder: const MadeToOrder(
        price: 12000,
        maxQty: 2,
        leadTime: Duration(days: 14),
        prepTime: Duration(days: 10),
      ),
      createdAt: ago(_d(100)),
      sold: 3,
    ),

    // Hlou Qacentina: Constantine sweets
    Product(
      id: 'p-baklawa-qacentina',
      storeId: 's-hlou',
      category: Category.traditionalSweets,
      title: 'Baklawa constantinoise (plateau)',
      description:
          'Baklawa aux amandes et noix de cajou, décor pistache, plateau de 24 losanges.',
      ingredients:
          "Amandes, noix de cajou, pistaches, miel, beurre, eau de fleur d'oranger",
      unit: Unit.box,
      readyMade: const ReadyMade(price: 4800, stock: 3, prepTime: _m30),
      createdAt: ago(_d(42)),
      sold: 19,
    ),
    Product(
      id: 'p-kalb-el-louz',
      storeId: 's-hlou',
      category: Category.traditionalSweets,
      title: 'Kalb el louz',
      description:
          'Semoule et amandes, sirop à la fleur d\'oranger. Le classique du Ramadan.',
      ingredients: "Semoule, amandes, sucre, beurre, eau de fleur d'oranger",
      unit: Unit.box,
      readyMade: const ReadyMade(price: 1500, stock: 8, prepTime: _m30),
      createdAt: ago(_d(28)),
      sold: 34,
    ),
    Product(
      id: 'p-assortiment',
      storeId: 's-hlou',
      category: Category.traditionalSweets,
      title: 'Assortiment de gâteaux traditionnels',
      description:
          'Mchewek, dziriettes, arayech et skandraniette, préparés pour votre fête.',
      ingredients:
          "Amandes, sucre glace, œufs, beurre, miel, eau de fleur d'oranger",
      unit: Unit.kg,
      photos: 3,
      madeToOrder: const MadeToOrder(
        price: 3600,
        minQty: 1,
        step: 0.5,
        maxQty: 15,
        leadTime: Duration(hours: 48),
        prepTime: Duration(hours: 24),
        optionGroups: [
          OptionGroup(
            'g-assort',
            'Assortiment',
            OptionType.single,
            required: true,
            choices: [
              OptionChoice('c-classic', 'Classique'),
              OptionChoice(
                'c-almond',
                'Tout amandes',
                price: 400,
                perUnit: true,
              ),
              OptionChoice(
                'c-pistachio-a',
                'Pistache',
                price: 800,
                perUnit: true,
              ),
            ],
          ),
          OptionGroup(
            'g-box',
            'Présentation',
            OptionType.multiple,
            choices: [OptionChoice('c-giftbox', 'Boîte cadeau', price: 300)],
          ),
        ],
      ),
      createdAt: ago(_d(60)),
      sold: 27,
    ),
    Product(
      id: 'p-samsa',
      storeId: 's-hlou',
      category: Category.traditionalSweets,
      title: 'Samsa aux amandes (12 pièces)',
      description:
          'Triangles de feuille de brick farcis aux amandes, miel et sésame.',
      ingredients: 'Feuilles de brick, amandes, miel, sésame, cannelle',
      unit: Unit.box,
      readyMade: const ReadyMade(price: 1400, stock: 10, prepTime: _m30),
      createdAt: ago(_d(15)),
      sold: 16,
    ),
    Product(
      id: 'p-bradj',
      storeId: 's-hlou',
      category: Category.traditionalSweets,
      title: 'Bradj aux dattes (6 pièces)',
      description:
          'Losanges de semoule fourrés à la pâte de dattes, cuits au tajine.',
      ingredients: 'Semoule, pâte de dattes, beurre, cannelle',
      unit: Unit.box,
      readyMade: const ReadyMade(price: 700, stock: 0),
      madeToOrder: const MadeToOrder(
        price: 700,
        minQty: 2,
        leadTime: Duration(hours: 24),
        prepTime: Duration(hours: 6),
      ),
      createdAt: ago(_d(9)),
      sold: 21,
    ),

    // Cuisine Khalti Zohra: Biskra dishes and breads
    Product(
      id: 'p-couscous-agneau',
      storeId: 's-zohra',
      category: Category.traditionalFood,
      title: "Couscous à l'agneau",
      description:
          "Graine roulée main, légumes et épaule d'agneau, servi au tajine.",
      ingredients:
          'Semoule, agneau, carottes, courgettes, navets, pois chiches',
      unit: Unit.portion,
      readyMade: const ReadyMade(price: 1300, stock: 4),
      createdAt: ago(_d(50)),
      sold: 38,
    ),
    Product(
      id: 'p-chakhchoukha-biskria',
      storeId: 's-zohra',
      category: Category.traditionalFood,
      title: 'Chakhchoukha biskria',
      description:
          'Galette émiettée, sauce rouge, agneau et œufs durs, comme à Biskra.',
      ingredients: 'Semoule, agneau, tomates, pois chiches, œufs, piment',
      unit: Unit.portion,
      readyMade: const ReadyMade(price: 1200, stock: 3),
      createdAt: ago(_d(33)),
      sold: 26,
    ),
    Product(
      id: 'p-bourek',
      storeId: 's-zohra',
      category: Category.traditionalFood,
      title: 'Bourek à la viande (10 pièces)',
      description:
          'Feuilles de dioul roulées, viande hachée, persil et fromage.',
      ingredients:
          'Feuilles de dioul, viande hachée, oignons, persil, fromage, œufs',
      unit: Unit.box,
      readyMade: const ReadyMade(price: 1000, stock: 6, prepTime: _m30),
      createdAt: ago(_d(20)),
      sold: 44,
    ),
    Product(
      id: 'p-baghrir',
      storeId: 's-zohra',
      category: Category.breads,
      title: 'Baghrir (10 pièces)',
      description: 'Crêpes mille trous, servies avec beurre fondu et miel.',
      ingredients: 'Semoule fine, farine, levure, beurre, miel',
      unit: Unit.box,
      freeDelivery: true,
      readyMade: const ReadyMade(price: 600, stock: 8, prepTime: _m30),
      createdAt: ago(_d(12)),
      sold: 31,
    ),
    Product(
      id: 'p-feuillete',
      storeId: 's-zohra',
      category: Category.breads,
      title: 'Feuilletés salés (12 pièces)',
      description:
          'Pâte feuilletée maison, garniture thon et olives. Idéal pour les fêtes.',
      ingredients: 'Farine, beurre, thon, olives, œufs',
      unit: Unit.box,
      madeToOrder: const MadeToOrder(
        price: 1200,
        maxQty: 10,
        leadTime: Duration(hours: 24),
        prepTime: Duration(hours: 6),
        optionGroups: [
          OptionGroup(
            'g-filling',
            'Garniture',
            OptionType.single,
            required: true,
            choices: [
              OptionChoice('c-tuna', 'Thon et olives'),
              OptionChoice('c-chicken', 'Poulet et fromage', price: 200),
            ],
          ),
        ],
      ),
      createdAt: ago(_d(7)),
      sold: 13,
    ),
    Product(
      id: 'p-kesra-zohra',
      storeId: 's-zohra',
      category: Category.breads,
      title: 'Kesra au tajine',
      description: "Galette de semoule à l'huile d'olive, cuite le matin même.",
      ingredients: "Semoule, huile d'olive, sel",
      photos: 2,
      readyMade: const ReadyMade(price: 180, stock: 20, prepTime: _m30),
      createdAt: ago(_d(45)),
      sold: 90,
    ),
    Product(
      id: 'p-msemen-zohra',
      storeId: 's-zohra',
      category: Category.breads,
      title: 'Msemen nature',
      description: 'Feuilletés carrés au beurre, cuits à la poêle.',
      ingredients: 'Semoule, farine, beurre, sel',
      readyMade: const ReadyMade(price: 70, stock: 25, prepTime: _m30),
      createdAt: ago(_d(45)),
      sold: 140,
    ),

    // Maison Lalla Zineb: traditional outfits (Pro)
    Product(
      id: 'p-karakou-algerois',
      storeId: 's-zineb',
      category: Category.traditionalClothing,
      title: 'Karakou algérois en velours',
      description:
          'Veste en velours brodée au fil d\'or (fetla), sarouel chelka en brocart.',
      photos: 4,
      madeToOrder: const MadeToOrder(
        price: 55000,
        maxQty: 1,
        leadTime: Duration(days: 30),
        prepTime: Duration(days: 21),
        optionGroups: [
          OptionGroup(
            'g-zsize',
            'Taille',
            OptionType.single,
            required: true,
            choices: [
              OptionChoice('c-zs', 'S'),
              OptionChoice('c-zm', 'M'),
              OptionChoice('c-zl', 'L'),
              OptionChoice('c-zxl', 'XL', price: 3000),
            ],
          ),
        ],
      ),
      createdAt: ago(_d(80)),
      sold: 9,
    ),
    Product(
      id: 'p-qaftan',
      storeId: 's-zineb',
      category: Category.traditionalClothing,
      title: 'Qaftan brodé',
      description: 'Qaftan long en satin, broderie dorée et ceinture assortie.',
      photos: 3,
      madeToOrder: const MadeToOrder(
        price: 38000,
        maxQty: 1,
        leadTime: Duration(days: 21),
        prepTime: Duration(days: 14),
        optionGroups: [
          OptionGroup(
            'g-qsize',
            'Taille',
            OptionType.single,
            required: true,
            choices: [
              OptionChoice('c-qs', 'S'),
              OptionChoice('c-qm', 'M'),
              OptionChoice('c-ql', 'L'),
            ],
          ),
        ],
      ),
      createdAt: ago(_d(40)),
      sold: 7,
    ),
    Product(
      id: 'p-blouza',
      storeId: 's-zineb',
      category: Category.traditionalClothing,
      title: 'Blouza oranaise',
      description:
          'Blouza en satin, plastron perlé et franges (chentouf). Taille M.',
      photos: 3,
      readyMade: const ReadyMade(price: 32000, stock: 2),
      createdAt: ago(_d(25)),
      sold: 5,
    ),
    Product(
      id: 'p-fergani',
      storeId: 's-zineb',
      category: Category.traditionalClothing,
      title: 'Jebba fergani',
      description:
          'Robe constantinoise en velours, brodée au medjboud à la main.',
      photos: 2,
      madeToOrder: const MadeToOrder(
        price: 70000,
        maxQty: 1,
        leadTime: Duration(days: 45),
        prepTime: Duration(days: 30),
      ),
      createdAt: ago(_d(90)),
      sold: 3,
    ),
    Product(
      id: 'p-chal',
      storeId: 's-zineb',
      category: Category.traditionalClothing,
      title: 'Châle brodé à franges',
      description:
          'Châle en crêpe ivoire, broderie florale et longues franges.',
      readyMade: const ReadyMade(price: 6500, stock: 4),
      createdAt: ago(_d(14)),
      sold: 12,
    ),

    // Atelier Tafsut: Kabyle clothing
    Product(
      id: 'p-djebba',
      storeId: 's-tafsut',
      category: Category.traditionalClothing,
      title: 'Robe kabyle (djebba taqbaylit)',
      description:
          'Robe kabyle avec galons zigzag, fouta et ceinture en laine.',
      photos: 2,
      readyMade: const ReadyMade(price: 12000, stock: 3),
      madeToOrder: const MadeToOrder(
        price: 12000,
        maxQty: 2,
        leadTime: Duration(days: 10),
        prepTime: Duration(days: 7),
        optionGroups: [
          OptionGroup(
            'g-dsize',
            'Taille',
            OptionType.single,
            required: true,
            choices: [
              OptionChoice('c-ds', 'S'),
              OptionChoice('c-dm', 'M'),
              OptionChoice('c-dl', 'L'),
              OptionChoice('c-dxl', 'XL', price: 1000),
            ],
          ),
        ],
      ),
      createdAt: ago(_d(48)),
      sold: 22,
    ),
    Product(
      id: 'p-burnous',
      storeId: 's-tafsut',
      category: Category.traditionalClothing,
      title: 'Burnous de mariée brodé or',
      description:
          'Burnous blanc en laine fine, broderie dorée sur toute la longueur.',
      madeToOrder: const MadeToOrder(
        price: 28000,
        maxQty: 1,
        leadTime: Duration(days: 14),
        prepTime: Duration(days: 10),
      ),
      createdAt: ago(_d(65)),
      sold: 4,
    ),
    Product(
      id: 'p-gandoura-femme',
      storeId: 's-tafsut',
      category: Category.traditionalClothing,
      title: 'Gandoura femme brodée',
      description: 'Gandoura ample en crêpe, broderie au col. Taille unique.',
      photos: 3,
      readyMade: const ReadyMade(price: 4500, stock: 6),
      createdAt: ago(_d(6)),
      sold: 15,
    ),

    // Bijoux Tin Hinan: silver jewellery (Pro)
    Product(
      id: 'p-touareg',
      storeId: 's-tinhinan',
      category: Category.jewellery,
      title: 'Parure touareg en argent',
      description:
          'Pendentif triangulaire, bracelets et bagues en argent ciselé.',
      photos: 2,
      readyMade: const ReadyMade(price: 9500, stock: 2),
      createdAt: ago(_d(70)),
      sold: 6,
    ),
    Product(
      id: 'p-amazigh',
      storeId: 's-tinhinan',
      category: Category.jewellery,
      title: 'Collier amazigh corail et ambre',
      description:
          'Grosses perles d\'ambre et de corail, pendentifs en argent.',
      photos: 2,
      readyMade: const ReadyMade(price: 14000, stock: 1),
      createdAt: ago(_d(30)),
      sold: 3,
    ),
    Product(
      id: 'p-parure-kabyle',
      storeId: 's-tinhinan',
      category: Category.jewellery,
      title: 'Parure kabyle émaillée',
      description:
          "Diadème, collier et bracelets en argent émaillé et corail, façon Ath Yenni.",
      photos: 5,
      madeToOrder: const MadeToOrder(
        price: 22000,
        maxQty: 1,
        leadTime: Duration(days: 21),
        prepTime: Duration(days: 14),
        optionGroups: [
          OptionGroup(
            'g-pieces',
            'Pièces',
            OptionType.multiple,
            choices: [
              OptionChoice('c-diadem', 'Diadème (taâssabt)', price: 9000),
              OptionChoice('c-bracelets', 'Paire de bracelets', price: 7000),
            ],
          ),
        ],
      ),
      createdAt: ago(_d(85)),
      sold: 5,
    ),
    Product(
      id: 'p-sendouk',
      storeId: 's-tinhinan',
      category: Category.jewellery,
      title: 'Sendouk, coffret à bijoux',
      description:
          'Petit coffre en métal argenté, émaux colorés et pampilles de corail.',
      readyMade: const ReadyMade(price: 16000, stock: 1),
      createdAt: ago(_d(18)),
      sold: 2,
    ),

    // Fekhara Nedroma: pottery
    Product(
      id: 'p-fakhar-kham',
      storeId: 's-nedroma',
      category: Category.pottery,
      title: 'Poterie brute à décorer (lot de 6)',
      description:
          'Pièces en terre cuite non peintes : pots, coupelles et bougeoirs.',
      unit: Unit.box,
      readyMade: const ReadyMade(price: 2400, stock: 5),
      createdAt: ago(_d(22)),
      sold: 8,
    ),
    Product(
      id: 'p-mzouaq',
      storeId: 's-nedroma',
      category: Category.pottery,
      title: 'Vase mzouaq peint main',
      description:
          'Terre cuite peinte de motifs berbères rouges et noirs, anses dorées.',
      readyMade: const ReadyMade(price: 2200, stock: 7),
      createdAt: ago(_d(36)),
      sold: 11,
    ),
    Product(
      id: 'p-sahraoui',
      storeId: 's-nedroma',
      category: Category.pottery,
      title: 'Boîte saharienne peinte',
      description: 'Boîte ronde à couvercle, décor oasis et dromadaires.',
      readyMade: const ReadyMade(price: 1800, stock: 6),
      createdAt: ago(_d(10)),
      sold: 5,
    ),
    Product(
      id: 'p-jarra',
      storeId: 's-nedroma',
      category: Category.pottery,
      title: 'Jarra en terre cuite',
      description: "Jarre à anses pour l'eau ou l'huile, hauteur 35 cm.",
      readyMade: const ReadyMade(price: 3000, stock: 4),
      createdAt: ago(_d(58)),
      sold: 9,
    ),
    Product(
      id: 'p-qolla',
      storeId: 's-nedroma',
      category: Category.pottery,
      title: 'Qolla gravée',
      description:
          "Cruche à long col, motifs géométriques gravés. Garde l'eau fraîche.",
      readyMade: const ReadyMade(price: 3800, stock: 3),
      madeToOrder: const MadeToOrder(
        price: 3800,
        leadTime: Duration(days: 10),
        prepTime: Duration(days: 7),
      ),
      createdAt: ago(_d(44)),
      sold: 7,
    ),
    Product(
      id: 'p-qraa',
      storeId: 's-nedroma',
      category: Category.pottery,
      title: 'Qraa peinte à la main',
      description:
          'Calebasse séchée et peinte, motifs berbères. Pièce décorative.',
      readyMade: const ReadyMade(price: 1500, stock: 9),
      createdAt: ago(_d(16)),
      sold: 10,
    ),
    Product(
      id: 'p-tbassi',
      storeId: 's-nedroma',
      category: Category.pottery,
      title: 'Tbassi peints (lot de 6)',
      description: 'Assiettes et bols émaillés, décor brun et blanc.',
      unit: Unit.box,
      readyMade: const ReadyMade(price: 2600, stock: 5),
      createdAt: ago(_d(27)),
      sold: 14,
    ),

    // Tissages Lalla Aïcha: rugs and basketry
    Product(
      id: 'p-hanbel',
      storeId: 's-ghardaia',
      category: Category.rugs,
      title: 'Hanbel tissé main',
      description:
          'Tapis plat en laine, motifs berbères. Tissé sur métier à Ghardaïa.',
      photos: 5,
      readyMade: const ReadyMade(price: 16000, stock: 3),
      madeToOrder: const MadeToOrder(
        price: 16000,
        maxQty: 2,
        leadTime: Duration(days: 30),
        prepTime: Duration(days: 21),
        optionGroups: [
          OptionGroup(
            'g-hsize',
            'Dimensions',
            OptionType.single,
            required: true,
            choices: [
              OptionChoice('c-h12', '1 × 2 m'),
              OptionChoice('c-h23', '2 × 3 m', price: 14000),
            ],
          ),
        ],
      ),
      createdAt: ago(_d(75)),
      sold: 12,
    ),
    Product(
      id: 'p-klim',
      storeId: 's-ghardaia',
      category: Category.rugs,
      title: 'Klim en laine',
      description: 'Kilim léger, motifs rouges et noirs, 1,2 × 1,8 m.',
      readyMade: const ReadyMade(price: 9000, stock: 2),
      createdAt: ago(_d(30)),
      sold: 6,
    ),
    Product(
      id: 'p-zerbia',
      storeId: 's-ghardaia',
      category: Category.rugs,
      title: 'Zerbia à points noués (2 × 3 m)',
      description: 'Tapis noué main en laine, médaillon central rouge.',
      readyMade: const ReadyMade(price: 42000, stock: 1),
      createdAt: ago(_d(95)),
      sold: 2,
    ),
    Product(
      id: 'p-qoffa',
      storeId: 's-ghardaia',
      category: Category.baskets,
      title: 'Qoffa en palmier tressé',
      description:
          'Panier à anses en feuilles de palmier, décor de laine colorée.',
      photos: 3,
      freeDelivery: true,
      readyMade: const ReadyMade(price: 1200, stock: 12),
      createdAt: ago(_d(20)),
      sold: 29,
    ),
    Product(
      id: 'p-tbeg',
      storeId: 's-ghardaia',
      category: Category.baskets,
      title: 'Tbeg, plateau tressé',
      description:
          'Plateau rond en alfa et laine, pour le pain ou en décoration murale.',
      photos: 2,
      readyMade: const ReadyMade(price: 1800, stock: 8),
      createdAt: ago(_d(38)),
      sold: 17,
    ),
    Product(
      id: 'p-osier',
      storeId: 's-ghardaia',
      category: Category.baskets,
      title: 'Panier en osier',
      description: 'Panier rond tressé main, pour le marché ou le rangement.',
      readyMade: const ReadyMade(price: 1500, stock: 10),
      createdAt: ago(_d(11)),
      sold: 13,
    ),
    Product(
      id: 'p-zulu',
      storeId: 's-ghardaia',
      category: Category.baskets,
      title: 'Panier à couvercle tressé',
      description: 'Grand panier ventru à couvercle, motifs géométriques.',
      readyMade: const ReadyMade(price: 3500, stock: 3),
      createdAt: ago(_d(5)),
      sold: 4,
    ),
  ];

  const yacineHome = Address(
    id: 'a-home',
    label: 'Maison',
    street: 'Cité 1200 Logements, Bât. 14',
    commune: 'Bab Ezzouar',
    wilaya: 'Alger',
  );
  const samiraHome = Address(
    id: 'a-samira',
    label: 'Maison',
    street: 'Rue des Pins',
    commune: 'Hydra',
    wilaya: 'Alger',
  );
  const karimHome = Address(
    id: 'a-karim',
    label: 'Maison',
    street: 'Chemin Poirson',
    commune: 'El Biar',
    wilaya: 'Alger',
  );
  const nadiaHome = Address(
    id: 'a-nadia',
    label: 'Maison',
    street: 'Cité Universitaire',
    commune: 'Ben Aknoun',
    wilaya: 'Alger',
  );

  final clients = [
    const Client(
      id: demoClientId,
      name: 'Yacine B.',
      phone: '0555 48 21 90',
      balance: 6200,
      addresses: [
        yacineHome,
        Address(
          id: 'a-work',
          label: 'Travail',
          street: '12 rue Didouche Mourad',
          commune: 'Alger Centre',
          wilaya: 'Alger',
        ),
      ],
    ),
    const Client(
      id: 'c-samira',
      name: 'Samira K.',
      phone: '0661 20 33 47',
      balance: 15000,
      addresses: [samiraHome],
    ),
    // Too little for her waiting order: accepting it shows "Payment failed".
    const Client(
      id: 'c-karim',
      name: 'Karim M.',
      phone: '0770 11 52 08',
      balance: 1000,
      addresses: [karimHome],
    ),
    const Client(
      id: 'c-nadia',
      name: 'Nadia H.',
      phone: '0550 93 64 12',
      balance: 9000,
      addresses: [nadiaHome],
    ),
  ];

  Order order(
    int no,
    String clientId,
    Address address,
    String productId,
    num qty,
    int itemTotal,
    List<(OrderStatus, DateTime)> steps, {
    OrderType type = OrderType.readyMade,
    List<OrderOption> options = const [],
    DateTime? deliveryDate,
  }) {
    final p = products.firstWhere((p) => p.id == productId);
    final status = steps.last.$1;
    return Order(
      id: 'KF-$no',
      clientId: clientId,
      storeId: p.storeId,
      type: type,
      lines: [
        OrderLine(
          productId: p.id,
          title: p.title,
          unit: p.unit,
          qty: qty,
          options: options,
          total: itemTotal,
        ),
      ],
      deliveryDate: deliveryDate,
      address: address,
      deliveryFee: deliveryFee(
        stores.firstWhere((s) => s.id == p.storeId).distanceKm,
      ),
      freeDelivery: p.freeDelivery,
      status: status,
      money: switch (status) {
        OrderStatus.placed => Money.inWallet,
        OrderStatus.delivered => Money.paid,
        _ => Money.held,
      },
      deadline: steps.first.$2.add(
        type == OrderType.readyMade ? _h(2) : _h(24),
      ),
      history: [for (final (s, t) in steps) OrderEvent(s, t)],
    );
  }

  List<(OrderStatus, DateTime)> deliveredAt(DateTime t) => [
    (OrderStatus.placed, t.subtract(_h(5))),
    (OrderStatus.accepted, t.subtract(const Duration(hours: 4, minutes: 30))),
    (OrderStatus.inPreparation, t.subtract(_h(4))),
    (OrderStatus.ready, t.subtract(_h(3))),
    (OrderStatus.pickedUp, t.subtract(_m30 * 3)),
    (OrderStatus.delivered, t),
  ];

  // First Tue/Thu/Sat at least 48 h away: a valid Makrout date.
  var makroutDay = DateTime(now.year, now.month, now.day + 2);
  while (!{
    DateTime.tuesday,
    DateTime.thursday,
    DateTime.saturday,
  }.contains(makroutDay.weekday)) {
    makroutDay = DateTime(
      makroutDay.year,
      makroutDay.month,
      makroutDay.day + 1,
    );
  }

  final orders = [
    order(1008, 'c-karim', karimHome, 'p-griwech', 2, 2400, [
      (OrderStatus.placed, ago(const Duration(minutes: 25))),
    ]),
    order(
      1007,
      'c-samira',
      samiraHome,
      'p-makrout',
      2,
      6000,
      [(OrderStatus.placed, ago(const Duration(minutes: 40)))],
      type: OrderType.madeToOrder,
      options: const [OrderOption('Extras', 'Glaçage au miel', 400)],
      deliveryDate: makroutDay,
    ),
    order(1006, demoClientId, yacineHome, 'p-rechta', 2, 2200, [
      (OrderStatus.placed, ago(_h(3))),
      (OrderStatus.accepted, ago(const Duration(hours: 2, minutes: 50))),
      (OrderStatus.inPreparation, ago(_h(2))),
    ]),
    order(1005, 'c-nadia', nadiaHome, 'p-tcharek', 3, 4500, [
      (OrderStatus.placed, ago(_h(5))),
      (OrderStatus.accepted, ago(const Duration(hours: 4, minutes: 40))),
    ]),
    order(
      1004,
      demoClientId,
      yacineHome,
      'p-fraisier',
      1,
      3200,
      deliveredAt(ago(_h(26))),
    ),
    order(
      1003,
      'c-samira',
      samiraHome,
      'p-baklawa',
      1,
      2400,
      deliveredAt(ago(_d(3))),
    ),
    order(
      1002,
      'c-nadia',
      nadiaHome,
      'p-makrout',
      1.5,
      4200,
      deliveredAt(ago(_d(6))),
      type: OrderType.madeToOrder,
    ),
    order(
      1001,
      'c-karim',
      karimHome,
      'p-tcharek',
      2,
      3000,
      deliveredAt(ago(_d(9))),
    ),
  ];

  final withdrawals = [
    Withdrawal(
      storeId: 's-fatma',
      amount: 4000,
      time: ago(_d(5)),
      status: WithdrawalStatus.sent,
    ),
  ];

  // Store balance = delivered earnings − withdrawals, so the Earnings screen adds up.
  int balanceOf(String storeId) =>
      orders
          .where(
            (o) => o.storeId == storeId && o.status == OrderStatus.delivered,
          )
          .fold(0, (s, o) => s + o.earnings) -
      withdrawals
          .where((w) => w.storeId == storeId)
          .fold(0, (s, w) => s + w.amount);

  Review review(
    String orderId,
    String storeId,
    String productId,
    int stars,
    String comment,
    Duration age,
  ) => Review(
    orderId: orderId,
    storeId: storeId,
    productIds: [productId],
    service: products.firstWhere((p) => p.id == productId).category.service,
    stars: stars,
    comment: comment,
    time: ago(age),
  );

  return AppState(
    stores: [for (final s in stores) s.copyWith(balance: balanceOf(s.id))],
    products: products,
    clients: clients,
    orders: orders,
    reviews: [
      review(
        'KF-1003',
        's-fatma',
        'p-baklawa',
        5,
        'بقلاوة رائعة، كأنها من صنع جدتي.',
        _d(3),
      ),
      review(
        'KF-1002',
        's-fatma',
        'p-makrout',
        4,
        'Makrout délicieux, livré à la date prévue.',
        _d(6),
      ),
      review(
        'KF-1001',
        's-fatma',
        'p-tcharek',
        5,
        'Tcharek très frais, bien emballé.',
        _d(9),
      ),
      review(
        'KF-0950',
        's-amina',
        'p-fraisier',
        5,
        "Le fraisier était parfait pour l'anniversaire.",
        _d(14),
      ),
      review(
        'KF-0921',
        's-amina',
        'p-wedding',
        4,
        'Très beau gâteau, un peu trop sucré à mon goût.',
        _d(30),
      ),
      review(
        'KF-0940',
        's-yemma',
        'p-couscous',
        5,
        'Couscous comme à la maison.',
        _d(18),
      ),
      review(
        'KF-0902',
        's-yemma',
        'p-rechta',
        3,
        'Bon mais livré un peu tard.',
        _d(40),
      ),
      review(
        'KF-0911',
        's-nour',
        'p-karakou',
        5,
        'Karakou magnifique, broderie très fine.',
        _d(35),
      ),
      review(
        'KF-0930',
        's-fekhar',
        'p-tajine',
        4,
        'Tajine solide, belle finition.',
        _d(22),
      ),
      review(
        'KF-0955',
        's-hlou',
        'p-assortiment',
        5,
        'Plateau magnifique, tout le monde a adoré.',
        _d(12),
      ),
      review(
        'KF-0948',
        's-zohra',
        'p-bourek',
        5,
        'Bourek croustillant et bien garni.',
        _d(16),
      ),
      review(
        'KF-0915',
        's-zineb',
        'p-karakou-algerois',
        5,
        'Karakou sublime, finitions parfaites.',
        _d(33),
      ),
      review(
        'KF-0944',
        's-tafsut',
        'p-djebba',
        4,
        'Belle robe, elle taille un peu grand.',
        _d(19),
      ),
      review(
        'KF-0925',
        's-tinhinan',
        'p-touareg',
        5,
        'Argent de qualité, très bien emballé.',
        _d(28),
      ),
      review(
        'KF-0938',
        's-nedroma',
        'p-qolla',
        4,
        'Très jolie qolla, livraison un peu longue.',
        _d(21),
      ),
      review(
        'KF-0952',
        's-ghardaia',
        'p-qoffa',
        5,
        'Couffin solide et très joli.',
        _d(13),
      ),
    ],
    strikes: [
      Strike(
        storeId: 's-fatma',
        orderId: 'KF-0897',
        reason: 'Commande annulée : ingrédients manquants',
        time: ago(_d(20)),
      ),
    ],
    withdrawals: withdrawals,
    notifications: [
      for (final o in orders.where((o) => o.status == OrderStatus.placed))
        AppNotification(
          app: AppSide.store,
          to: o.storeId,
          kind: NoticeKind.order,
          status: o.status,
          orderId: o.id,
          time: o.placedAt,
        ),
      AppNotification(
        app: AppSide.client,
        to: demoClientId,
        kind: NoticeKind.order,
        status: OrderStatus.inPreparation,
        orderId: 'KF-1006',
        time: ago(_h(2)),
        read: true,
      ),
    ],
    nextOrderNo: 1009,
  );
}
