// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'Kavza';

  @override
  String get byYassir => 'by Yassir';

  @override
  String get currency => 'DA';

  @override
  String get launcherTitle => 'Prototype';

  @override
  String get launcherSubtitle =>
      'Choisissez quoi présenter. Les deux apps partagent les mêmes données.';

  @override
  String get clientApp => 'App client';

  @override
  String get clientAppHint => 'Kavza dans l\'app Yassir';

  @override
  String get storeApp => 'App Kavza Store';

  @override
  String get storeAppHint => 'L\'app des vendeuses';

  @override
  String get sideBySide => 'Côte à côte';

  @override
  String get sideBySideHint => 'Client et boutique sur un même écran';

  @override
  String get language => 'Langue';

  @override
  String get langAr => 'العربية';

  @override
  String get langFr => 'Français';

  @override
  String get backToLauncher => 'Retour au lanceur';

  @override
  String get cancel => 'Annuler';

  @override
  String get statusPlaced => 'Passée';

  @override
  String get statusAccepted => 'Acceptée';

  @override
  String get statusInPreparation => 'En préparation';

  @override
  String get statusReady => 'Prête';

  @override
  String get statusPickedUp => 'Récupérée par le livreur';

  @override
  String get statusDelivered => 'Livrée';

  @override
  String get statusCancelledByClient => 'Annulée par le client';

  @override
  String get statusDeclined => 'Refusée';

  @override
  String get statusExpired => 'Expirée';

  @override
  String get statusPaymentFailed => 'Paiement échoué';

  @override
  String get statusCancelledAfterAcceptance => 'Annulée après acceptation';

  @override
  String get statusDeliveryFailed => 'Échec de livraison';

  @override
  String get statusDisputed => 'En litige';

  @override
  String get demoPanel => 'Panneau démo';

  @override
  String get demoPanelHint =>
      'Remplace le back-office et Yassir Express pendant la démo.';

  @override
  String get demoClock => 'Horloge';

  @override
  String demoClockNow(String time) {
    return 'Heure simulée : $time';
  }

  @override
  String get demoAdd15m => '+15 min';

  @override
  String get demoAdd1h => '+1 h';

  @override
  String get demoAdd24h => '+24 h';

  @override
  String get demoCourier => 'Événements livreur';

  @override
  String get demoCourierEmpty =>
      'Aucune commande n\'attend le livreur. Marquez-en une « Prête » dans l\'app boutique.';

  @override
  String get demoStoreReview => 'Validation des boutiques';

  @override
  String get demoStoreReviewEmpty =>
      'Aucune boutique en attente de validation.';

  @override
  String get demoApprove => 'Approuver';

  @override
  String get demoReject => 'Refuser';

  @override
  String get demoBalance => 'Solde Yassir Cash du client';

  @override
  String demoBalanceNow(String name, String amount) {
    return '$name · solde actuel $amount';
  }

  @override
  String get demoBalanceField => 'Nouveau solde';

  @override
  String get demoBalanceSet => 'Appliquer';

  @override
  String get demoReset => 'Réinitialiser les données';

  @override
  String get demoResetHint => 'Remet les données de démo et l\'horloge à zéro.';

  @override
  String get demoResetConfirm => 'Tout réinitialiser ?';

  @override
  String get demoResetBody =>
      'Les commandes et changements faits pendant la démo seront effacés.';

  @override
  String yassirHello(String name) {
    return 'Bienvenue, $name';
  }

  @override
  String get yassirCash => 'Yassir Cash';

  @override
  String get yassirWhatToday => 'Que pouvons-nous faire pour vous ?';

  @override
  String get yassirRide => 'Courses';

  @override
  String get yassirFood => 'Restaurants';

  @override
  String get yassirMarket => 'Supermarchés';

  @override
  String get yassirNotInDemo => 'Ce service ne fait pas partie de la démo.';

  @override
  String get yassirLocation => 'Position actuelle';

  @override
  String get yassirParcel => 'Colis';

  @override
  String get yassirSend => 'Envoyer';

  @override
  String get yassirTopUp => 'Recharger';

  @override
  String get deliverToLabel => 'Livrer à';

  @override
  String get kafza => 'Kavza';

  @override
  String get kafzaTileHint => 'Le fait maison, près de chez vous';

  @override
  String get badgeNew => 'Nouveau';

  @override
  String get badgePro => 'Pro';

  @override
  String get backToYassir => 'Retour à Yassir';

  @override
  String get notifications => 'Notifications';

  @override
  String get help => 'Aide';

  @override
  String get tabHome => 'Accueil';

  @override
  String get tabSearch => 'Recherche';

  @override
  String get tabOrders => 'Commandes';

  @override
  String get tabFavourites => 'Favoris';

  @override
  String get chooseAddress => 'Adresse de livraison';

  @override
  String get searchHint => 'Un produit, une boutique';

  @override
  String waitingBanner(String time) {
    return 'En attente de la boutique · encore $time';
  }

  @override
  String get servicesTitle => 'Services';

  @override
  String get categoriesTitle => 'Catégories';

  @override
  String get nearbyStores => 'Boutiques près de chez vous';

  @override
  String get newProducts => 'Nouveautés';

  @override
  String get popularProducts => 'Les plus commandés';

  @override
  String get serviceCooking => 'Cuisine';

  @override
  String get serviceSewing => 'Couture';

  @override
  String get serviceCrafts => 'Artisanat';

  @override
  String get categoryTraditionalFood => 'Plats traditionnels';

  @override
  String get categoryTraditionalSweets => 'Gâteaux traditionnels';

  @override
  String get categoryCakes => 'Gâteaux et pâtisserie';

  @override
  String get categoryBreads => 'Pains et galettes';

  @override
  String get categoryTraditionalClothing => 'Tenues traditionnelles';

  @override
  String get categoryChildrenClothing => 'Vêtements enfants';

  @override
  String get categoryPottery => 'Poterie';

  @override
  String get categoryRugs => 'Tapis';

  @override
  String get categoryBaskets => 'Vannerie';

  @override
  String get categoryJewellery => 'Bijoux';

  @override
  String get unitPiece => 'pièce';

  @override
  String get unitKg => 'kg';

  @override
  String get unitBox => 'boîte';

  @override
  String get unitPortion => 'portion';

  @override
  String qtyPiece(num n) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$nString pièces',
      one: '1 pièce',
    );
    return '$_temp0';
  }

  @override
  String qtyKg(num n) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    return '$nString kg';
  }

  @override
  String qtyBox(num n) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$nString boîtes',
      one: '1 boîte',
    );
    return '$_temp0';
  }

  @override
  String qtyPortion(num n) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$nString portions',
      one: '1 portion',
    );
    return '$_temp0';
  }

  @override
  String pricePerUnit(String price, String unit) {
    return '$price / $unit';
  }

  @override
  String communeDistance(String commune, String km) {
    return '$commune · ≈ $km km';
  }

  @override
  String storeDistance(String store, String km) {
    return '$store · ≈ $km km';
  }

  @override
  String get notTakingOrders => 'Ne prend pas de commandes en ce moment';

  @override
  String get currentlyUnavailable => 'Actuellement indisponible';

  @override
  String get fewLeft => 'Plus que quelques-uns';

  @override
  String get freeDelivery => 'Livraison offerte';

  @override
  String get ingredients => 'Ingrédients';

  @override
  String get readyMadeTitle => 'Déjà prêt';

  @override
  String get madeToOrderTitle => 'Sur commande';

  @override
  String inStock(String qty) {
    return 'En stock : $qty';
  }

  @override
  String get outOfStock => 'Rupture de stock';

  @override
  String readyIn(String time) {
    return 'Prêt en $time';
  }

  @override
  String preparedIn(String time) {
    return 'Préparation : $time';
  }

  @override
  String ruleMin(String qty) {
    return 'Min $qty';
  }

  @override
  String ruleStep(String qty) {
    return 'par $qty';
  }

  @override
  String ruleMax(String qty) {
    return 'max $qty';
  }

  @override
  String ruleLead(String time) {
    return 'Commander $time à l\'avance';
  }

  @override
  String ruleDays(String days) {
    return 'Livré le $days';
  }

  @override
  String get ruleEveryDay => 'Livré tous les jours';

  @override
  String ruleOptions(String groups) {
    return 'Choix : $groups';
  }

  @override
  String get listSeparator => ', ';

  @override
  String photoOf(int index, int total) {
    return 'Photo $index sur $total';
  }

  @override
  String ratingSemantics(String average, int count) {
    return 'Note $average sur 5, $count avis';
  }

  @override
  String starsSemantics(int stars) {
    return '$stars étoiles sur 5';
  }

  @override
  String durationMinutes(int m) {
    return '$m min';
  }

  @override
  String durationHours(int h) {
    return '$h h';
  }

  @override
  String durationHoursMinutes(int h, int m) {
    return '$h h $m min';
  }

  @override
  String durationDays(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n jours',
      one: '1 jour',
    );
    return '$_temp0';
  }

  @override
  String get orderNow => 'Commander maintenant';

  @override
  String get orderMadeForMe => 'Commander sur mesure';

  @override
  String get outOfStockHint =>
      'Rupture de stock, et ce produit ne se fait pas sur commande.';

  @override
  String get productPausedHint => 'La boutique a mis ce produit en pause.';

  @override
  String get share => 'Partager';

  @override
  String get linkCopied => 'Lien copié';

  @override
  String get addFavourite => 'Ajouter aux favoris';

  @override
  String get removeFavourite => 'Retirer des favoris';

  @override
  String reliability(String percent) {
    return '$percent des commandes livrées';
  }

  @override
  String serviceRating(String service, String stars) {
    return '$service : $stars/5';
  }

  @override
  String get pausedStoreHint => 'Ses produits réapparaîtront dès sa reprise.';

  @override
  String get noProducts => 'Aucun produit pour l\'instant';

  @override
  String get noProductsHint => 'Revenez bientôt pour voir les nouveautés.';

  @override
  String get noReviews => 'Pas encore d\'avis';

  @override
  String get noReviewsHint =>
      'Les avis apparaissent après les premières livraisons.';

  @override
  String tabProductsCount(int n) {
    return 'Produits ($n)';
  }

  @override
  String tabStoresCount(int n) {
    return 'Boutiques ($n)';
  }

  @override
  String tabReviewsCount(int n) {
    return 'Avis ($n)';
  }

  @override
  String get noResults => 'Aucun résultat';

  @override
  String get noResultsHint => 'Essayez un autre mot ou retirez des filtres.';

  @override
  String get clearFilters => 'Retirer les filtres';

  @override
  String get clearSearch => 'Effacer la recherche';

  @override
  String get removeFilter => 'Retirer';

  @override
  String get recentSearches => 'Recherches récentes';

  @override
  String get clear => 'Effacer';

  @override
  String get filters => 'Filtres';

  @override
  String get sortBy => 'Trier par';

  @override
  String get sortClosest => 'Les plus proches';

  @override
  String get sortRating => 'Les mieux notés';

  @override
  String get sortPrice => 'Prix croissant';

  @override
  String get sortPrepTime => 'Préparation la plus rapide';

  @override
  String get filterWilaya => 'Wilaya';

  @override
  String get all => 'Toutes';

  @override
  String get filterAvailability => 'Disponibilité';

  @override
  String get filterAvailableNow => 'Disponible maintenant';

  @override
  String get filterMadeToOrder => 'Sur commande';

  @override
  String get filterMinRating => 'Note minimale';

  @override
  String get filterPrice => 'Prix';

  @override
  String priceRange(String min, String max) {
    return '$min – $max';
  }

  @override
  String get reset => 'Réinitialiser';

  @override
  String get showResults => 'Afficher les résultats';

  @override
  String get emptyFavourites => 'Aucun favori pour l\'instant';

  @override
  String get emptyFavouritesHint =>
      'Touchez le cœur d\'un produit ou d\'une boutique pour le retrouver ici.';

  @override
  String get browse => 'Découvrir Kavza';

  @override
  String labelValue(String label, String value) {
    return '$label : $value';
  }

  @override
  String get decrease => 'Diminuer';

  @override
  String get increase => 'Augmenter';

  @override
  String get contactPhone => 'Les numéros de téléphone ne sont pas autorisés.';

  @override
  String get contactEmail => 'Les adresses e-mail ne sont pas autorisées.';

  @override
  String get contactLink => 'Les liens ne sont pas autorisés.';

  @override
  String get contactHandle => 'Les identifiants (@) ne sont pas autorisés.';

  @override
  String get contactWord =>
      'Les mentions de WhatsApp, Instagram ou d\'autres applis ne sont pas autorisées.';

  @override
  String get contactWhy => 'Pour votre sécurité, tout passe par Kavza.';

  @override
  String get errorUnavailable =>
      'Ce produit ne peut pas être commandé pour le moment.';

  @override
  String get errorWaitingOrder => 'Vous avez déjà une commande en attente.';

  @override
  String get errorOutOfStock => 'Stock insuffisant. Modifiez la quantité.';

  @override
  String get errorInvalidQty => 'Cette quantité n\'est pas autorisée.';

  @override
  String get errorMissingOption => 'Choisissez les options obligatoires.';

  @override
  String get errorInvalidOption => 'Une des options n\'est plus disponible.';

  @override
  String get errorInvalidDate =>
      'Cette date n\'est plus disponible. Choisissez-en une autre.';

  @override
  String get errorLowBalance => 'Votre solde Yassir Cash est insuffisant.';

  @override
  String get errorNotAllowed => 'Cette action n\'est plus possible.';

  @override
  String timeLeft(String time) {
    return '$time restantes';
  }

  @override
  String get optionsLine => 'Options';

  @override
  String get deliveryFeeLine => 'Frais de livraison';

  @override
  String get totalLine => 'Total';

  @override
  String itemsLine(String qty, String price) {
    return '$qty × $price';
  }

  @override
  String get itemsTotal => 'Articles';

  @override
  String get quantity => 'Quantité';

  @override
  String get required => 'obligatoire';

  @override
  String get optional => 'facultatif';

  @override
  String get deliveryDate => 'Date de livraison';

  @override
  String get chooseDate => 'Choisir une date';

  @override
  String etaReadyMade(String time) {
    return 'Livré environ $time après l\'acceptation de la boutique.';
  }

  @override
  String get etaMadeToOrder => 'Livré à la date choisie.';

  @override
  String toContinue(String items) {
    return 'Pour continuer, choisissez : $items';
  }

  @override
  String continueTotal(String total) {
    return 'Continuer · $total';
  }

  @override
  String get summaryTitle => 'Récapitulatif';

  @override
  String get summaryMoneyNote =>
      'Rien n\'est prélevé maintenant. Le montant est prélevé sur votre Yassir Cash quand la boutique accepte.';

  @override
  String get placeOrder => 'Passer la commande';

  @override
  String missingAmount(String amount) {
    return 'Il manque $amount';
  }

  @override
  String get rechargeCcp => 'Recharger avec CCP';

  @override
  String get waitingTitle => 'Vous avez une commande en attente';

  @override
  String get waitingBody =>
      'Une seule commande peut attendre la réponse d\'une boutique à la fois.';

  @override
  String get keepIt => 'La garder';

  @override
  String get cancelAndPlace => 'Annuler et passer celle-ci';

  @override
  String get rechargeAmount => 'Montant de la recharge';

  @override
  String get rechargeMockNote =>
      'Page Yassir fictive : aucun paiement réel n\'est effectué.';

  @override
  String rechargeConfirm(String amount) {
    return 'Recharger $amount';
  }

  @override
  String rechargeDone(String amount) {
    return '$amount ajoutés';
  }

  @override
  String newBalance(String amount) {
    return 'Nouveau solde : $amount';
  }

  @override
  String get backToOrder => 'Retour à la commande';

  @override
  String get placedTitle => 'Commande passée';

  @override
  String orderNumber(String id) {
    return 'Commande $id';
  }

  @override
  String placedDeadline(String store, String window, String time) {
    return '$store a $window pour répondre (jusqu\'à $time).';
  }

  @override
  String get placedMoneyNote =>
      'Rien n\'est prélevé pour l\'instant. Le montant sera prélevé sur votre Yassir Cash quand la boutique acceptera. Si votre solde est insuffisant à ce moment-là, la commande sera annulée.';

  @override
  String get trackOrder => 'Suivre la commande';

  @override
  String get backToKafza => 'Retour à Kavza';

  @override
  String moneyInWallet(String total) {
    return '$total toujours dans votre Yassir Cash. Prélevé quand la boutique accepte.';
  }

  @override
  String get moneyNothingTaken =>
      'Rien n\'a été prélevé sur votre Yassir Cash.';

  @override
  String moneyHeld(String total) {
    return 'Payé $total, conservé par Kavza jusqu\'à la livraison.';
  }

  @override
  String moneyPaid(String total) {
    return 'Payé $total.';
  }

  @override
  String moneyRefunded(String amount) {
    return '$amount remboursés sur votre Yassir Cash.';
  }

  @override
  String moneyUnderReview(String total) {
    return 'Payé $total, en cours d\'examen par Kavza.';
  }

  @override
  String ordersCurrent(int n) {
    return 'En cours ($n)';
  }

  @override
  String ordersPast(int n) {
    return 'Passées ($n)';
  }

  @override
  String get noCurrentOrders => 'Aucune commande en cours';

  @override
  String get noPastOrders => 'Aucune commande passée';

  @override
  String get noOrdersHint => 'Vos commandes apparaissent ici une fois passées.';

  @override
  String waitingForStore(String time) {
    return 'En attente de la boutique jusqu\'à $time. Rien n\'est prélevé pour l\'instant.';
  }

  @override
  String get cancelOrder => 'Annuler la commande';

  @override
  String get cancelOrderTitle => 'Annuler cette commande ?';

  @override
  String get cancelOrderBody =>
      'Rien n\'a été prélevé sur votre Yassir Cash. La boutique sera prévenue.';

  @override
  String get orderCancelled => 'Commande annulée.';

  @override
  String get courierTitle => 'Le livreur Yassir Express est en route';

  @override
  String courierBody(String label) {
    return 'Il livre votre commande à : $label.';
  }

  @override
  String get orderStatusTitle => 'Suivi';

  @override
  String get orderDetailsTitle => 'Détails';

  @override
  String deliveryOn(String date) {
    return 'Livraison le $date';
  }

  @override
  String get yourReview => 'Votre avis';

  @override
  String get leaveReview => 'Laisser un avis';

  @override
  String get reviewComment => 'Commentaire (facultatif)';

  @override
  String get sendReview => 'Envoyer l\'avis';

  @override
  String get reviewThanks => 'Merci pour votre avis.';

  @override
  String get reportProblem => 'Signaler un problème';

  @override
  String reportUntil(String time) {
    return 'Vous pouvez signaler jusqu\'au $time.';
  }

  @override
  String get problemReason => 'Quel est le problème ?';

  @override
  String get problemDamaged => 'Produit abîmé';

  @override
  String get problemWrongItem => 'Mauvais produit';

  @override
  String get problemMissingItems => 'Il manque une partie de la commande';

  @override
  String get problemNotAsDescribed => 'Pas conforme à la description';

  @override
  String get problemOther => 'Autre problème';

  @override
  String get problemDetails => 'Décrivez le problème';

  @override
  String get problemPhotos => 'Photos (non disponibles dans le prototype)';

  @override
  String get sendReport => 'Envoyer le signalement';

  @override
  String get problemSent => 'Signalement envoyé. Kavza va l\'examiner.';

  @override
  String get faqTitle => 'Questions fréquentes';

  @override
  String get faqPaymentQ => 'Quand suis-je débité ?';

  @override
  String get faqPaymentA =>
      'Rien au moment de commander. Le montant total est prélevé sur votre Yassir Cash quand la boutique accepte, puis conservé par Kavza jusqu\'à la livraison. Si votre solde est insuffisant à ce moment-là, la commande est annulée sans rien prélever.';

  @override
  String get faqCancelQ => 'Puis-je annuler une commande ?';

  @override
  String get faqCancelA =>
      'Oui, tant que la boutique ne l\'a pas acceptée. Si la boutique annule après acceptation, vous êtes remboursé intégralement sur votre Yassir Cash.';

  @override
  String get faqDeliveryQ => 'Qui livre ma commande ?';

  @override
  String get faqDeliveryA =>
      'Un livreur Yassir Express la récupère quand elle est prête et la livre à votre adresse. Suivez-la dans « Mes commandes ».';

  @override
  String get faqMessageQ => 'Pourquoi ne puis-je pas écrire à la boutique ?';

  @override
  String get faqMessageA =>
      'Pour protéger tout le monde, tout passe par Kavza : paiement, livraison et aide. C\'est pourquoi les numéros, liens et identifiants sont bloqués dans tous les textes. En cas de problème, contactez le support Kavza.';

  @override
  String get contactSupport => 'Contacter le support Kavza';

  @override
  String get contactSupportHint => 'L\'équipe répond sous 24 h.';

  @override
  String get supportAbout => 'Sujet';

  @override
  String get supportNoOrder => 'Pas lié à une commande';

  @override
  String get supportMessage => 'Votre message';

  @override
  String get supportSend => 'Envoyer';

  @override
  String get supportSent => 'Message envoyé. Le support répond sous 24 h.';

  @override
  String get photoTaken => 'Photo prise';

  @override
  String get cameraCardHint => 'Placez la carte dans le cadre';

  @override
  String get cameraFaceHint => 'Placez votre visage dans l\'ovale';

  @override
  String get retake => 'Reprendre';

  @override
  String get takePhoto => 'Prendre la photo';

  @override
  String get proTitle => 'Kavza Pro';

  @override
  String get proBody =>
      'Avec le plan gratuit, vous vendez dans une seule catégorie. Avec Pro, dans toutes.';

  @override
  String get planFree => 'Gratuit';

  @override
  String get planFreePrice => '0';

  @override
  String get planFreeLine => '1 catégorie';

  @override
  String perMonth(String price) {
    return '$price / mois';
  }

  @override
  String get planProLine1 => 'Toutes les catégories';

  @override
  String get planProLine2 => 'Badge Pro sur votre boutique';

  @override
  String get proActive => 'Kavza Pro est actif sur votre boutique.';

  @override
  String proShort(String balance) {
    return 'Pro est payé depuis vos gains. Votre solde ($balance) ne suffit pas encore.';
  }

  @override
  String proFromBalance(String balance) {
    return 'Prélevé sur votre solde de gains ($balance).';
  }

  @override
  String get getPro => 'Passer à Kavza Pro';

  @override
  String get welcomeTitle => 'Vendez ce que vous faites à la maison';

  @override
  String get welcomeBody =>
      'Recevez les commandes des clients Yassir. Kavza s\'occupe du paiement et de la livraison.';

  @override
  String get getStarted => 'Commencer';

  @override
  String get haveStore => 'J\'ai déjà une boutique';

  @override
  String get stepPhone => 'Téléphone';

  @override
  String get stepCode => 'Code';

  @override
  String get stepCard => 'Carte';

  @override
  String get stepSelfie => 'Selfie';

  @override
  String stepOf(int n, int total, String label) {
    return 'Étape $n sur $total : $label';
  }

  @override
  String get phoneTitle => 'Votre numéro de téléphone';

  @override
  String get phoneBody => 'Nous vous envoyons un code à 6 chiffres par SMS.';

  @override
  String get phoneLabel => 'Numéro de mobile';

  @override
  String get phoneHelper => 'Jamais montré aux clients.';

  @override
  String get phoneInvalid =>
      'Entrez un numéro de mobile : 5, 6 ou 7 puis 8 chiffres.';

  @override
  String get sendCode => 'Recevoir le code';

  @override
  String get otpTitle => 'Entrez le code';

  @override
  String otpBody(String phone) {
    return 'Envoyé au $phone.';
  }

  @override
  String otpDemo(String code) {
    return 'Dans le prototype, le code est toujours $code.';
  }

  @override
  String get otpLabel => 'Code de vérification à 6 chiffres';

  @override
  String get otpWrong => 'Code incorrect. Vérifiez le SMS et réessayez.';

  @override
  String resendIn(String time) {
    return 'Renvoyer le code dans $time';
  }

  @override
  String get resendCode => 'Renvoyer le code';

  @override
  String get codeSent => 'Nouveau code envoyé.';

  @override
  String get newStoreName => 'Ma boutique';

  @override
  String get cardFrontTitle => 'Carte d\'auto-entrepreneur : recto';

  @override
  String get cardBackTitle => 'Carte d\'auto-entrepreneur : verso';

  @override
  String get cardPhotoBody =>
      'Photographiez la carte originale maintenant. Vérifiez que le texte est lisible.';

  @override
  String get cardDetailsTitle => 'Numéro de carte et activité';

  @override
  String get cardDetailsBody =>
      'Tels qu\'inscrits sur votre carte d\'auto-entrepreneur.';

  @override
  String get cardNumber => 'Numéro de carte';

  @override
  String get cardNumberHelper =>
      'Vu uniquement par Kavza, pour la vérification.';

  @override
  String get cardNumberInvalid => 'Numéro trop court : 8 chiffres minimum.';

  @override
  String get activity => 'Votre activité';

  @override
  String get selfieTitle => 'Selfie en direct';

  @override
  String get selfieBody =>
      'Nous la comparons à la photo de la carte. Les photos de la galerie ne sont pas acceptées.';

  @override
  String get sendForReview => 'Envoyer pour vérification';

  @override
  String get continueLabel => 'Continuer';

  @override
  String get pendingTitle => 'Nous vérifions vos documents';

  @override
  String get pendingBody =>
      'La vérification prend en général moins de 24 h. Vous serez prévenue ici.';

  @override
  String get pendingCanDo => 'Dès maintenant';

  @override
  String get pendingCanProfile =>
      'Préparer votre boutique : nom, description, photo';

  @override
  String get pendingCanProducts =>
      'Créer vos produits, enregistrés en brouillon';

  @override
  String get pendingLocked => 'Après validation';

  @override
  String get pendingLockedPublish => 'Publier vos produits';

  @override
  String get pendingLockedOrders => 'Recevoir des commandes';

  @override
  String get rejectedTitle => 'Nous n\'avons pas pu valider votre boutique';

  @override
  String get rejectedBody =>
      'Reprenez les photos de votre carte et un nouveau selfie, puis renvoyez-les.';

  @override
  String get rejectedReason =>
      'Motif : la photo de la carte n\'est pas lisible.';

  @override
  String get resubmit => 'Renvoyer';

  @override
  String get addProduct => 'Ajouter un produit';

  @override
  String get setUpStore => 'Préparer ma boutique';

  @override
  String get profileSaved => 'Profil de la boutique enregistré.';

  @override
  String get pauseTitle => 'Mettre votre boutique en pause ?';

  @override
  String get pauseBody =>
      'Les clients ne verront plus vos produits et vous ne recevrez plus de commandes. Les commandes acceptées continuent normalement.';

  @override
  String get pauseConfirm => 'Mettre en pause';

  @override
  String get storePaused => 'Votre boutique est en pause.';

  @override
  String get storeResumed => 'Votre boutique reprend les commandes.';

  @override
  String get storeProfile => 'Profil de la boutique';

  @override
  String get storePicture => 'Image de la boutique';

  @override
  String get picturePhoto => 'Photo';

  @override
  String get pictureLogo => 'Logo';

  @override
  String get pictureNone => 'Aucune';

  @override
  String get storeName => 'Nom de la boutique';

  @override
  String get storeDescription => 'Description';

  @override
  String get storeDescriptionHelper =>
      'Ce que vous faites et ce qui le rend unique. Sans numéro ni lien.';

  @override
  String get storeLocation => 'Localisation';

  @override
  String get wilaya => 'Wilaya';

  @override
  String get commune => 'Commune';

  @override
  String get communeHelper =>
      'Les clients voient seulement la commune et une distance approximative.';

  @override
  String get pickupTitle => 'Point de retrait';

  @override
  String get pickupBody =>
      'Le livreur Yassir Express récupère vos commandes ici. Déplacez l\'épingle sur votre porte.';

  @override
  String get pickupMapSemantics =>
      'Carte du point de retrait. Touchez ou glissez pour déplacer l\'épingle.';

  @override
  String get neverShownToClients => 'Jamais montré aux clients.';

  @override
  String get payoutTitle => 'Compte pour vos gains';

  @override
  String get ccpLabel => 'Compte CCP / BaridiMob (numéro + clé)';

  @override
  String get ccpHelper =>
      'Vos gains sont versés sur ce compte. Seule Kavza le voit.';

  @override
  String get ccpInvalid => 'Entre 10 et 20 chiffres.';

  @override
  String get pauseStore => 'Mettre ma boutique en pause';

  @override
  String get pauseStoreHint =>
      'Vos produits disparaissent de Kavza jusqu\'à la reprise.';

  @override
  String get save => 'Enregistrer';

  @override
  String get productsPendingBanner =>
      'Votre boutique est en vérification. Les nouveaux produits restent en brouillon jusqu\'à la validation.';

  @override
  String get productsPausedBanner =>
      'Votre boutique est en pause : les clients ne voient pas vos produits.';

  @override
  String get tabProducts => 'Produits';

  @override
  String get tabEarnings => 'Gains';

  @override
  String get tabMore => 'Plus';

  @override
  String get noStoreProducts => 'Aucun produit pour l\'instant';

  @override
  String get noStoreProductsHint =>
      'Ajoutez votre premier produit : prêt à vendre, sur commande, ou les deux.';

  @override
  String get productLive => 'En ligne';

  @override
  String get productPaused => 'En pause';

  @override
  String get productDraft => 'Brouillon';

  @override
  String lowStock(int n) {
    return 'Stock bas · $n';
  }

  @override
  String stockCount(int n) {
    return 'Stock : $n';
  }

  @override
  String get productPausedDone =>
      'Produit en pause. Les clients ne le voient plus.';

  @override
  String get productLiveDone => 'Produit de nouveau en ligne.';

  @override
  String get publishLocked =>
      'Vous pourrez publier quand Kavza aura validé votre boutique.';

  @override
  String get untitledProduct => 'Produit sans titre';

  @override
  String get productActions => 'Actions du produit';

  @override
  String get edit => 'Modifier';

  @override
  String get pause => 'Mettre en pause';

  @override
  String get resume => 'Remettre en ligne';

  @override
  String get editStock => 'Modifier le stock';

  @override
  String get delete => 'Supprimer';

  @override
  String get deleteTitle => 'Supprimer ce produit ?';

  @override
  String get deleteBody =>
      'Il disparaît de votre boutique. Les anciennes commandes restent dans l\'historique.';

  @override
  String get deleteBlockedTitle =>
      'Impossible de supprimer ce produit pour l\'instant';

  @override
  String get deleteBlockedBody =>
      'Une commande pour ce produit est en cours. Mettez-le en pause, puis supprimez-le une fois la commande terminée.';

  @override
  String get ok => 'OK';

  @override
  String get productDeleted => 'Produit supprimé.';

  @override
  String stockReserved(String qty) {
    return 'Réservé pour des commandes en attente : $qty.';
  }

  @override
  String stockAlertAt(String qty) {
    return 'Alerte stock bas à $qty.';
  }

  @override
  String get stockSaved => 'Stock mis à jour.';

  @override
  String get draftSaved => 'Brouillon enregistré.';

  @override
  String draftSavedAt(String time) {
    return 'Brouillon enregistré à $time';
  }

  @override
  String get publishedDone => 'Publié. Les clients le voient dès maintenant.';

  @override
  String get changesSaved => 'Modifications enregistrées.';

  @override
  String get editorCategory => 'Catégorie';

  @override
  String get editorDetails => 'Photos et détails';

  @override
  String get editorModes => 'Modes de vente';

  @override
  String get editorRules => 'Règles sur commande';

  @override
  String get editorOptions => 'Options';

  @override
  String get editorPreview => 'Aperçu';

  @override
  String get newProduct => 'Nouveau produit';

  @override
  String get editProduct => 'Modifier le produit';

  @override
  String get closeEditor => 'Fermer et garder le brouillon';

  @override
  String get previewHint => 'Voici ce que les clients verront.';

  @override
  String get next => 'Suivant';

  @override
  String get saveChanges => 'Enregistrer les modifications';

  @override
  String get publish => 'Publier';

  @override
  String get saveDraft => 'Enregistrer en brouillon';

  @override
  String freePlanCategory(String category) {
    return 'Plan gratuit : vous vendez dans « $category ». Kavza Pro débloque toutes les catégories.';
  }

  @override
  String get chooseCategory => 'Choisissez une catégorie.';

  @override
  String get photos => 'Photos';

  @override
  String get removePhoto => 'Retirer la photo';

  @override
  String get addPhoto => 'Ajouter une photo';

  @override
  String get addPhotoShort => 'Ajouter';

  @override
  String get photosRequired => 'Ajoutez au moins une photo.';

  @override
  String get productTitle => 'Titre';

  @override
  String get titleRequired => 'Ajoutez un titre.';

  @override
  String get nameRequired => 'Ajoutez un nom.';

  @override
  String get productDescription => 'Description';

  @override
  String get ingredientsHelper => 'Important pour les allergies.';

  @override
  String get sellBy => 'Vendu à la';

  @override
  String get freeDeliveryHint =>
      'Le client ne paie pas la livraison ; les frais sont déduits de vos gains.';

  @override
  String get readyMadeHint => 'Déjà fait, prêt à livrer.';

  @override
  String get madeToOrderHint =>
      'Vous le faites après chaque commande. Les règles viennent à l\'étape suivante.';

  @override
  String pricePer(String unit) {
    return 'Prix par $unit';
  }

  @override
  String get priceRequired => 'Entrez un prix.';

  @override
  String get stockLabel => 'Stock';

  @override
  String get lowStockAlertLabel => 'Alerte stock bas à';

  @override
  String get readyInLabel => 'Prêt en';

  @override
  String get modeRequired => 'Choisissez au moins un mode de vente.';

  @override
  String get suggestedByKafza =>
      'Suggéré par Kavza. Modifiez ce qui ne vous convient pas.';

  @override
  String get minPerOrder => 'Minimum par commande';

  @override
  String get orderBy => 'Par tranche de';

  @override
  String get setMaximum => 'Maximum par commande';

  @override
  String get maxPerOrder => 'Maximum';

  @override
  String get leadTimeLabel => 'À commander au moins';

  @override
  String get prepTimeLabel => 'Temps de préparation';

  @override
  String get prepLongerThanLead =>
      'La préparation ne peut pas dépasser le délai demandé.';

  @override
  String get deliveryDays => 'Jours de livraison';

  @override
  String get daysRequired => 'Choisissez au moins un jour.';

  @override
  String get optionsIntro =>
      'Les options permettent au client de choisir une taille, un parfum, une couleur ou d\'ajouter un court texte. Les suppléments s\'ajoutent au total.';

  @override
  String get noOptions =>
      'Aucune option. C\'est possible : le client choisit seulement la quantité.';

  @override
  String get addOptionGroup => 'Ajouter un groupe d\'options';

  @override
  String get editOptionGroup => 'Modifier le groupe d\'options';

  @override
  String maxChars(int n) {
    return '$n caractères max';
  }

  @override
  String get optionSingle => 'Un seul choix';

  @override
  String get optionMultiple => 'Plusieurs choix';

  @override
  String get optionColour => 'Couleur';

  @override
  String get optionText => 'Texte court';

  @override
  String get choiceName => 'Choix';

  @override
  String get removeChoice => 'Retirer le choix';

  @override
  String get extraPrice => 'Supplément (facultatif)';

  @override
  String get perOrder => 'Par commande';

  @override
  String perUnitLabel(String unit) {
    return 'Par $unit';
  }

  @override
  String swatchN(int n) {
    return 'Couleur $n';
  }

  @override
  String get optionGroupName => 'Nom du groupe';

  @override
  String get optionGroupNameHelper =>
      'Par ex. Taille, Parfum, Prénom sur le gâteau';

  @override
  String get optionTypeLabel => 'Type';

  @override
  String get optionRequired => 'Obligatoire';

  @override
  String get optionRequiredHint => 'Le client doit choisir pour continuer.';

  @override
  String get textOptionHint =>
      'Le client écrit un court texte, comme un prénom sur le gâteau. Numéros et liens sont bloqués.';

  @override
  String get maxLengthLabel => 'Longueur max';

  @override
  String get choices => 'Choix';

  @override
  String get addChoice => 'Ajouter un choix';

  @override
  String get storePending => 'En vérification';

  @override
  String get storeRejected => 'Refusée';

  @override
  String get logOut => 'Se déconnecter';

  @override
  String get storeApproved =>
      'Votre boutique est validée. Vous pouvez publier vos produits.';

  @override
  String get storeRejectedNotice =>
      'Votre boutique n\'a pas été validée. Ouvrez l\'accueil pour voir le motif.';

  @override
  String get noticeNewOrder => 'Nouvelle commande';

  @override
  String get noticeLowStock => 'Stock bas';

  @override
  String get noticeReview => 'Nouvel avis';

  @override
  String get noticeStrike => 'Vous avez reçu un avertissement';

  @override
  String get noticeSuspended => 'Votre boutique est suspendue';

  @override
  String get noticeSuspendedBody =>
      'Vos produits sont masqués pendant 7 jours.';

  @override
  String clientIn(String commune, String detail) {
    return 'Client à $commune · $detail';
  }

  @override
  String get commissionLine => 'Commission Kavza';

  @override
  String get deliveryDeductedLine => 'Livraison offerte (à votre charge)';

  @override
  String get netEarnings => 'Vos gains nets';

  @override
  String ordersNew(int n) {
    return 'Nouvelles ($n)';
  }

  @override
  String ordersInProgress(int n) {
    return 'En cours ($n)';
  }

  @override
  String get ordersHistory => 'Historique';

  @override
  String get noNewOrders => 'Aucune nouvelle commande';

  @override
  String get noNewOrdersHint =>
      'Les commandes qui attendent votre réponse apparaissent ici.';

  @override
  String get noOrdersInProgress => 'Aucune commande en cours';

  @override
  String get noOrdersInProgressHint =>
      'Les commandes acceptées restent ici jusqu\'à la livraison.';

  @override
  String get noOrderHistory => 'Historique vide';

  @override
  String get noOrderHistoryHint =>
      'Les commandes livrées, refusées ou annulées apparaissent ici.';

  @override
  String storeMoneyPlaced(String total) {
    return '$total toujours dans le Yassir Cash du client. Prélevé quand vous acceptez.';
  }

  @override
  String storeMoneyHeld(String total) {
    return 'Commande confirmée, paiement sécurisé. Kavza conserve $total jusqu\'à la livraison.';
  }

  @override
  String storeMoneyPaid(String amount) {
    return 'Livrée. $amount ajoutés à vos gains.';
  }

  @override
  String get storeMoneyDisputed =>
      'Le client a signalé un problème. Kavza l\'examine.';

  @override
  String get storePaymentFailed =>
      'Paiement échoué : solde du client insuffisant. Le stock est revenu, pas d\'avertissement.';

  @override
  String get storeMoneyDeclined =>
      'Commande refusée. Rien n\'a été prélevé au client, pas d\'avertissement.';

  @override
  String get storeMoneyExpired =>
      'Cette commande a expiré. Rien n\'a été prélevé, pas d\'avertissement.';

  @override
  String get storeMoneyCancelledByClient =>
      'Le client a annulé avant votre réponse. Rien n\'a été prélevé.';

  @override
  String storeMoneyCancelled(String total) {
    return 'Annulée. Le client a été remboursé de $total et vous avez reçu un avertissement.';
  }

  @override
  String storeDeliveryFailedPaid(String amount) {
    return 'Échec de livraison. Produit sur commande : vous recevez $amount.';
  }

  @override
  String get storeDeliveryFailedRefund =>
      'Échec de livraison. Le produit revient dans votre stock ; le client est remboursé hors frais de livraison.';

  @override
  String get orderCancelledStrike =>
      'Commande annulée. Le client est remboursé.';

  @override
  String get orderDeclined => 'Commande refusée.';

  @override
  String get markReadyTitle => 'Commande prête ?';

  @override
  String get markReadyBody =>
      'Un livreur Yassir Express viendra la récupérer à votre point de retrait.';

  @override
  String get ready => 'Prête';

  @override
  String get accept => 'Accepter';

  @override
  String get decline => 'Refuser';

  @override
  String get securingPayment => 'Sécurisation du paiement…';

  @override
  String get startPreparation => 'Commencer la préparation';

  @override
  String get markReady => 'Marquer comme prête';

  @override
  String answerBefore(String time) {
    return 'Répondez avant $time, sinon elle expire (sans avertissement).';
  }

  @override
  String get waitingCourier => 'En attente du livreur';

  @override
  String get waitingCourierBody =>
      'Un livreur Yassir Express a été demandé. Gardez la commande prête au point de retrait.';

  @override
  String get courierOnTheWay => 'En route avec Yassir Express';

  @override
  String get courierOnTheWayBody => 'Vos gains sont crédités à la livraison.';

  @override
  String deliveredToCommune(String commune) {
    return 'Livraison à $commune';
  }

  @override
  String get yourEarnings => 'Vos gains';

  @override
  String clientPays(String total) {
    return 'Le client paie $total.';
  }

  @override
  String get cancelOrderStoreTitle => 'Annuler une commande acceptée';

  @override
  String get declineTitle => 'Refuser la commande';

  @override
  String cancelStrikeWarning(int n, int max) {
    return 'Le client est remboursé intégralement et vous recevez un avertissement ($n sur $max). À $max, votre boutique est suspendue 7 jours.';
  }

  @override
  String get declineBody =>
      'Rien n\'est prélevé au client et le stock revient. Pas d\'avertissement.';

  @override
  String get reasonTitle => 'Motif';

  @override
  String get reasonOutOfStock => 'Produit épuisé';

  @override
  String get reasonNoTime => 'Pas le temps de la préparer';

  @override
  String get reasonDate => 'Date impossible';

  @override
  String get reasonOther => 'Autre motif';

  @override
  String get reasonDetails => 'Précisez le motif';

  @override
  String get reasonDetailsHelper => 'Le client le verra. Sans numéro ni lien.';

  @override
  String get cancelWithStrike => 'Annuler avec avertissement';

  @override
  String get storeOpen => 'Ouverte';

  @override
  String get storeSuspended => 'Suspendue';

  @override
  String suspendedBanner(String date) {
    return 'Boutique suspendue jusqu\'au $date : vos produits sont masqués et vous ne recevez plus de commandes. Les commandes acceptées continuent normalement.';
  }

  @override
  String strikeStanding(int n, int max) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n avertissements',
      one: '$n avertissement',
    );
    return '$_temp0 sur $max avant une suspension de 7 jours';
  }

  @override
  String get availableBalance => 'Solde disponible';

  @override
  String get todayOrders => 'Commandes du jour';

  @override
  String needsAnswer(int n) {
    return 'En attente de votre réponse ($n)';
  }

  @override
  String get needsAnswerEmpty =>
      'Rien en attente. Les nouvelles commandes apparaissent ici.';

  @override
  String get lowStockTitle => 'Stock bas';

  @override
  String onHold(String amount) {
    return 'En attente : $amount';
  }

  @override
  String get onHoldHint =>
      'Gains des commandes acceptées, crédités à la livraison.';

  @override
  String get addCcpFirst =>
      'Ajoutez votre compte CCP dans le profil pour retirer vos gains.';

  @override
  String withdrawMinimum(String amount) {
    return 'Retrait minimum : $amount.';
  }

  @override
  String withdrawMax(String amount) {
    return 'Vous ne pouvez pas retirer plus de $amount.';
  }

  @override
  String withdrawTo(String account) {
    return 'Vers le compte CCP $account';
  }

  @override
  String get perOrderTitle => 'Par commande';

  @override
  String get noEarningsYet =>
      'Vos gains apparaissent ici après la première livraison.';

  @override
  String get withdrawalsTitle => 'Retraits';

  @override
  String get noWithdrawals => 'Aucun retrait pour l\'instant.';

  @override
  String get withdrawalRequested => 'Demandé';

  @override
  String get withdrawalSent => 'Envoyé';

  @override
  String get withdrawalFailed => 'Échoué';

  @override
  String get withdraw => 'Retirer';

  @override
  String get withdrawAmount => 'Montant';

  @override
  String availableAmount(String amount) {
    return 'Disponible : $amount';
  }

  @override
  String withdrawConfirm(String amount) {
    return 'Retirer $amount';
  }

  @override
  String withdrawDone(String amount) {
    return 'Retrait de $amount demandé.';
  }

  @override
  String get reportReviewTitle => 'Signaler cet avis ?';

  @override
  String get reportReviewBody =>
      'Kavza va l\'examiner. Il reste visible jusqu\'à sa décision.';

  @override
  String get reportReview => 'Signaler';

  @override
  String get reviewReported => 'Avis signalé.';

  @override
  String get reviewReportedBadge => 'Signalé';

  @override
  String get reviewsTitle => 'Avis';

  @override
  String reviewCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n avis',
      one: '1 avis',
    );
    return '$_temp0';
  }

  @override
  String get reviewsNoReply =>
      'Les avis ne peuvent pas recevoir de réponse. S\'il est inapproprié, signalez-le à Kavza.';

  @override
  String get strikesTitle => 'Avertissements';

  @override
  String get strikesHow =>
      'Un avertissement s\'ajoute quand vous annulez une commande déjà acceptée. À 3, la boutique est suspendue 7 jours. Refuser avant d\'accepter ou laisser expirer ne compte pas.';

  @override
  String get strikesListTitle => 'Vos avertissements';

  @override
  String get noStrikes => 'Aucun avertissement.';

  @override
  String get appeal => 'Contester';

  @override
  String get appealSent => 'Contestation en cours d\'examen';

  @override
  String get appealTitle => 'Contester l\'avertissement';

  @override
  String get appealBody =>
      'Expliquez ce qui s\'est passé. Kavza examine votre demande et vous répond ici.';

  @override
  String get appealText => 'Ce qui s\'est passé';

  @override
  String get appealAttachment =>
      'Pièces jointes (non disponibles dans le prototype)';

  @override
  String get appealDone => 'Contestation envoyée.';

  @override
  String get sendAppeal => 'Envoyer la contestation';

  @override
  String get noNotifications => 'Aucune notification';

  @override
  String get noNotificationsHint =>
      'Nouvelles commandes, avis et alertes apparaissent ici.';

  @override
  String get storeFaqPaidQ => 'Quand suis-je payée ?';

  @override
  String get storeFaqPaidA =>
      'Quand vous acceptez, le client est débité et Kavza garde l\'argent. À la livraison, vos gains sont crédités : le montant des articles moins la commission, et moins les frais de livraison si elle est offerte.';

  @override
  String get storeFaqAcceptQ => 'Que se passe-t-il quand j\'accepte ?';

  @override
  String get storeFaqAcceptA =>
      'Kavza sécurise le paiement tout de suite. Si le solde du client est insuffisant, la commande est annulée et le stock revient, sans avertissement pour vous.';

  @override
  String get storeFaqStrikesQ => 'Comment marchent les avertissements ?';

  @override
  String get storeFaqWithdrawQ => 'Comment retirer mes gains ?';

  @override
  String storeFaqWithdrawA(String amount) {
    return 'Depuis l\'onglet Gains, vers le compte CCP de votre profil. Minimum $amount.';
  }

  @override
  String get storeFaqContactQ =>
      'Pourquoi ne puis-je pas contacter le client ?';

  @override
  String get storeFaqContactA =>
      'Pour protéger tout le monde, tout passe par Kavza : paiement, livraison et aide. Vous voyez seulement la commune du client, et les numéros et liens sont bloqués dans tous les textes.';

  @override
  String get storeSupportLine =>
      'Une autre question ? Le support Kavza répond sous 24 h.';
}
