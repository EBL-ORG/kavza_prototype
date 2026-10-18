// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'Kavza';

  @override
  String get byYassir => 'by Yassir';

  @override
  String get currency => 'د.ج';

  @override
  String get launcherTitle => 'نموذج أولي';

  @override
  String get launcherSubtitle =>
      'اختر ما تريد عرضه. التطبيقان يتشاركان نفس البيانات.';

  @override
  String get clientApp => 'تطبيق الزبون';

  @override
  String get clientAppHint => 'Kavza داخل تطبيق Yassir';

  @override
  String get storeApp => 'تطبيق Kavza Store';

  @override
  String get storeAppHint => 'تطبيق صاحبات المتاجر';

  @override
  String get sideBySide => 'جنبًا إلى جنب';

  @override
  String get sideBySideHint => 'الزبون والمتجر معًا على شاشة واحدة';

  @override
  String get language => 'اللغة';

  @override
  String get langAr => 'العربية';

  @override
  String get langFr => 'Français';

  @override
  String get backToLauncher => 'العودة إلى القائمة';

  @override
  String get cancel => 'إلغاء';

  @override
  String get statusPlaced => 'تم الطلب';

  @override
  String get statusAccepted => 'مقبولة';

  @override
  String get statusInPreparation => 'قيد التحضير';

  @override
  String get statusReady => 'جاهزة';

  @override
  String get statusPickedUp => 'استلمها المندوب';

  @override
  String get statusDelivered => 'تم التسليم';

  @override
  String get statusCancelledByClient => 'ألغاها الزبون';

  @override
  String get statusDeclined => 'رفضها المتجر';

  @override
  String get statusExpired => 'انتهت المهلة';

  @override
  String get statusPaymentFailed => 'فشل الدفع';

  @override
  String get statusCancelledAfterAcceptance => 'أُلغيت بعد القبول';

  @override
  String get statusDeliveryFailed => 'فشل التسليم';

  @override
  String get statusDisputed => 'قيد المراجعة';

  @override
  String get demoPanel => 'لوحة العرض';

  @override
  String get demoPanelHint => 'تحلّ محلّ الإدارة و Yassir Express أثناء العرض.';

  @override
  String get demoClock => 'الساعة';

  @override
  String demoClockNow(String time) {
    return 'الوقت المحاكى: $time';
  }

  @override
  String get demoAdd15m => '+15 دقيقة';

  @override
  String get demoAdd1h => '+1 ساعة';

  @override
  String get demoAdd24h => '+24 ساعة';

  @override
  String get demoCourier => 'أحداث التوصيل';

  @override
  String get demoCourierEmpty =>
      'لا توجد طلبية بانتظار المندوب. حدّد طلبية كـ«جاهزة» في تطبيق المتجر.';

  @override
  String get demoStoreReview => 'مراجعة المتاجر';

  @override
  String get demoStoreReviewEmpty => 'لا يوجد متجر بانتظار المراجعة.';

  @override
  String get demoApprove => 'قبول';

  @override
  String get demoReject => 'رفض';

  @override
  String get demoBalance => 'رصيد Yassir Cash للزبون';

  @override
  String demoBalanceNow(String name, String amount) {
    return '$name · الرصيد الحالي $amount';
  }

  @override
  String get demoBalanceField => 'الرصيد الجديد';

  @override
  String get demoBalanceSet => 'تطبيق';

  @override
  String get demoReset => 'إعادة ضبط البيانات';

  @override
  String get demoResetHint => 'يعيد بيانات العرض والساعة إلى البداية.';

  @override
  String get demoResetConfirm => 'إعادة ضبط كل البيانات؟';

  @override
  String get demoResetBody =>
      'ستُحذف الطلبيات والتغييرات التي أُجريت أثناء العرض.';

  @override
  String yassirHello(String name) {
    return 'أهلًا، $name';
  }

  @override
  String get yassirCash => 'Yassir Cash';

  @override
  String get yassirWhatToday => 'ماذا يمكننا أن نفعل لك؟';

  @override
  String get yassirRide => 'رحلة';

  @override
  String get yassirFood => 'مطاعم';

  @override
  String get yassirMarket => 'سوبرماركت';

  @override
  String get yassirNotInDemo => 'هذه الخدمة ليست ضمن العرض.';

  @override
  String get yassirLocation => 'موقعك الحالي';

  @override
  String get yassirParcel => 'طرود';

  @override
  String get yassirSend => 'إرسال';

  @override
  String get yassirTopUp => 'شحن الرصيد';

  @override
  String get deliverToLabel => 'التوصيل إلى';

  @override
  String get kafza => 'Kavza';

  @override
  String get kafzaTileHint => 'منتجات منزلية من متاجر قريبة منك';

  @override
  String get badgeNew => 'جديد';

  @override
  String get badgePro => 'Pro';

  @override
  String get backToYassir => 'العودة إلى Yassir';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get help => 'المساعدة';

  @override
  String get tabHome => 'الرئيسية';

  @override
  String get tabSearch => 'البحث';

  @override
  String get tabOrders => 'طلبياتي';

  @override
  String get tabFavourites => 'المفضلة';

  @override
  String get chooseAddress => 'عنوان التوصيل';

  @override
  String get searchHint => 'ابحث عن منتج أو متجر';

  @override
  String waitingBanner(String time) {
    return 'بانتظار رد المتجر · بقي $time';
  }

  @override
  String get servicesTitle => 'الخدمات';

  @override
  String get categoriesTitle => 'الفئات';

  @override
  String get nearbyStores => 'متاجر قريبة منك';

  @override
  String get newProducts => 'وصل حديثًا';

  @override
  String get popularProducts => 'الأكثر طلبًا';

  @override
  String get serviceCooking => 'الطبخ';

  @override
  String get serviceSewing => 'الخياطة';

  @override
  String get serviceCrafts => 'الحرف اليدوية';

  @override
  String get categoryTraditionalFood => 'أطباق تقليدية';

  @override
  String get categoryTraditionalSweets => 'حلويات تقليدية';

  @override
  String get categoryCakes => 'كعك وحلويات';

  @override
  String get categoryBreads => 'خبز ومطلوع';

  @override
  String get categoryTraditionalClothing => 'ألبسة تقليدية';

  @override
  String get categoryChildrenClothing => 'ملابس الأطفال';

  @override
  String get categoryPottery => 'الفخار';

  @override
  String get categoryRugs => 'الزرابي';

  @override
  String get categoryBaskets => 'السلال';

  @override
  String get categoryJewellery => 'المجوهرات';

  @override
  String get unitPiece => 'قطعة';

  @override
  String get unitKg => 'كغ';

  @override
  String get unitBox => 'علبة';

  @override
  String get unitPortion => 'حصة';

  @override
  String qtyPiece(num n) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$nString قطعة',
      few: '$nString قطع',
      two: 'قطعتان',
      one: 'قطعة واحدة',
    );
    return '$_temp0';
  }

  @override
  String qtyKg(num n) {
    final intl.NumberFormat nNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String nString = nNumberFormat.format(n);

    return '$nString كغ';
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
      other: '$nString علبة',
      few: '$nString علب',
      two: 'علبتان',
      one: 'علبة واحدة',
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
      other: '$nString حصة',
      few: '$nString حصص',
      two: 'حصتان',
      one: 'حصة واحدة',
    );
    return '$_temp0';
  }

  @override
  String pricePerUnit(String price, String unit) {
    return '$price / $unit';
  }

  @override
  String communeDistance(String commune, String km) {
    return '$commune · ≈ $km كم';
  }

  @override
  String storeDistance(String store, String km) {
    return '$store · ≈ $km كم';
  }

  @override
  String get notTakingOrders => 'لا يستقبل طلبيات حاليًا';

  @override
  String get currentlyUnavailable => 'غير متوفر حاليًا';

  @override
  String get fewLeft => 'بقيت كمية قليلة';

  @override
  String get freeDelivery => 'توصيل مجاني';

  @override
  String get ingredients => 'المكونات';

  @override
  String get readyMadeTitle => 'منتج جاهز';

  @override
  String get madeToOrderTitle => 'حسب الطلب';

  @override
  String inStock(String qty) {
    return 'متوفر: $qty';
  }

  @override
  String get outOfStock => 'نفد المخزون';

  @override
  String readyIn(String time) {
    return 'جاهز خلال $time';
  }

  @override
  String preparedIn(String time) {
    return 'مدة التحضير $time';
  }

  @override
  String ruleMin(String qty) {
    return 'الحد الأدنى $qty';
  }

  @override
  String ruleStep(String qty) {
    return 'بمضاعفات $qty';
  }

  @override
  String ruleMax(String qty) {
    return 'الحد الأقصى $qty';
  }

  @override
  String ruleLead(String time) {
    return 'اطلب قبل $time على الأقل';
  }

  @override
  String ruleDays(String days) {
    return 'التوصيل أيام $days';
  }

  @override
  String get ruleEveryDay => 'التوصيل كل يوم';

  @override
  String ruleOptions(String groups) {
    return 'اختيارات: $groups';
  }

  @override
  String get listSeparator => '، ';

  @override
  String photoOf(int index, int total) {
    return 'الصورة $index من $total';
  }

  @override
  String ratingSemantics(String average, int count) {
    return 'التقييم $average من 5، عدد التقييمات $count';
  }

  @override
  String starsSemantics(int stars) {
    return '$stars من 5 نجوم';
  }

  @override
  String durationMinutes(int m) {
    return '$m د';
  }

  @override
  String durationHours(int h) {
    return '$h س';
  }

  @override
  String durationHoursMinutes(int h, int m) {
    return '$h س $m د';
  }

  @override
  String durationDays(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n يومًا',
      few: '$n أيام',
      two: 'يومان',
      one: 'يوم واحد',
    );
    return '$_temp0';
  }

  @override
  String get orderNow => 'اطلب الآن';

  @override
  String get orderMadeForMe => 'اطلب تحضيره لي';

  @override
  String get outOfStockHint => 'نفد المخزون، ولا يُصنع هذا المنتج حسب الطلب.';

  @override
  String get productPausedHint => 'أوقف المتجر هذا المنتج مؤقتًا.';

  @override
  String get share => 'مشاركة';

  @override
  String get linkCopied => 'تم نسخ الرابط';

  @override
  String get addFavourite => 'إضافة إلى المفضلة';

  @override
  String get removeFavourite => 'إزالة من المفضلة';

  @override
  String reliability(String percent) {
    return '$percent من الطلبيات سُلّمت';
  }

  @override
  String serviceRating(String service, String stars) {
    return '$service: ‎$stars/5';
  }

  @override
  String get pausedStoreHint => 'ستظهر منتجاته عندما يستأنف نشاطه.';

  @override
  String get noProducts => 'لا توجد منتجات حاليًا';

  @override
  String get noProductsHint => 'عد لاحقًا لرؤية الجديد.';

  @override
  String get noReviews => 'لا توجد تقييمات بعد';

  @override
  String get noReviewsHint => 'تظهر التقييمات بعد أولى الطلبيات المسلّمة.';

  @override
  String tabProductsCount(int n) {
    return 'المنتجات ($n)';
  }

  @override
  String tabStoresCount(int n) {
    return 'المتاجر ($n)';
  }

  @override
  String tabReviewsCount(int n) {
    return 'التقييمات ($n)';
  }

  @override
  String get noResults => 'لا توجد نتائج';

  @override
  String get noResultsHint => 'جرّب كلمة أخرى أو أزل بعض الفلاتر.';

  @override
  String get clearFilters => 'إزالة الفلاتر';

  @override
  String get clearSearch => 'مسح البحث';

  @override
  String get removeFilter => 'إزالة';

  @override
  String get recentSearches => 'عمليات البحث الأخيرة';

  @override
  String get clear => 'مسح';

  @override
  String get filters => 'الفلاتر';

  @override
  String get sortBy => 'الترتيب';

  @override
  String get sortClosest => 'الأقرب';

  @override
  String get sortRating => 'الأعلى تقييمًا';

  @override
  String get sortPrice => 'الأقل سعرًا';

  @override
  String get sortPrepTime => 'الأسرع تحضيرًا';

  @override
  String get filterWilaya => 'الولاية';

  @override
  String get all => 'الكل';

  @override
  String get filterAvailability => 'التوفر';

  @override
  String get filterAvailableNow => 'متوفر الآن';

  @override
  String get filterMadeToOrder => 'يُصنع حسب الطلب';

  @override
  String get filterMinRating => 'أدنى تقييم';

  @override
  String get filterPrice => 'السعر';

  @override
  String priceRange(String min, String max) {
    return '$min – $max';
  }

  @override
  String get reset => 'إعادة ضبط';

  @override
  String get showResults => 'عرض النتائج';

  @override
  String get emptyFavourites => 'لا شيء في المفضلة بعد';

  @override
  String get emptyFavouritesHint =>
      'اضغط على القلب في صفحة منتج أو متجر لتجده هنا.';

  @override
  String get browse => 'تصفّح Kavza';

  @override
  String labelValue(String label, String value) {
    return '$label: $value';
  }

  @override
  String get decrease => 'إنقاص';

  @override
  String get increase => 'زيادة';

  @override
  String get contactPhone => 'أرقام الهاتف غير مسموح بها.';

  @override
  String get contactEmail => 'عناوين البريد الإلكتروني غير مسموح بها.';

  @override
  String get contactLink => 'الروابط غير مسموح بها.';

  @override
  String get contactHandle => 'أسماء الحسابات (@) غير مسموح بها.';

  @override
  String get contactWord =>
      'ذكر واتساب أو إنستغرام أو تطبيقات أخرى غير مسموح به.';

  @override
  String get contactWhy => 'لحمايتك، يتم كل شيء عبر Kavza.';

  @override
  String get errorUnavailable => 'لا يمكن طلب هذا المنتج حاليًا.';

  @override
  String get errorWaitingOrder => 'لديك طلبية بانتظار رد متجر.';

  @override
  String get errorOutOfStock => 'الكمية المتوفرة لا تكفي. غيّر الكمية.';

  @override
  String get errorInvalidQty => 'هذه الكمية غير مسموح بها.';

  @override
  String get errorMissingOption => 'اختر الخيارات المطلوبة.';

  @override
  String get errorInvalidOption => 'أحد الخيارات لم يعد متوفرًا.';

  @override
  String get errorInvalidDate => 'هذا التاريخ لم يعد متاحًا. اختر تاريخًا آخر.';

  @override
  String get errorLowBalance => 'رصيد Yassir Cash غير كافٍ.';

  @override
  String get errorNotAllowed => 'لم يعد هذا الإجراء ممكنًا.';

  @override
  String timeLeft(String time) {
    return 'بقي $time';
  }

  @override
  String get optionsLine => 'الخيارات';

  @override
  String get deliveryFeeLine => 'رسوم التوصيل';

  @override
  String get totalLine => 'المجموع';

  @override
  String itemsLine(String qty, String price) {
    return '$qty × $price';
  }

  @override
  String get itemsTotal => 'المنتجات';

  @override
  String get quantity => 'الكمية';

  @override
  String get required => 'إلزامي';

  @override
  String get optional => 'اختياري';

  @override
  String get deliveryDate => 'تاريخ التوصيل';

  @override
  String get chooseDate => 'اختر تاريخًا';

  @override
  String etaReadyMade(String time) {
    return 'يصلك بعد حوالي $time من قبول المتجر.';
  }

  @override
  String get etaMadeToOrder => 'يصلك في التاريخ الذي تختاره.';

  @override
  String toContinue(String items) {
    return 'للمتابعة، اختر: $items';
  }

  @override
  String continueTotal(String total) {
    return 'متابعة · $total';
  }

  @override
  String get summaryTitle => 'ملخص الطلبية';

  @override
  String get summaryMoneyNote =>
      'لن يُقتطع أي مبلغ الآن. يُقتطع المبلغ من Yassir Cash عندما يقبل المتجر الطلبية.';

  @override
  String get placeOrder => 'تأكيد الطلبية';

  @override
  String missingAmount(String amount) {
    return 'ينقصك $amount';
  }

  @override
  String get rechargeCcp => 'الشحن عبر CCP';

  @override
  String get waitingTitle => 'لديك طلبية بانتظار الرد';

  @override
  String get waitingBody =>
      'يمكن أن تنتظر طلبية واحدة فقط رد المتجر في نفس الوقت.';

  @override
  String get keepIt => 'الإبقاء عليها';

  @override
  String get cancelAndPlace => 'إلغاؤها وتأكيد هذه';

  @override
  String get rechargeAmount => 'مبلغ الشحن';

  @override
  String get rechargeMockNote => 'صفحة Yassir تجريبية: لا يتم أي دفع حقيقي.';

  @override
  String rechargeConfirm(String amount) {
    return 'شحن $amount';
  }

  @override
  String rechargeDone(String amount) {
    return 'تمت إضافة $amount';
  }

  @override
  String newBalance(String amount) {
    return 'رصيدك الجديد: $amount';
  }

  @override
  String get backToOrder => 'العودة إلى الطلبية';

  @override
  String get placedTitle => 'تم إرسال طلبيتك';

  @override
  String orderNumber(String id) {
    return 'طلبية $id';
  }

  @override
  String placedDeadline(String store, String window, String time) {
    return 'أمام $store مهلة $window للرد (حتى $time).';
  }

  @override
  String get placedMoneyNote =>
      'لم يُقتطع أي مبلغ بعد. سيُقتطع المبلغ من Yassir Cash عندما يقبل المتجر. إذا لم يكفِ رصيدك حينها، تُلغى الطلبية.';

  @override
  String get trackOrder => 'تتبع الطلبية';

  @override
  String get backToKafza => 'العودة إلى Kavza';

  @override
  String moneyInWallet(String total) {
    return '$total لا يزال في Yassir Cash. يُقتطع عند قبول المتجر.';
  }

  @override
  String get moneyNothingTaken => 'لم يُقتطع أي مبلغ من Yassir Cash.';

  @override
  String moneyHeld(String total) {
    return 'دُفع $total، تحتفظ به Kavza حتى التسليم.';
  }

  @override
  String moneyPaid(String total) {
    return 'دُفع $total.';
  }

  @override
  String moneyRefunded(String amount) {
    return 'استُرجع $amount إلى Yassir Cash.';
  }

  @override
  String moneyUnderReview(String total) {
    return 'دُفع $total، قيد المراجعة لدى Kavza.';
  }

  @override
  String ordersCurrent(int n) {
    return 'الحالية ($n)';
  }

  @override
  String ordersPast(int n) {
    return 'السابقة ($n)';
  }

  @override
  String get noCurrentOrders => 'لا توجد طلبيات جارية';

  @override
  String get noPastOrders => 'لا توجد طلبيات سابقة';

  @override
  String get noOrdersHint => 'تظهر طلبياتك هنا بعد تأكيدها.';

  @override
  String waitingForStore(String time) {
    return 'بانتظار رد المتجر حتى $time. لم يُقتطع أي مبلغ بعد.';
  }

  @override
  String get cancelOrder => 'إلغاء الطلبية';

  @override
  String get cancelOrderTitle => 'إلغاء هذه الطلبية؟';

  @override
  String get cancelOrderBody =>
      'لم يُقتطع أي مبلغ من Yassir Cash، وسيتم إعلام المتجر.';

  @override
  String get orderCancelled => 'أُلغيت الطلبية.';

  @override
  String get courierTitle => 'مندوب Yassir Express في الطريق';

  @override
  String courierBody(String label) {
    return 'يوصل طلبيتك إلى $label.';
  }

  @override
  String get orderStatusTitle => 'حالة الطلبية';

  @override
  String get orderDetailsTitle => 'التفاصيل';

  @override
  String deliveryOn(String date) {
    return 'التوصيل يوم $date';
  }

  @override
  String get yourReview => 'تقييمك';

  @override
  String get leaveReview => 'اترك تقييمًا';

  @override
  String get reviewComment => 'تعليق (اختياري)';

  @override
  String get sendReview => 'إرسال التقييم';

  @override
  String get reviewThanks => 'شكرًا على تقييمك.';

  @override
  String get reportProblem => 'الإبلاغ عن مشكلة';

  @override
  String reportUntil(String time) {
    return 'يمكنك الإبلاغ حتى $time.';
  }

  @override
  String get problemReason => 'ما المشكلة؟';

  @override
  String get problemDamaged => 'وصل المنتج تالفًا';

  @override
  String get problemWrongItem => 'منتج غير الذي طلبته';

  @override
  String get problemMissingItems => 'ينقص جزء من الطلبية';

  @override
  String get problemNotAsDescribed => 'لا يطابق الوصف';

  @override
  String get problemOther => 'مشكلة أخرى';

  @override
  String get problemDetails => 'صف المشكلة';

  @override
  String get problemPhotos => 'الصور (غير متاحة في النموذج)';

  @override
  String get sendReport => 'إرسال البلاغ';

  @override
  String get problemSent => 'تم إرسال البلاغ. ستراجعه Kavza.';

  @override
  String get faqTitle => 'أسئلة شائعة';

  @override
  String get faqPaymentQ => 'متى يُقتطع المبلغ؟';

  @override
  String get faqPaymentA =>
      'لا شيء عند تأكيد الطلبية. يُقتطع المبلغ كاملًا من Yassir Cash عندما يقبل المتجر، وتحتفظ به Kavza حتى التسليم. إذا لم يكفِ رصيدك عند القبول، تُلغى الطلبية دون اقتطاع أي شيء.';

  @override
  String get faqCancelQ => 'هل يمكنني إلغاء طلبية؟';

  @override
  String get faqCancelA =>
      'نعم، طالما لم يقبلها المتجر بعد. إذا ألغاها المتجر بعد القبول، يُسترجع المبلغ كاملًا إلى Yassir Cash.';

  @override
  String get faqDeliveryQ => 'من يوصل طلبيتي؟';

  @override
  String get faqDeliveryA =>
      'يستلمها مندوب Yassir Express من المتجر عندما تصبح جاهزة ويوصلها إلى عنوانك. يمكنك تتبعها في «طلبياتي».';

  @override
  String get faqMessageQ => 'لماذا لا يمكنني مراسلة المتجر؟';

  @override
  String get faqMessageA =>
      'لحماية الطرفين، يتم كل شيء عبر Kavza: الدفع والتوصيل والمساعدة. لهذا تُمنع أرقام الهاتف والروابط وأسماء الحسابات في كل النصوص. لأي مشكلة، تواصل مع دعم Kavza.';

  @override
  String get contactSupport => 'تواصل مع دعم Kavza';

  @override
  String get contactSupportHint => 'يرد الفريق خلال 24 ساعة.';

  @override
  String get supportAbout => 'الموضوع';

  @override
  String get supportNoOrder => 'ليس بخصوص طلبية';

  @override
  String get supportMessage => 'رسالتك';

  @override
  String get supportSend => 'إرسال';

  @override
  String get supportSent => 'تم إرسال رسالتك. يرد الدعم خلال 24 ساعة.';

  @override
  String get photoTaken => 'تم التقاط الصورة';

  @override
  String get cameraCardHint => 'ضعي البطاقة داخل الإطار';

  @override
  String get cameraFaceHint => 'ضعي وجهك داخل الدائرة';

  @override
  String get retake => 'إعادة الالتقاط';

  @override
  String get takePhoto => 'التقاط صورة';

  @override
  String get proTitle => 'Kavza Pro';

  @override
  String get proBody =>
      'بالخطة المجانية تبيعين في فئة واحدة. مع Pro تبيعين في كل الفئات.';

  @override
  String get planFree => 'مجاني';

  @override
  String get planFreePrice => '0';

  @override
  String get planFreeLine => 'فئة واحدة';

  @override
  String perMonth(String price) {
    return '$price / شهر';
  }

  @override
  String get planProLine1 => 'كل الفئات';

  @override
  String get planProLine2 => 'شارة Pro على متجرك';

  @override
  String get proActive => 'Kavza Pro مفعّل في متجرك.';

  @override
  String proShort(String balance) {
    return 'يُدفع Pro من أرباحك. رصيدك $balance لا يكفي بعد.';
  }

  @override
  String proFromBalance(String balance) {
    return 'يُقتطع من رصيد أرباحك ($balance).';
  }

  @override
  String get getPro => 'الاشتراك في Kavza Pro';

  @override
  String get welcomeTitle => 'بيعي ما تصنعينه في البيت';

  @override
  String get welcomeBody =>
      'تصلك طلبيات زبائن Yassir. تتكفّل Kavza بالدفع والتوصيل.';

  @override
  String get getStarted => 'ابدئي الآن';

  @override
  String get haveStore => 'لديّ متجر';

  @override
  String get stepPhone => 'الهاتف';

  @override
  String get stepCode => 'الرمز';

  @override
  String get stepCard => 'البطاقة';

  @override
  String get stepSelfie => 'صورة شخصية';

  @override
  String stepOf(int n, int total, String label) {
    return 'الخطوة $n من $total: $label';
  }

  @override
  String get phoneTitle => 'رقم هاتفك';

  @override
  String get phoneBody => 'سنرسل لك رمزًا من 6 أرقام عبر رسالة قصيرة.';

  @override
  String get phoneLabel => 'رقم الهاتف المحمول';

  @override
  String get phoneHelper => 'لا يظهر للزبائن أبدًا.';

  @override
  String get phoneInvalid => 'أدخلي رقمًا محمولًا: 5 أو 6 أو 7 ثم 8 أرقام.';

  @override
  String get sendCode => 'إرسال الرمز';

  @override
  String get otpTitle => 'أدخلي الرمز';

  @override
  String otpBody(String phone) {
    return 'أُرسل إلى $phone.';
  }

  @override
  String otpDemo(String code) {
    return 'في النموذج، الرمز دائمًا $code.';
  }

  @override
  String get otpLabel => 'رمز التحقق من 6 أرقام';

  @override
  String get otpWrong => 'الرمز غير صحيح. تحققي من الرسالة وأعيدي المحاولة.';

  @override
  String resendIn(String time) {
    return 'إعادة الإرسال بعد $time';
  }

  @override
  String get resendCode => 'إعادة إرسال الرمز';

  @override
  String get codeSent => 'تم إرسال رمز جديد.';

  @override
  String get newStoreName => 'متجري';

  @override
  String get cardFrontTitle => 'بطاقة المقاول الذاتي: الوجه';

  @override
  String get cardBackTitle => 'بطاقة المقاول الذاتي: الظهر';

  @override
  String get cardPhotoBody =>
      'صوّري البطاقة الأصلية الآن. تأكدي أن الكتابة مقروءة.';

  @override
  String get cardDetailsTitle => 'رقم البطاقة ونشاطك';

  @override
  String get cardDetailsBody => 'كما هو مكتوب على بطاقة المقاول الذاتي.';

  @override
  String get cardNumber => 'رقم البطاقة';

  @override
  String get cardNumberHelper => 'تراه Kavza فقط، للتحقق.';

  @override
  String get cardNumberInvalid => 'الرقم قصير جدًا: 8 أرقام على الأقل.';

  @override
  String get activity => 'نشاطك';

  @override
  String get selfieTitle => 'صورة شخصية مباشرة';

  @override
  String get selfieBody => 'نقارنها بصورة البطاقة. صور المعرض غير مقبولة.';

  @override
  String get sendForReview => 'إرسال للتحقق';

  @override
  String get continueLabel => 'متابعة';

  @override
  String get pendingTitle => 'نتحقق من وثائقك';

  @override
  String get pendingBody => 'يتم التحقق عادة خلال 24 ساعة. ستصلك رسالة هنا.';

  @override
  String get pendingCanDo => 'يمكنك الآن';

  @override
  String get pendingCanProfile => 'تجهيز ملف متجرك: الاسم والوصف والصورة';

  @override
  String get pendingCanProducts => 'إضافة منتجاتك، تُحفظ كمسودات';

  @override
  String get pendingLocked => 'بعد الموافقة';

  @override
  String get pendingLockedPublish => 'نشر منتجاتك للزبائن';

  @override
  String get pendingLockedOrders => 'استقبال الطلبيات';

  @override
  String get rejectedTitle => 'لم نتمكن من التحقق من متجرك';

  @override
  String get rejectedBody =>
      'صوّري بطاقتك من جديد والتقطي صورة شخصية جديدة، ثم أعيدي الإرسال.';

  @override
  String get rejectedReason => 'السبب: صورة البطاقة غير مقروءة.';

  @override
  String get resubmit => 'إعادة الإرسال';

  @override
  String get addProduct => 'إضافة منتج';

  @override
  String get setUpStore => 'تجهيز متجري';

  @override
  String get profileSaved => 'تم حفظ ملف المتجر.';

  @override
  String get pauseTitle => 'إيقاف متجرك مؤقتًا؟';

  @override
  String get pauseBody =>
      'لن يرى الزبائن منتجاتك ولن تصلك طلبيات جديدة. الطلبيات المقبولة تستمر كالمعتاد.';

  @override
  String get pauseConfirm => 'إيقاف مؤقت';

  @override
  String get storePaused => 'متجرك متوقف مؤقتًا.';

  @override
  String get storeResumed => 'متجرك يستقبل الطلبيات من جديد.';

  @override
  String get storeProfile => 'ملف المتجر';

  @override
  String get storePicture => 'صورة المتجر';

  @override
  String get picturePhoto => 'صورة';

  @override
  String get pictureLogo => 'شعار';

  @override
  String get pictureNone => 'بدون';

  @override
  String get storeName => 'اسم المتجر';

  @override
  String get storeDescription => 'الوصف';

  @override
  String get storeDescriptionHelper =>
      'ما تصنعينه وما يميّزه. بدون أرقام هاتف أو روابط.';

  @override
  String get storeLocation => 'المنطقة';

  @override
  String get wilaya => 'الولاية';

  @override
  String get commune => 'البلدية';

  @override
  String get communeHelper => 'يرى الزبائن البلدية فقط، مع مسافة تقريبية.';

  @override
  String get pickupTitle => 'مكان الاستلام';

  @override
  String get pickupBody =>
      'يستلم مندوب Yassir Express طلبياتك من هنا. اسحبي الدبوس إلى بابك.';

  @override
  String get pickupMapSemantics =>
      'خريطة مكان الاستلام. المسي أو اسحبي لتحريك الدبوس.';

  @override
  String get neverShownToClients => 'لا يظهر للزبائن أبدًا.';

  @override
  String get payoutTitle => 'حساب استلام الأرباح';

  @override
  String get ccpLabel => 'حساب CCP / BaridiMob (الرقم + المفتاح)';

  @override
  String get ccpHelper => 'تُرسل أرباحك إلى هذا الحساب. تراه Kavza فقط.';

  @override
  String get ccpInvalid => 'بين 10 و20 رقمًا.';

  @override
  String get pauseStore => 'إيقاف متجري مؤقتًا';

  @override
  String get pauseStoreHint => 'تختفي منتجاتك من Kavza حتى تعيدي التشغيل.';

  @override
  String get save => 'حفظ';

  @override
  String get productsPendingBanner =>
      'متجرك قيد التحقق. تبقى المنتجات الجديدة مسودات حتى الموافقة.';

  @override
  String get productsPausedBanner =>
      'متجرك متوقف مؤقتًا: الزبائن لا يرون منتجاتك.';

  @override
  String get tabProducts => 'المنتجات';

  @override
  String get tabEarnings => 'الأرباح';

  @override
  String get tabMore => 'المزيد';

  @override
  String get noStoreProducts => 'لا توجد منتجات بعد';

  @override
  String get noStoreProductsHint =>
      'أضيفي أول منتج: جاهز للبيع، حسب الطلب، أو الاثنين.';

  @override
  String get productLive => 'معروض';

  @override
  String get productPaused => 'متوقف';

  @override
  String get productDraft => 'مسودة';

  @override
  String lowStock(int n) {
    return 'مخزون منخفض · $n';
  }

  @override
  String stockCount(int n) {
    return 'المخزون: $n';
  }

  @override
  String get productPausedDone => 'المنتج متوقف. لم يعد ظاهرًا للزبائن.';

  @override
  String get productLiveDone => 'المنتج معروض من جديد.';

  @override
  String get publishLocked => 'يمكنك النشر بعد موافقة Kavza على متجرك.';

  @override
  String get untitledProduct => 'منتج بدون عنوان';

  @override
  String get productActions => 'إجراءات المنتج';

  @override
  String get edit => 'تعديل';

  @override
  String get pause => 'إيقاف مؤقت';

  @override
  String get resume => 'إعادة العرض';

  @override
  String get editStock => 'تعديل المخزون';

  @override
  String get delete => 'حذف';

  @override
  String get deleteTitle => 'حذف هذا المنتج؟';

  @override
  String get deleteBody =>
      'يختفي من متجرك نهائيًا. الطلبيات السابقة تبقى في السجل.';

  @override
  String get deleteBlockedTitle => 'لا يمكن حذف هذا المنتج الآن';

  @override
  String get deleteBlockedBody =>
      'توجد طلبية جارية لهذا المنتج. أوقفيه مؤقتًا بدل حذفه، واحذفيه بعد انتهاء الطلبية.';

  @override
  String get ok => 'حسنًا';

  @override
  String get productDeleted => 'تم حذف المنتج.';

  @override
  String stockReserved(String qty) {
    return '$qty محجوزة لطلبيات تنتظر ردّك.';
  }

  @override
  String stockAlertAt(String qty) {
    return 'تنبيه المخزون المنخفض عند $qty.';
  }

  @override
  String get stockSaved => 'تم تحديث المخزون.';

  @override
  String get draftSaved => 'تم حفظ المسودة.';

  @override
  String draftSavedAt(String time) {
    return 'حُفظت المسودة على $time';
  }

  @override
  String get publishedDone => 'تم النشر. يراه الزبائن الآن.';

  @override
  String get changesSaved => 'تم حفظ التعديلات.';

  @override
  String get editorCategory => 'الفئة';

  @override
  String get editorDetails => 'الصور والتفاصيل';

  @override
  String get editorModes => 'طريقة البيع';

  @override
  String get editorRules => 'قواعد الطلب المسبق';

  @override
  String get editorOptions => 'الخيارات';

  @override
  String get editorPreview => 'المعاينة';

  @override
  String get newProduct => 'منتج جديد';

  @override
  String get editProduct => 'تعديل المنتج';

  @override
  String get closeEditor => 'إغلاق وحفظ المسودة';

  @override
  String get previewHint => 'هكذا سيرى الزبائن منتجك.';

  @override
  String get next => 'التالي';

  @override
  String get saveChanges => 'حفظ التعديلات';

  @override
  String get publish => 'نشر';

  @override
  String get saveDraft => 'حفظ كمسودة';

  @override
  String freePlanCategory(String category) {
    return 'الخطة المجانية: تبيعين في «$category». Kavza Pro يفتح كل الفئات.';
  }

  @override
  String get chooseCategory => 'اختاري فئة.';

  @override
  String get photos => 'الصور';

  @override
  String get removePhoto => 'حذف الصورة';

  @override
  String get addPhoto => 'إضافة صورة';

  @override
  String get addPhotoShort => 'إضافة';

  @override
  String get photosRequired => 'أضيفي صورة واحدة على الأقل.';

  @override
  String get productTitle => 'العنوان';

  @override
  String get titleRequired => 'أضيفي عنوانًا.';

  @override
  String get nameRequired => 'أضيفي اسمًا.';

  @override
  String get productDescription => 'الوصف';

  @override
  String get ingredientsHelper => 'مهم لمن لديهم حساسية.';

  @override
  String get sellBy => 'يُباع بـ';

  @override
  String get freeDeliveryHint =>
      'يدفع الزبون صفرًا للتوصيل، وتُخصم رسومه من أرباحك.';

  @override
  String get readyMadeHint => 'مصنوع مسبقًا وجاهز للتوصيل.';

  @override
  String get madeToOrderHint =>
      'تصنعينه بعد كل طلبية. تحدّدين القواعد في الخطوة التالية.';

  @override
  String pricePer(String unit) {
    return 'السعر لكل $unit';
  }

  @override
  String get priceRequired => 'أدخلي سعرًا.';

  @override
  String get stockLabel => 'المخزون';

  @override
  String get lowStockAlertLabel => 'تنبيه المخزون المنخفض عند';

  @override
  String get readyInLabel => 'جاهز خلال';

  @override
  String get modeRequired => 'اختاري طريقة بيع واحدة على الأقل.';

  @override
  String get suggestedByKafza => 'مقترح من Kavza. غيّري ما لا يناسبك.';

  @override
  String get minPerOrder => 'الحد الأدنى للطلبية';

  @override
  String get orderBy => 'بزيادة';

  @override
  String get setMaximum => 'حدّ أقصى للطلبية';

  @override
  String get maxPerOrder => 'الحد الأقصى';

  @override
  String get leadTimeLabel => 'يُطلب قبل';

  @override
  String get prepTimeLabel => 'مدة التحضير';

  @override
  String get prepLongerThanLead =>
      'لا يمكن أن يتجاوز التحضير المهلة التي تطلبينها.';

  @override
  String get deliveryDays => 'أيام التوصيل';

  @override
  String get daysRequired => 'اختاري يومًا واحدًا على الأقل.';

  @override
  String get optionsIntro =>
      'تسمح الخيارات للزبون باختيار الحجم أو النكهة أو اللون أو كتابة نص قصير. تُضاف الأسعار الإضافية إلى المجموع.';

  @override
  String get noOptions => 'لا توجد خيارات. هذا ممكن: يطلب الزبون الكمية فقط.';

  @override
  String get addOptionGroup => 'إضافة مجموعة خيارات';

  @override
  String get editOptionGroup => 'تعديل مجموعة الخيارات';

  @override
  String maxChars(int n) {
    return '$n حرفًا كحد أقصى';
  }

  @override
  String get optionSingle => 'اختيار واحد';

  @override
  String get optionMultiple => 'عدة اختيارات';

  @override
  String get optionColour => 'لون';

  @override
  String get optionText => 'نص قصير';

  @override
  String get choiceName => 'الاختيار';

  @override
  String get removeChoice => 'حذف الاختيار';

  @override
  String get extraPrice => 'سعر إضافي (اختياري)';

  @override
  String get perOrder => 'لكل طلبية';

  @override
  String perUnitLabel(String unit) {
    return 'لكل $unit';
  }

  @override
  String swatchN(int n) {
    return 'اللون $n';
  }

  @override
  String get optionGroupName => 'اسم المجموعة';

  @override
  String get optionGroupNameHelper => 'مثلًا: الحجم، النكهة، الاسم على الكعكة';

  @override
  String get optionTypeLabel => 'النوع';

  @override
  String get optionRequired => 'إلزامي';

  @override
  String get optionRequiredHint => 'لا يمكن للزبون المتابعة دون اختيار.';

  @override
  String get textOptionHint =>
      'يكتب الزبون نصًا قصيرًا، مثل اسم على الكعكة. أرقام الهاتف والروابط ممنوعة.';

  @override
  String get maxLengthLabel => 'الطول الأقصى';

  @override
  String get choices => 'الاختيارات';

  @override
  String get addChoice => 'إضافة اختيار';

  @override
  String get storePending => 'قيد التحقق';

  @override
  String get storeRejected => 'مرفوض';

  @override
  String get logOut => 'تسجيل الخروج';

  @override
  String get storeApproved => 'تمت الموافقة على متجرك. يمكنك الآن نشر منتجاتك.';

  @override
  String get storeRejectedNotice =>
      'لم نتمكن من التحقق من متجرك. افتحي الرئيسية لمعرفة السبب.';

  @override
  String get noticeNewOrder => 'طلبية جديدة';

  @override
  String get noticeLowStock => 'المخزون منخفض';

  @override
  String get noticeReview => 'تقييم جديد';

  @override
  String get noticeStrike => 'حصلتِ على إنذار';

  @override
  String get noticeSuspended => 'تم تعليق متجرك';

  @override
  String get noticeSuspendedBody => 'منتجاتك مخفية لمدة 7 أيام.';

  @override
  String clientIn(String commune, String detail) {
    return 'زبون في $commune · $detail';
  }

  @override
  String get commissionLine => 'عمولة Kavza';

  @override
  String get deliveryDeductedLine => 'التوصيل المجاني (يُخصم منك)';

  @override
  String get netEarnings => 'صافي أرباحك';

  @override
  String ordersNew(int n) {
    return 'جديدة ($n)';
  }

  @override
  String ordersInProgress(int n) {
    return 'قيد التنفيذ ($n)';
  }

  @override
  String get ordersHistory => 'السجل';

  @override
  String get noNewOrders => 'لا توجد طلبيات جديدة';

  @override
  String get noNewOrdersHint => 'تظهر هنا الطلبيات التي تنتظر ردك.';

  @override
  String get noOrdersInProgress => 'لا توجد طلبيات قيد التنفيذ';

  @override
  String get noOrdersInProgressHint =>
      'تبقى الطلبيات المقبولة هنا حتى تسليمها.';

  @override
  String get noOrderHistory => 'السجل فارغ';

  @override
  String get noOrderHistoryHint =>
      'تظهر هنا الطلبيات المسلّمة والمرفوضة والملغاة.';

  @override
  String storeMoneyPlaced(String total) {
    return '$total ما زال في Yassir Cash الخاص بالزبون. يُقتطع عند قبولك.';
  }

  @override
  String storeMoneyHeld(String total) {
    return 'تم تأكيد الطلبية، الدفع مضمون. تحتفظ Kavza بمبلغ $total حتى التسليم.';
  }

  @override
  String storeMoneyPaid(String amount) {
    return 'تم التسليم. أُضيف $amount إلى أرباحك.';
  }

  @override
  String get storeMoneyDisputed => 'أبلغ الزبون عن مشكلة. Kavza تراجعها.';

  @override
  String get storePaymentFailed =>
      'فشل الدفع: رصيد الزبون غير كافٍ. عاد المخزون، ولا إنذار.';

  @override
  String get storeMoneyDeclined =>
      'رفضتِ الطلبية. لم يُقتطع شيء من الزبون، ولا إنذار.';

  @override
  String get storeMoneyExpired =>
      'انتهت مهلة هذه الطلبية. لم يُقتطع شيء، ولا إنذار.';

  @override
  String get storeMoneyCancelledByClient =>
      'ألغى الزبون الطلبية قبل ردك. لم يُقتطع شيء.';

  @override
  String storeMoneyCancelled(String total) {
    return 'أُلغيت. استرجع الزبون $total كاملًا، وحصلتِ على إنذار.';
  }

  @override
  String storeDeliveryFailedPaid(String amount) {
    return 'فشل التوصيل. المنتج حسب الطلب، لذا تحصلين على $amount.';
  }

  @override
  String get storeDeliveryFailedRefund =>
      'فشل التوصيل. عاد المنتج إلى مخزونك، واسترجع الزبون ماله دون رسوم التوصيل.';

  @override
  String get orderCancelledStrike => 'أُلغيت الطلبية واسترجع الزبون ماله.';

  @override
  String get orderDeclined => 'رُفضت الطلبية.';

  @override
  String get markReadyTitle => 'هل الطلبية جاهزة؟';

  @override
  String get markReadyBody =>
      'سيأتي مندوب Yassir Express لاستلامها من نقطة الاستلام الخاصة بك.';

  @override
  String get ready => 'جاهزة';

  @override
  String get accept => 'قبول';

  @override
  String get decline => 'رفض';

  @override
  String get securingPayment => 'جارٍ تأمين الدفع…';

  @override
  String get startPreparation => 'بدء التحضير';

  @override
  String get markReady => 'جاهزة للاستلام';

  @override
  String answerBefore(String time) {
    return 'ردّي قبل $time، وإلا تنتهي مهلتها دون إنذار.';
  }

  @override
  String get waitingCourier => 'في انتظار المندوب';

  @override
  String get waitingCourierBody =>
      'طُلب مندوب Yassir Express. جهّزي الطلبية عند نقطة الاستلام.';

  @override
  String get courierOnTheWay => 'في الطريق مع Yassir Express';

  @override
  String get courierOnTheWayBody => 'تُضاف أرباحك عند التسليم.';

  @override
  String deliveredToCommune(String commune) {
    return 'التوصيل إلى $commune';
  }

  @override
  String get yourEarnings => 'أرباحك';

  @override
  String clientPays(String total) {
    return 'يدفع الزبون $total.';
  }

  @override
  String get cancelOrderStoreTitle => 'إلغاء طلبية مقبولة';

  @override
  String get declineTitle => 'رفض الطلبية';

  @override
  String cancelStrikeWarning(int n, int max) {
    return 'يسترجع الزبون ماله كاملًا وتحصلين على إنذار ($n من $max). عند $max إنذارات يُعلَّق متجرك 7 أيام.';
  }

  @override
  String get declineBody => 'لا يُقتطع شيء من الزبون ويعود المخزون. لا إنذار.';

  @override
  String get reasonTitle => 'السبب';

  @override
  String get reasonOutOfStock => 'نفد المنتج';

  @override
  String get reasonNoTime => 'لا أستطيع تحضيرها في الوقت';

  @override
  String get reasonDate => 'التاريخ غير مناسب';

  @override
  String get reasonOther => 'سبب آخر';

  @override
  String get reasonDetails => 'اشرحي السبب';

  @override
  String get reasonDetailsHelper => 'يراه الزبون. دون رقم أو رابط.';

  @override
  String get cancelWithStrike => 'إلغاء مع إنذار';

  @override
  String get storeOpen => 'مفتوح';

  @override
  String get storeSuspended => 'معلّق';

  @override
  String suspendedBanner(String date) {
    return 'متجرك معلّق حتى $date: منتجاتك مخفية ولا تصلك طلبيات جديدة. واصلي الطلبيات المقبولة كالمعتاد.';
  }

  @override
  String strikeStanding(int n, int max) {
    return '$n من $max إنذارات قبل تعليق لمدة 7 أيام';
  }

  @override
  String get availableBalance => 'الرصيد المتاح';

  @override
  String get todayOrders => 'طلبيات اليوم';

  @override
  String needsAnswer(int n) {
    return 'تنتظر ردك ($n)';
  }

  @override
  String get needsAnswerEmpty => 'لا شيء ينتظر. تظهر الطلبيات الجديدة هنا.';

  @override
  String get lowStockTitle => 'مخزون منخفض';

  @override
  String onHold(String amount) {
    return 'قيد الانتظار: $amount';
  }

  @override
  String get onHoldHint => 'أرباح الطلبيات المقبولة، تُضاف عند التسليم.';

  @override
  String get addCcpFirst => 'أضيفي حساب CCP في ملف المتجر لسحب أرباحك.';

  @override
  String withdrawMinimum(String amount) {
    return 'الحد الأدنى للسحب $amount.';
  }

  @override
  String withdrawMax(String amount) {
    return 'لا يمكنك سحب أكثر من $amount.';
  }

  @override
  String withdrawTo(String account) {
    return 'إلى حساب CCP $account';
  }

  @override
  String get perOrderTitle => 'حسب الطلبية';

  @override
  String get noEarningsYet => 'تظهر الأرباح هنا بعد أول تسليم.';

  @override
  String get withdrawalsTitle => 'عمليات السحب';

  @override
  String get noWithdrawals => 'لا توجد عمليات سحب بعد.';

  @override
  String get withdrawalRequested => 'قيد المعالجة';

  @override
  String get withdrawalSent => 'تم الإرسال';

  @override
  String get withdrawalFailed => 'فشل';

  @override
  String get withdraw => 'سحب';

  @override
  String get withdrawAmount => 'المبلغ';

  @override
  String availableAmount(String amount) {
    return 'متاح: $amount';
  }

  @override
  String withdrawConfirm(String amount) {
    return 'سحب $amount';
  }

  @override
  String withdrawDone(String amount) {
    return 'تم طلب سحب $amount.';
  }

  @override
  String get reportReviewTitle => 'الإبلاغ عن هذا التقييم؟';

  @override
  String get reportReviewBody => 'ستراجعه Kavza. يبقى ظاهرًا حتى قرارها.';

  @override
  String get reportReview => 'إبلاغ';

  @override
  String get reviewReported => 'تم الإبلاغ عن التقييم.';

  @override
  String get reviewReportedBadge => 'مُبلَّغ عنه';

  @override
  String get reviewsTitle => 'التقييمات';

  @override
  String reviewCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n تقييم',
      few: '$n تقييمات',
      two: 'تقييمان',
      one: 'تقييم واحد',
    );
    return '$_temp0';
  }

  @override
  String get reviewsNoReply =>
      'لا يمكن الرد على التقييمات. إن كان أحدها غير لائق، أبلغي Kavza.';

  @override
  String get strikesTitle => 'الإنذارات';

  @override
  String get strikesHow =>
      'يُضاف إنذار عند إلغاء طلبية بعد قبولها. عند 3 إنذارات يُعلَّق المتجر 7 أيام. الرفض قبل القبول وانتهاء المهلة لا يُحتسبان.';

  @override
  String get strikesListTitle => 'إنذاراتك';

  @override
  String get noStrikes => 'لا توجد إنذارات.';

  @override
  String get appeal => 'طعن';

  @override
  String get appealSent => 'الطعن قيد المراجعة';

  @override
  String get appealTitle => 'الطعن في الإنذار';

  @override
  String get appealBody => 'اشرحي ما حدث. تراجع Kavza طعنك وتردّ عليك هنا.';

  @override
  String get appealText => 'ما حدث';

  @override
  String get appealAttachment => 'مرفقات (غير متاحة في النموذج)';

  @override
  String get appealDone => 'أُرسل الطعن.';

  @override
  String get sendAppeal => 'إرسال الطعن';

  @override
  String get noNotifications => 'لا توجد إشعارات';

  @override
  String get noNotificationsHint =>
      'تظهر هنا الطلبيات الجديدة والتقييمات والتنبيهات.';

  @override
  String get storeFaqPaidQ => 'متى أحصل على أرباحي؟';

  @override
  String get storeFaqPaidA =>
      'عند قبولك، يُقتطع المبلغ من الزبون وتحتفظ به Kavza. عند التسليم تُضاف أرباحك: ثمن المنتجات ناقص العمولة، وناقص رسوم التوصيل إن كان التوصيل مجانيًا.';

  @override
  String get storeFaqAcceptQ => 'ماذا يحدث عند قبول طلبية؟';

  @override
  String get storeFaqAcceptA =>
      'تؤمّن Kavza الدفع فورًا. إن كان رصيد الزبون غير كافٍ، تُلغى الطلبية ويعود المخزون، دون أي إنذار لكِ.';

  @override
  String get storeFaqStrikesQ => 'كيف تعمل الإنذارات؟';

  @override
  String get storeFaqWithdrawQ => 'كيف أسحب أرباحي؟';

  @override
  String storeFaqWithdrawA(String amount) {
    return 'من تبويب الأرباح، إلى حساب CCP المسجّل في ملف المتجر. الحد الأدنى $amount.';
  }

  @override
  String get storeFaqContactQ => 'لماذا لا أستطيع التواصل مع الزبون؟';

  @override
  String get storeFaqContactA =>
      'لحماية الجميع، يمر كل شيء عبر Kavza: الدفع والتوصيل والمساعدة. لا تظهر لكِ إلا بلدية الزبون، والأرقام والروابط ممنوعة في كل النصوص.';

  @override
  String get storeSupportLine => 'سؤال آخر؟ فريق دعم Kavza يرد خلال 24 ساعة.';
}
