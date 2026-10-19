import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('fr'),
  ];

  /// No description provided for @appName.
  ///
  /// In ar, this message translates to:
  /// **'Kavza'**
  String get appName;

  /// No description provided for @byYassir.
  ///
  /// In ar, this message translates to:
  /// **'by Yassir'**
  String get byYassir;

  /// No description provided for @currency.
  ///
  /// In ar, this message translates to:
  /// **'د.ج'**
  String get currency;

  /// No description provided for @launcherTitle.
  ///
  /// In ar, this message translates to:
  /// **'نموذج أولي'**
  String get launcherTitle;

  /// No description provided for @launcherSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'اختر ما تريد عرضه. التطبيقان يتشاركان نفس البيانات.'**
  String get launcherSubtitle;

  /// No description provided for @clientApp.
  ///
  /// In ar, this message translates to:
  /// **'تطبيق الزبون'**
  String get clientApp;

  /// No description provided for @clientAppHint.
  ///
  /// In ar, this message translates to:
  /// **'Kavza داخل تطبيق Yassir'**
  String get clientAppHint;

  /// No description provided for @storeApp.
  ///
  /// In ar, this message translates to:
  /// **'تطبيق Kavza Store'**
  String get storeApp;

  /// No description provided for @storeAppHint.
  ///
  /// In ar, this message translates to:
  /// **'تطبيق صاحبات المتاجر'**
  String get storeAppHint;

  /// No description provided for @sideBySide.
  ///
  /// In ar, this message translates to:
  /// **'جنبًا إلى جنب'**
  String get sideBySide;

  /// No description provided for @sideBySideHint.
  ///
  /// In ar, this message translates to:
  /// **'الزبون والمتجر معًا على شاشة واحدة'**
  String get sideBySideHint;

  /// No description provided for @language.
  ///
  /// In ar, this message translates to:
  /// **'اللغة'**
  String get language;

  /// No description provided for @langAr.
  ///
  /// In ar, this message translates to:
  /// **'العربية'**
  String get langAr;

  /// No description provided for @langFr.
  ///
  /// In ar, this message translates to:
  /// **'Français'**
  String get langFr;

  /// No description provided for @backToLauncher.
  ///
  /// In ar, this message translates to:
  /// **'العودة إلى القائمة'**
  String get backToLauncher;

  /// No description provided for @cancel.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء'**
  String get cancel;

  /// No description provided for @statusPlaced.
  ///
  /// In ar, this message translates to:
  /// **'تم الطلب'**
  String get statusPlaced;

  /// No description provided for @statusAccepted.
  ///
  /// In ar, this message translates to:
  /// **'مقبولة'**
  String get statusAccepted;

  /// No description provided for @statusInPreparation.
  ///
  /// In ar, this message translates to:
  /// **'قيد التحضير'**
  String get statusInPreparation;

  /// No description provided for @statusReady.
  ///
  /// In ar, this message translates to:
  /// **'جاهزة'**
  String get statusReady;

  /// No description provided for @statusPickedUp.
  ///
  /// In ar, this message translates to:
  /// **'استلمها المندوب'**
  String get statusPickedUp;

  /// No description provided for @statusDelivered.
  ///
  /// In ar, this message translates to:
  /// **'تم التسليم'**
  String get statusDelivered;

  /// No description provided for @statusCancelledByClient.
  ///
  /// In ar, this message translates to:
  /// **'ألغاها الزبون'**
  String get statusCancelledByClient;

  /// No description provided for @statusDeclined.
  ///
  /// In ar, this message translates to:
  /// **'رفضها المتجر'**
  String get statusDeclined;

  /// No description provided for @statusExpired.
  ///
  /// In ar, this message translates to:
  /// **'انتهت المهلة'**
  String get statusExpired;

  /// No description provided for @statusPaymentFailed.
  ///
  /// In ar, this message translates to:
  /// **'فشل الدفع'**
  String get statusPaymentFailed;

  /// No description provided for @statusCancelledAfterAcceptance.
  ///
  /// In ar, this message translates to:
  /// **'أُلغيت بعد القبول'**
  String get statusCancelledAfterAcceptance;

  /// No description provided for @statusDeliveryFailed.
  ///
  /// In ar, this message translates to:
  /// **'فشل التسليم'**
  String get statusDeliveryFailed;

  /// No description provided for @statusDisputed.
  ///
  /// In ar, this message translates to:
  /// **'قيد المراجعة'**
  String get statusDisputed;

  /// No description provided for @demoPanel.
  ///
  /// In ar, this message translates to:
  /// **'لوحة العرض'**
  String get demoPanel;

  /// No description provided for @demoPanelHint.
  ///
  /// In ar, this message translates to:
  /// **'تحلّ محلّ الإدارة و Yassir Express أثناء العرض.'**
  String get demoPanelHint;

  /// No description provided for @demoClock.
  ///
  /// In ar, this message translates to:
  /// **'الساعة'**
  String get demoClock;

  /// No description provided for @demoClockNow.
  ///
  /// In ar, this message translates to:
  /// **'الوقت المحاكى: {time}'**
  String demoClockNow(String time);

  /// No description provided for @demoAdd15m.
  ///
  /// In ar, this message translates to:
  /// **'+15 دقيقة'**
  String get demoAdd15m;

  /// No description provided for @demoAdd1h.
  ///
  /// In ar, this message translates to:
  /// **'+1 ساعة'**
  String get demoAdd1h;

  /// No description provided for @demoAdd24h.
  ///
  /// In ar, this message translates to:
  /// **'+24 ساعة'**
  String get demoAdd24h;

  /// No description provided for @demoCourier.
  ///
  /// In ar, this message translates to:
  /// **'أحداث التوصيل'**
  String get demoCourier;

  /// No description provided for @demoCourierEmpty.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد طلبية بانتظار المندوب. حدّد طلبية كـ«جاهزة» في تطبيق المتجر.'**
  String get demoCourierEmpty;

  /// No description provided for @demoStoreReview.
  ///
  /// In ar, this message translates to:
  /// **'مراجعة المتاجر'**
  String get demoStoreReview;

  /// No description provided for @demoStoreReviewEmpty.
  ///
  /// In ar, this message translates to:
  /// **'لا يوجد متجر بانتظار المراجعة.'**
  String get demoStoreReviewEmpty;

  /// No description provided for @demoApprove.
  ///
  /// In ar, this message translates to:
  /// **'قبول'**
  String get demoApprove;

  /// No description provided for @demoReject.
  ///
  /// In ar, this message translates to:
  /// **'رفض'**
  String get demoReject;

  /// No description provided for @demoBalance.
  ///
  /// In ar, this message translates to:
  /// **'رصيد Yassir Cash للزبون'**
  String get demoBalance;

  /// No description provided for @demoBalanceNow.
  ///
  /// In ar, this message translates to:
  /// **'{name} · الرصيد الحالي {amount}'**
  String demoBalanceNow(String name, String amount);

  /// No description provided for @demoBalanceField.
  ///
  /// In ar, this message translates to:
  /// **'الرصيد الجديد'**
  String get demoBalanceField;

  /// No description provided for @demoBalanceSet.
  ///
  /// In ar, this message translates to:
  /// **'تطبيق'**
  String get demoBalanceSet;

  /// No description provided for @demoReset.
  ///
  /// In ar, this message translates to:
  /// **'إعادة ضبط البيانات'**
  String get demoReset;

  /// No description provided for @demoResetHint.
  ///
  /// In ar, this message translates to:
  /// **'يعيد بيانات العرض والساعة إلى البداية.'**
  String get demoResetHint;

  /// No description provided for @demoResetConfirm.
  ///
  /// In ar, this message translates to:
  /// **'إعادة ضبط كل البيانات؟'**
  String get demoResetConfirm;

  /// No description provided for @demoResetBody.
  ///
  /// In ar, this message translates to:
  /// **'ستُحذف الطلبيات والتغييرات التي أُجريت أثناء العرض.'**
  String get demoResetBody;

  /// No description provided for @yassirHello.
  ///
  /// In ar, this message translates to:
  /// **'أهلًا، {name}'**
  String yassirHello(String name);

  /// No description provided for @yassirCash.
  ///
  /// In ar, this message translates to:
  /// **'Yassir Cash'**
  String get yassirCash;

  /// No description provided for @yassirWhatToday.
  ///
  /// In ar, this message translates to:
  /// **'ماذا يمكننا أن نفعل لك؟'**
  String get yassirWhatToday;

  /// No description provided for @yassirRide.
  ///
  /// In ar, this message translates to:
  /// **'رحلة'**
  String get yassirRide;

  /// No description provided for @yassirFood.
  ///
  /// In ar, this message translates to:
  /// **'مطاعم'**
  String get yassirFood;

  /// No description provided for @yassirMarket.
  ///
  /// In ar, this message translates to:
  /// **'سوبرماركت'**
  String get yassirMarket;

  /// No description provided for @yassirNotInDemo.
  ///
  /// In ar, this message translates to:
  /// **'هذه الخدمة ليست ضمن العرض.'**
  String get yassirNotInDemo;

  /// No description provided for @yassirLocation.
  ///
  /// In ar, this message translates to:
  /// **'موقعك الحالي'**
  String get yassirLocation;

  /// No description provided for @yassirParcel.
  ///
  /// In ar, this message translates to:
  /// **'طرود'**
  String get yassirParcel;

  /// No description provided for @yassirSend.
  ///
  /// In ar, this message translates to:
  /// **'إرسال'**
  String get yassirSend;

  /// No description provided for @yassirTopUp.
  ///
  /// In ar, this message translates to:
  /// **'شحن الرصيد'**
  String get yassirTopUp;

  /// No description provided for @deliverToLabel.
  ///
  /// In ar, this message translates to:
  /// **'التوصيل إلى'**
  String get deliverToLabel;

  /// No description provided for @kafza.
  ///
  /// In ar, this message translates to:
  /// **'Kavza'**
  String get kafza;

  /// No description provided for @kafzaTileHint.
  ///
  /// In ar, this message translates to:
  /// **'منتجات منزلية من متاجر قريبة منك'**
  String get kafzaTileHint;

  /// No description provided for @badgeNew.
  ///
  /// In ar, this message translates to:
  /// **'جديد'**
  String get badgeNew;

  /// No description provided for @badgePro.
  ///
  /// In ar, this message translates to:
  /// **'Pro'**
  String get badgePro;

  /// No description provided for @backToYassir.
  ///
  /// In ar, this message translates to:
  /// **'العودة إلى Yassir'**
  String get backToYassir;

  /// No description provided for @notifications.
  ///
  /// In ar, this message translates to:
  /// **'الإشعارات'**
  String get notifications;

  /// No description provided for @help.
  ///
  /// In ar, this message translates to:
  /// **'المساعدة'**
  String get help;

  /// No description provided for @tabHome.
  ///
  /// In ar, this message translates to:
  /// **'الرئيسية'**
  String get tabHome;

  /// No description provided for @tabSearch.
  ///
  /// In ar, this message translates to:
  /// **'البحث'**
  String get tabSearch;

  /// No description provided for @tabOrders.
  ///
  /// In ar, this message translates to:
  /// **'طلبياتي'**
  String get tabOrders;

  /// No description provided for @tabFavourites.
  ///
  /// In ar, this message translates to:
  /// **'المفضلة'**
  String get tabFavourites;

  /// No description provided for @chooseAddress.
  ///
  /// In ar, this message translates to:
  /// **'عنوان التوصيل'**
  String get chooseAddress;

  /// No description provided for @searchHint.
  ///
  /// In ar, this message translates to:
  /// **'ابحث عن منتج أو متجر'**
  String get searchHint;

  /// No description provided for @waitingBanner.
  ///
  /// In ar, this message translates to:
  /// **'بانتظار رد المتجر · بقي {time}'**
  String waitingBanner(String time);

  /// No description provided for @servicesTitle.
  ///
  /// In ar, this message translates to:
  /// **'الخدمات'**
  String get servicesTitle;

  /// No description provided for @categoriesTitle.
  ///
  /// In ar, this message translates to:
  /// **'الفئات'**
  String get categoriesTitle;

  /// No description provided for @nearbyStores.
  ///
  /// In ar, this message translates to:
  /// **'متاجر قريبة منك'**
  String get nearbyStores;

  /// No description provided for @newProducts.
  ///
  /// In ar, this message translates to:
  /// **'وصل حديثًا'**
  String get newProducts;

  /// No description provided for @popularProducts.
  ///
  /// In ar, this message translates to:
  /// **'الأكثر طلبًا'**
  String get popularProducts;

  /// No description provided for @serviceCooking.
  ///
  /// In ar, this message translates to:
  /// **'الطبخ'**
  String get serviceCooking;

  /// No description provided for @serviceSewing.
  ///
  /// In ar, this message translates to:
  /// **'الخياطة'**
  String get serviceSewing;

  /// No description provided for @serviceCrafts.
  ///
  /// In ar, this message translates to:
  /// **'الحرف اليدوية'**
  String get serviceCrafts;

  /// No description provided for @categoryTraditionalFood.
  ///
  /// In ar, this message translates to:
  /// **'أطباق تقليدية'**
  String get categoryTraditionalFood;

  /// No description provided for @categoryTraditionalSweets.
  ///
  /// In ar, this message translates to:
  /// **'حلويات تقليدية'**
  String get categoryTraditionalSweets;

  /// No description provided for @categoryCakes.
  ///
  /// In ar, this message translates to:
  /// **'كعك وحلويات'**
  String get categoryCakes;

  /// No description provided for @categoryBreads.
  ///
  /// In ar, this message translates to:
  /// **'خبز ومطلوع'**
  String get categoryBreads;

  /// No description provided for @categoryTraditionalClothing.
  ///
  /// In ar, this message translates to:
  /// **'ألبسة تقليدية'**
  String get categoryTraditionalClothing;

  /// No description provided for @categoryChildrenClothing.
  ///
  /// In ar, this message translates to:
  /// **'ملابس الأطفال'**
  String get categoryChildrenClothing;

  /// No description provided for @categoryPottery.
  ///
  /// In ar, this message translates to:
  /// **'الفخار'**
  String get categoryPottery;

  /// No description provided for @categoryRugs.
  ///
  /// In ar, this message translates to:
  /// **'الزرابي'**
  String get categoryRugs;

  /// No description provided for @categoryBaskets.
  ///
  /// In ar, this message translates to:
  /// **'السلال'**
  String get categoryBaskets;

  /// No description provided for @categoryJewellery.
  ///
  /// In ar, this message translates to:
  /// **'المجوهرات'**
  String get categoryJewellery;

  /// No description provided for @unitPiece.
  ///
  /// In ar, this message translates to:
  /// **'قطعة'**
  String get unitPiece;

  /// No description provided for @unitKg.
  ///
  /// In ar, this message translates to:
  /// **'كغ'**
  String get unitKg;

  /// No description provided for @unitBox.
  ///
  /// In ar, this message translates to:
  /// **'علبة'**
  String get unitBox;

  /// No description provided for @unitPortion.
  ///
  /// In ar, this message translates to:
  /// **'حصة'**
  String get unitPortion;

  /// No description provided for @qtyPiece.
  ///
  /// In ar, this message translates to:
  /// **'{n, plural, =1{قطعة واحدة} =2{قطعتان} few{{n} قطع} other{{n} قطعة}}'**
  String qtyPiece(num n);

  /// No description provided for @qtyKg.
  ///
  /// In ar, this message translates to:
  /// **'{n} كغ'**
  String qtyKg(num n);

  /// No description provided for @qtyBox.
  ///
  /// In ar, this message translates to:
  /// **'{n, plural, =1{علبة واحدة} =2{علبتان} few{{n} علب} other{{n} علبة}}'**
  String qtyBox(num n);

  /// No description provided for @qtyPortion.
  ///
  /// In ar, this message translates to:
  /// **'{n, plural, =1{حصة واحدة} =2{حصتان} few{{n} حصص} other{{n} حصة}}'**
  String qtyPortion(num n);

  /// No description provided for @pricePerUnit.
  ///
  /// In ar, this message translates to:
  /// **'{price} / {unit}'**
  String pricePerUnit(String price, String unit);

  /// No description provided for @communeDistance.
  ///
  /// In ar, this message translates to:
  /// **'{commune} · ≈ {km} كم'**
  String communeDistance(String commune, String km);

  /// No description provided for @storeDistance.
  ///
  /// In ar, this message translates to:
  /// **'{store} · ≈ {km} كم'**
  String storeDistance(String store, String km);

  /// No description provided for @notTakingOrders.
  ///
  /// In ar, this message translates to:
  /// **'لا يستقبل طلبيات حاليًا'**
  String get notTakingOrders;

  /// No description provided for @currentlyUnavailable.
  ///
  /// In ar, this message translates to:
  /// **'غير متوفر حاليًا'**
  String get currentlyUnavailable;

  /// No description provided for @fewLeft.
  ///
  /// In ar, this message translates to:
  /// **'بقيت كمية قليلة'**
  String get fewLeft;

  /// No description provided for @freeDelivery.
  ///
  /// In ar, this message translates to:
  /// **'توصيل مجاني'**
  String get freeDelivery;

  /// No description provided for @ingredients.
  ///
  /// In ar, this message translates to:
  /// **'المكونات'**
  String get ingredients;

  /// No description provided for @readyMadeTitle.
  ///
  /// In ar, this message translates to:
  /// **'منتج جاهز'**
  String get readyMadeTitle;

  /// No description provided for @madeToOrderTitle.
  ///
  /// In ar, this message translates to:
  /// **'حسب الطلب'**
  String get madeToOrderTitle;

  /// No description provided for @inStock.
  ///
  /// In ar, this message translates to:
  /// **'متوفر: {qty}'**
  String inStock(String qty);

  /// No description provided for @outOfStock.
  ///
  /// In ar, this message translates to:
  /// **'نفد المخزون'**
  String get outOfStock;

  /// No description provided for @readyIn.
  ///
  /// In ar, this message translates to:
  /// **'جاهز خلال {time}'**
  String readyIn(String time);

  /// No description provided for @preparedIn.
  ///
  /// In ar, this message translates to:
  /// **'مدة التحضير {time}'**
  String preparedIn(String time);

  /// No description provided for @ruleMin.
  ///
  /// In ar, this message translates to:
  /// **'الحد الأدنى {qty}'**
  String ruleMin(String qty);

  /// No description provided for @ruleStep.
  ///
  /// In ar, this message translates to:
  /// **'بمضاعفات {qty}'**
  String ruleStep(String qty);

  /// No description provided for @ruleMax.
  ///
  /// In ar, this message translates to:
  /// **'الحد الأقصى {qty}'**
  String ruleMax(String qty);

  /// No description provided for @ruleLead.
  ///
  /// In ar, this message translates to:
  /// **'اطلب قبل {time} على الأقل'**
  String ruleLead(String time);

  /// No description provided for @ruleDays.
  ///
  /// In ar, this message translates to:
  /// **'التوصيل أيام {days}'**
  String ruleDays(String days);

  /// No description provided for @ruleEveryDay.
  ///
  /// In ar, this message translates to:
  /// **'التوصيل كل يوم'**
  String get ruleEveryDay;

  /// No description provided for @ruleOptions.
  ///
  /// In ar, this message translates to:
  /// **'اختيارات: {groups}'**
  String ruleOptions(String groups);

  /// No description provided for @listSeparator.
  ///
  /// In ar, this message translates to:
  /// **'، '**
  String get listSeparator;

  /// No description provided for @photoOf.
  ///
  /// In ar, this message translates to:
  /// **'الصورة {index} من {total}'**
  String photoOf(int index, int total);

  /// No description provided for @ratingSemantics.
  ///
  /// In ar, this message translates to:
  /// **'التقييم {average} من 5، عدد التقييمات {count}'**
  String ratingSemantics(String average, int count);

  /// No description provided for @starsSemantics.
  ///
  /// In ar, this message translates to:
  /// **'{stars} من 5 نجوم'**
  String starsSemantics(int stars);

  /// No description provided for @durationMinutes.
  ///
  /// In ar, this message translates to:
  /// **'{m} د'**
  String durationMinutes(int m);

  /// No description provided for @durationHours.
  ///
  /// In ar, this message translates to:
  /// **'{h} س'**
  String durationHours(int h);

  /// No description provided for @durationHoursMinutes.
  ///
  /// In ar, this message translates to:
  /// **'{h} س {m} د'**
  String durationHoursMinutes(int h, int m);

  /// No description provided for @durationDays.
  ///
  /// In ar, this message translates to:
  /// **'{n, plural, =1{يوم واحد} =2{يومان} few{{n} أيام} other{{n} يومًا}}'**
  String durationDays(int n);

  /// No description provided for @orderNow.
  ///
  /// In ar, this message translates to:
  /// **'اطلب الآن'**
  String get orderNow;

  /// No description provided for @orderMadeForMe.
  ///
  /// In ar, this message translates to:
  /// **'اطلب تحضيره لي'**
  String get orderMadeForMe;

  /// No description provided for @outOfStockHint.
  ///
  /// In ar, this message translates to:
  /// **'نفد المخزون، ولا يُصنع هذا المنتج حسب الطلب.'**
  String get outOfStockHint;

  /// No description provided for @productPausedHint.
  ///
  /// In ar, this message translates to:
  /// **'أوقف المتجر هذا المنتج مؤقتًا.'**
  String get productPausedHint;

  /// No description provided for @share.
  ///
  /// In ar, this message translates to:
  /// **'مشاركة'**
  String get share;

  /// No description provided for @linkCopied.
  ///
  /// In ar, this message translates to:
  /// **'تم نسخ الرابط'**
  String get linkCopied;

  /// No description provided for @addFavourite.
  ///
  /// In ar, this message translates to:
  /// **'إضافة إلى المفضلة'**
  String get addFavourite;

  /// No description provided for @removeFavourite.
  ///
  /// In ar, this message translates to:
  /// **'إزالة من المفضلة'**
  String get removeFavourite;

  /// No description provided for @reliability.
  ///
  /// In ar, this message translates to:
  /// **'{percent} من الطلبيات سُلّمت'**
  String reliability(String percent);

  /// No description provided for @serviceRating.
  ///
  /// In ar, this message translates to:
  /// **'{service}: ‎{stars}/5'**
  String serviceRating(String service, String stars);

  /// No description provided for @pausedStoreHint.
  ///
  /// In ar, this message translates to:
  /// **'ستظهر منتجاته عندما يستأنف نشاطه.'**
  String get pausedStoreHint;

  /// No description provided for @noProducts.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد منتجات حاليًا'**
  String get noProducts;

  /// No description provided for @noProductsHint.
  ///
  /// In ar, this message translates to:
  /// **'عد لاحقًا لرؤية الجديد.'**
  String get noProductsHint;

  /// No description provided for @noReviews.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد تقييمات بعد'**
  String get noReviews;

  /// No description provided for @noReviewsHint.
  ///
  /// In ar, this message translates to:
  /// **'تظهر التقييمات بعد أولى الطلبيات المسلّمة.'**
  String get noReviewsHint;

  /// No description provided for @tabProductsCount.
  ///
  /// In ar, this message translates to:
  /// **'المنتجات ({n})'**
  String tabProductsCount(int n);

  /// No description provided for @tabStoresCount.
  ///
  /// In ar, this message translates to:
  /// **'المتاجر ({n})'**
  String tabStoresCount(int n);

  /// No description provided for @tabReviewsCount.
  ///
  /// In ar, this message translates to:
  /// **'التقييمات ({n})'**
  String tabReviewsCount(int n);

  /// No description provided for @noResults.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد نتائج'**
  String get noResults;

  /// No description provided for @noResultsHint.
  ///
  /// In ar, this message translates to:
  /// **'جرّب كلمة أخرى أو أزل بعض الفلاتر.'**
  String get noResultsHint;

  /// No description provided for @clearFilters.
  ///
  /// In ar, this message translates to:
  /// **'إزالة الفلاتر'**
  String get clearFilters;

  /// No description provided for @clearSearch.
  ///
  /// In ar, this message translates to:
  /// **'مسح البحث'**
  String get clearSearch;

  /// No description provided for @removeFilter.
  ///
  /// In ar, this message translates to:
  /// **'إزالة'**
  String get removeFilter;

  /// No description provided for @recentSearches.
  ///
  /// In ar, this message translates to:
  /// **'عمليات البحث الأخيرة'**
  String get recentSearches;

  /// No description provided for @clear.
  ///
  /// In ar, this message translates to:
  /// **'مسح'**
  String get clear;

  /// No description provided for @filters.
  ///
  /// In ar, this message translates to:
  /// **'الفلاتر'**
  String get filters;

  /// No description provided for @sortBy.
  ///
  /// In ar, this message translates to:
  /// **'الترتيب'**
  String get sortBy;

  /// No description provided for @sortClosest.
  ///
  /// In ar, this message translates to:
  /// **'الأقرب'**
  String get sortClosest;

  /// No description provided for @sortRating.
  ///
  /// In ar, this message translates to:
  /// **'الأعلى تقييمًا'**
  String get sortRating;

  /// No description provided for @sortPrice.
  ///
  /// In ar, this message translates to:
  /// **'الأقل سعرًا'**
  String get sortPrice;

  /// No description provided for @sortPrepTime.
  ///
  /// In ar, this message translates to:
  /// **'الأسرع تحضيرًا'**
  String get sortPrepTime;

  /// No description provided for @filterWilaya.
  ///
  /// In ar, this message translates to:
  /// **'الولاية'**
  String get filterWilaya;

  /// No description provided for @all.
  ///
  /// In ar, this message translates to:
  /// **'الكل'**
  String get all;

  /// No description provided for @filterAvailability.
  ///
  /// In ar, this message translates to:
  /// **'التوفر'**
  String get filterAvailability;

  /// No description provided for @filterAvailableNow.
  ///
  /// In ar, this message translates to:
  /// **'متوفر الآن'**
  String get filterAvailableNow;

  /// No description provided for @filterMadeToOrder.
  ///
  /// In ar, this message translates to:
  /// **'يُصنع حسب الطلب'**
  String get filterMadeToOrder;

  /// No description provided for @filterMinRating.
  ///
  /// In ar, this message translates to:
  /// **'أدنى تقييم'**
  String get filterMinRating;

  /// No description provided for @filterPrice.
  ///
  /// In ar, this message translates to:
  /// **'السعر'**
  String get filterPrice;

  /// No description provided for @priceRange.
  ///
  /// In ar, this message translates to:
  /// **'{min} – {max}'**
  String priceRange(String min, String max);

  /// No description provided for @reset.
  ///
  /// In ar, this message translates to:
  /// **'إعادة ضبط'**
  String get reset;

  /// No description provided for @showResults.
  ///
  /// In ar, this message translates to:
  /// **'عرض النتائج'**
  String get showResults;

  /// No description provided for @emptyFavourites.
  ///
  /// In ar, this message translates to:
  /// **'لا شيء في المفضلة بعد'**
  String get emptyFavourites;

  /// No description provided for @emptyFavouritesHint.
  ///
  /// In ar, this message translates to:
  /// **'اضغط على القلب في صفحة منتج أو متجر لتجده هنا.'**
  String get emptyFavouritesHint;

  /// No description provided for @browse.
  ///
  /// In ar, this message translates to:
  /// **'تصفّح Kavza'**
  String get browse;

  /// No description provided for @labelValue.
  ///
  /// In ar, this message translates to:
  /// **'{label}: {value}'**
  String labelValue(String label, String value);

  /// No description provided for @decrease.
  ///
  /// In ar, this message translates to:
  /// **'إنقاص'**
  String get decrease;

  /// No description provided for @increase.
  ///
  /// In ar, this message translates to:
  /// **'زيادة'**
  String get increase;

  /// No description provided for @contactPhone.
  ///
  /// In ar, this message translates to:
  /// **'أرقام الهاتف غير مسموح بها.'**
  String get contactPhone;

  /// No description provided for @contactEmail.
  ///
  /// In ar, this message translates to:
  /// **'عناوين البريد الإلكتروني غير مسموح بها.'**
  String get contactEmail;

  /// No description provided for @contactLink.
  ///
  /// In ar, this message translates to:
  /// **'الروابط غير مسموح بها.'**
  String get contactLink;

  /// No description provided for @contactHandle.
  ///
  /// In ar, this message translates to:
  /// **'أسماء الحسابات (@) غير مسموح بها.'**
  String get contactHandle;

  /// No description provided for @contactWord.
  ///
  /// In ar, this message translates to:
  /// **'ذكر واتساب أو إنستغرام أو تطبيقات أخرى غير مسموح به.'**
  String get contactWord;

  /// No description provided for @contactWhy.
  ///
  /// In ar, this message translates to:
  /// **'لحمايتك، يتم كل شيء عبر Kavza.'**
  String get contactWhy;

  /// No description provided for @errorUnavailable.
  ///
  /// In ar, this message translates to:
  /// **'لا يمكن طلب هذا المنتج حاليًا.'**
  String get errorUnavailable;

  /// No description provided for @errorWaitingOrder.
  ///
  /// In ar, this message translates to:
  /// **'لديك طلبية بانتظار رد متجر.'**
  String get errorWaitingOrder;

  /// No description provided for @errorOutOfStock.
  ///
  /// In ar, this message translates to:
  /// **'الكمية المتوفرة لا تكفي. غيّر الكمية.'**
  String get errorOutOfStock;

  /// No description provided for @errorInvalidQty.
  ///
  /// In ar, this message translates to:
  /// **'هذه الكمية غير مسموح بها.'**
  String get errorInvalidQty;

  /// No description provided for @errorMissingOption.
  ///
  /// In ar, this message translates to:
  /// **'اختر الخيارات المطلوبة.'**
  String get errorMissingOption;

  /// No description provided for @errorInvalidOption.
  ///
  /// In ar, this message translates to:
  /// **'أحد الخيارات لم يعد متوفرًا.'**
  String get errorInvalidOption;

  /// No description provided for @errorInvalidDate.
  ///
  /// In ar, this message translates to:
  /// **'هذا التاريخ لم يعد متاحًا. اختر تاريخًا آخر.'**
  String get errorInvalidDate;

  /// No description provided for @errorLowBalance.
  ///
  /// In ar, this message translates to:
  /// **'رصيد Yassir Cash غير كافٍ.'**
  String get errorLowBalance;

  /// No description provided for @errorNotAllowed.
  ///
  /// In ar, this message translates to:
  /// **'لم يعد هذا الإجراء ممكنًا.'**
  String get errorNotAllowed;

  /// No description provided for @timeLeft.
  ///
  /// In ar, this message translates to:
  /// **'بقي {time}'**
  String timeLeft(String time);

  /// No description provided for @optionsLine.
  ///
  /// In ar, this message translates to:
  /// **'الخيارات'**
  String get optionsLine;

  /// No description provided for @deliveryFeeLine.
  ///
  /// In ar, this message translates to:
  /// **'رسوم التوصيل'**
  String get deliveryFeeLine;

  /// No description provided for @totalLine.
  ///
  /// In ar, this message translates to:
  /// **'المجموع'**
  String get totalLine;

  /// No description provided for @itemsLine.
  ///
  /// In ar, this message translates to:
  /// **'{qty} × {price}'**
  String itemsLine(String qty, String price);

  /// No description provided for @itemsTotal.
  ///
  /// In ar, this message translates to:
  /// **'المنتجات'**
  String get itemsTotal;

  /// No description provided for @quantity.
  ///
  /// In ar, this message translates to:
  /// **'الكمية'**
  String get quantity;

  /// No description provided for @required.
  ///
  /// In ar, this message translates to:
  /// **'إلزامي'**
  String get required;

  /// No description provided for @optional.
  ///
  /// In ar, this message translates to:
  /// **'اختياري'**
  String get optional;

  /// No description provided for @deliveryDate.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ التوصيل'**
  String get deliveryDate;

  /// No description provided for @chooseDate.
  ///
  /// In ar, this message translates to:
  /// **'اختر تاريخًا'**
  String get chooseDate;

  /// No description provided for @etaReadyMade.
  ///
  /// In ar, this message translates to:
  /// **'يصلك بعد حوالي {time} من قبول المتجر.'**
  String etaReadyMade(String time);

  /// No description provided for @etaMadeToOrder.
  ///
  /// In ar, this message translates to:
  /// **'يصلك في التاريخ الذي تختاره.'**
  String get etaMadeToOrder;

  /// No description provided for @toContinue.
  ///
  /// In ar, this message translates to:
  /// **'للمتابعة، اختر: {items}'**
  String toContinue(String items);

  /// No description provided for @continueTotal.
  ///
  /// In ar, this message translates to:
  /// **'متابعة · {total}'**
  String continueTotal(String total);

  /// No description provided for @summaryTitle.
  ///
  /// In ar, this message translates to:
  /// **'ملخص الطلبية'**
  String get summaryTitle;

  /// No description provided for @summaryMoneyNote.
  ///
  /// In ar, this message translates to:
  /// **'لن يُقتطع أي مبلغ الآن. يُقتطع المبلغ من Yassir Cash عندما يقبل المتجر الطلبية.'**
  String get summaryMoneyNote;

  /// No description provided for @placeOrder.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد الطلبية'**
  String get placeOrder;

  /// No description provided for @missingAmount.
  ///
  /// In ar, this message translates to:
  /// **'ينقصك {amount}'**
  String missingAmount(String amount);

  /// No description provided for @rechargeCcp.
  ///
  /// In ar, this message translates to:
  /// **'الشحن عبر CCP'**
  String get rechargeCcp;

  /// No description provided for @waitingTitle.
  ///
  /// In ar, this message translates to:
  /// **'لديك طلبية بانتظار الرد'**
  String get waitingTitle;

  /// No description provided for @waitingBody.
  ///
  /// In ar, this message translates to:
  /// **'يمكن أن تنتظر طلبية واحدة فقط رد المتجر في نفس الوقت.'**
  String get waitingBody;

  /// No description provided for @keepIt.
  ///
  /// In ar, this message translates to:
  /// **'الإبقاء عليها'**
  String get keepIt;

  /// No description provided for @cancelAndPlace.
  ///
  /// In ar, this message translates to:
  /// **'إلغاؤها وتأكيد هذه'**
  String get cancelAndPlace;

  /// No description provided for @rechargeAmount.
  ///
  /// In ar, this message translates to:
  /// **'مبلغ الشحن'**
  String get rechargeAmount;

  /// No description provided for @rechargeMockNote.
  ///
  /// In ar, this message translates to:
  /// **'صفحة Yassir تجريبية: لا يتم أي دفع حقيقي.'**
  String get rechargeMockNote;

  /// No description provided for @rechargeConfirm.
  ///
  /// In ar, this message translates to:
  /// **'شحن {amount}'**
  String rechargeConfirm(String amount);

  /// No description provided for @rechargeDone.
  ///
  /// In ar, this message translates to:
  /// **'تمت إضافة {amount}'**
  String rechargeDone(String amount);

  /// No description provided for @newBalance.
  ///
  /// In ar, this message translates to:
  /// **'رصيدك الجديد: {amount}'**
  String newBalance(String amount);

  /// No description provided for @backToOrder.
  ///
  /// In ar, this message translates to:
  /// **'العودة إلى الطلبية'**
  String get backToOrder;

  /// No description provided for @placedTitle.
  ///
  /// In ar, this message translates to:
  /// **'تم إرسال طلبيتك'**
  String get placedTitle;

  /// No description provided for @orderNumber.
  ///
  /// In ar, this message translates to:
  /// **'طلبية {id}'**
  String orderNumber(String id);

  /// No description provided for @placedDeadline.
  ///
  /// In ar, this message translates to:
  /// **'أمام {store} مهلة {window} للرد (حتى {time}).'**
  String placedDeadline(String store, String window, String time);

  /// No description provided for @placedMoneyNote.
  ///
  /// In ar, this message translates to:
  /// **'لم يُقتطع أي مبلغ بعد. سيُقتطع المبلغ من Yassir Cash عندما يقبل المتجر. إذا لم يكفِ رصيدك حينها، تُلغى الطلبية.'**
  String get placedMoneyNote;

  /// No description provided for @trackOrder.
  ///
  /// In ar, this message translates to:
  /// **'تتبع الطلبية'**
  String get trackOrder;

  /// No description provided for @backToKafza.
  ///
  /// In ar, this message translates to:
  /// **'العودة إلى Kavza'**
  String get backToKafza;

  /// No description provided for @moneyInWallet.
  ///
  /// In ar, this message translates to:
  /// **'{total} لا يزال في Yassir Cash. يُقتطع عند قبول المتجر.'**
  String moneyInWallet(String total);

  /// No description provided for @moneyNothingTaken.
  ///
  /// In ar, this message translates to:
  /// **'لم يُقتطع أي مبلغ من Yassir Cash.'**
  String get moneyNothingTaken;

  /// No description provided for @moneyHeld.
  ///
  /// In ar, this message translates to:
  /// **'دُفع {total}، تحتفظ به Kavza حتى التسليم.'**
  String moneyHeld(String total);

  /// No description provided for @moneyPaid.
  ///
  /// In ar, this message translates to:
  /// **'دُفع {total}.'**
  String moneyPaid(String total);

  /// No description provided for @moneyRefunded.
  ///
  /// In ar, this message translates to:
  /// **'استُرجع {amount} إلى Yassir Cash.'**
  String moneyRefunded(String amount);

  /// No description provided for @moneyUnderReview.
  ///
  /// In ar, this message translates to:
  /// **'دُفع {total}، قيد المراجعة لدى Kavza.'**
  String moneyUnderReview(String total);

  /// No description provided for @ordersCurrent.
  ///
  /// In ar, this message translates to:
  /// **'الحالية ({n})'**
  String ordersCurrent(int n);

  /// No description provided for @ordersPast.
  ///
  /// In ar, this message translates to:
  /// **'السابقة ({n})'**
  String ordersPast(int n);

  /// No description provided for @noCurrentOrders.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد طلبيات جارية'**
  String get noCurrentOrders;

  /// No description provided for @noPastOrders.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد طلبيات سابقة'**
  String get noPastOrders;

  /// No description provided for @noOrdersHint.
  ///
  /// In ar, this message translates to:
  /// **'تظهر طلبياتك هنا بعد تأكيدها.'**
  String get noOrdersHint;

  /// No description provided for @waitingForStore.
  ///
  /// In ar, this message translates to:
  /// **'بانتظار رد المتجر حتى {time}. لم يُقتطع أي مبلغ بعد.'**
  String waitingForStore(String time);

  /// No description provided for @cancelOrder.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء الطلبية'**
  String get cancelOrder;

  /// No description provided for @cancelOrderTitle.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء هذه الطلبية؟'**
  String get cancelOrderTitle;

  /// No description provided for @cancelOrderBody.
  ///
  /// In ar, this message translates to:
  /// **'لم يُقتطع أي مبلغ من Yassir Cash، وسيتم إعلام المتجر.'**
  String get cancelOrderBody;

  /// No description provided for @orderCancelled.
  ///
  /// In ar, this message translates to:
  /// **'أُلغيت الطلبية.'**
  String get orderCancelled;

  /// No description provided for @courierTitle.
  ///
  /// In ar, this message translates to:
  /// **'مندوب Yassir Express في الطريق'**
  String get courierTitle;

  /// No description provided for @courierBody.
  ///
  /// In ar, this message translates to:
  /// **'يوصل طلبيتك إلى {label}.'**
  String courierBody(String label);

  /// No description provided for @orderStatusTitle.
  ///
  /// In ar, this message translates to:
  /// **'حالة الطلبية'**
  String get orderStatusTitle;

  /// No description provided for @orderDetailsTitle.
  ///
  /// In ar, this message translates to:
  /// **'التفاصيل'**
  String get orderDetailsTitle;

  /// No description provided for @deliveryOn.
  ///
  /// In ar, this message translates to:
  /// **'التوصيل يوم {date}'**
  String deliveryOn(String date);

  /// No description provided for @yourReview.
  ///
  /// In ar, this message translates to:
  /// **'تقييمك'**
  String get yourReview;

  /// No description provided for @leaveReview.
  ///
  /// In ar, this message translates to:
  /// **'اترك تقييمًا'**
  String get leaveReview;

  /// No description provided for @reviewComment.
  ///
  /// In ar, this message translates to:
  /// **'تعليق (اختياري)'**
  String get reviewComment;

  /// No description provided for @sendReview.
  ///
  /// In ar, this message translates to:
  /// **'إرسال التقييم'**
  String get sendReview;

  /// No description provided for @reviewThanks.
  ///
  /// In ar, this message translates to:
  /// **'شكرًا على تقييمك.'**
  String get reviewThanks;

  /// No description provided for @reportProblem.
  ///
  /// In ar, this message translates to:
  /// **'الإبلاغ عن مشكلة'**
  String get reportProblem;

  /// No description provided for @reportUntil.
  ///
  /// In ar, this message translates to:
  /// **'يمكنك الإبلاغ حتى {time}.'**
  String reportUntil(String time);

  /// No description provided for @problemReason.
  ///
  /// In ar, this message translates to:
  /// **'ما المشكلة؟'**
  String get problemReason;

  /// No description provided for @problemDamaged.
  ///
  /// In ar, this message translates to:
  /// **'وصل المنتج تالفًا'**
  String get problemDamaged;

  /// No description provided for @problemWrongItem.
  ///
  /// In ar, this message translates to:
  /// **'منتج غير الذي طلبته'**
  String get problemWrongItem;

  /// No description provided for @problemMissingItems.
  ///
  /// In ar, this message translates to:
  /// **'ينقص جزء من الطلبية'**
  String get problemMissingItems;

  /// No description provided for @problemNotAsDescribed.
  ///
  /// In ar, this message translates to:
  /// **'لا يطابق الوصف'**
  String get problemNotAsDescribed;

  /// No description provided for @problemOther.
  ///
  /// In ar, this message translates to:
  /// **'مشكلة أخرى'**
  String get problemOther;

  /// No description provided for @problemDetails.
  ///
  /// In ar, this message translates to:
  /// **'صف المشكلة'**
  String get problemDetails;

  /// No description provided for @problemPhotos.
  ///
  /// In ar, this message translates to:
  /// **'الصور (غير متاحة في النموذج)'**
  String get problemPhotos;

  /// No description provided for @sendReport.
  ///
  /// In ar, this message translates to:
  /// **'إرسال البلاغ'**
  String get sendReport;

  /// No description provided for @problemSent.
  ///
  /// In ar, this message translates to:
  /// **'تم إرسال البلاغ. ستراجعه Kavza.'**
  String get problemSent;

  /// No description provided for @faqTitle.
  ///
  /// In ar, this message translates to:
  /// **'أسئلة شائعة'**
  String get faqTitle;

  /// No description provided for @faqPaymentQ.
  ///
  /// In ar, this message translates to:
  /// **'متى يُقتطع المبلغ؟'**
  String get faqPaymentQ;

  /// No description provided for @faqPaymentA.
  ///
  /// In ar, this message translates to:
  /// **'لا شيء عند تأكيد الطلبية. يُقتطع المبلغ كاملًا من Yassir Cash عندما يقبل المتجر، وتحتفظ به Kavza حتى التسليم. إذا لم يكفِ رصيدك عند القبول، تُلغى الطلبية دون اقتطاع أي شيء.'**
  String get faqPaymentA;

  /// No description provided for @faqCancelQ.
  ///
  /// In ar, this message translates to:
  /// **'هل يمكنني إلغاء طلبية؟'**
  String get faqCancelQ;

  /// No description provided for @faqCancelA.
  ///
  /// In ar, this message translates to:
  /// **'نعم، طالما لم يقبلها المتجر بعد. إذا ألغاها المتجر بعد القبول، يُسترجع المبلغ كاملًا إلى Yassir Cash.'**
  String get faqCancelA;

  /// No description provided for @faqDeliveryQ.
  ///
  /// In ar, this message translates to:
  /// **'من يوصل طلبيتي؟'**
  String get faqDeliveryQ;

  /// No description provided for @faqDeliveryA.
  ///
  /// In ar, this message translates to:
  /// **'يستلمها مندوب Yassir Express من المتجر عندما تصبح جاهزة ويوصلها إلى عنوانك. يمكنك تتبعها في «طلبياتي».'**
  String get faqDeliveryA;

  /// No description provided for @faqMessageQ.
  ///
  /// In ar, this message translates to:
  /// **'لماذا لا يمكنني مراسلة المتجر؟'**
  String get faqMessageQ;

  /// No description provided for @faqMessageA.
  ///
  /// In ar, this message translates to:
  /// **'لحماية الطرفين، يتم كل شيء عبر Kavza: الدفع والتوصيل والمساعدة. لهذا تُمنع أرقام الهاتف والروابط وأسماء الحسابات في كل النصوص. لأي مشكلة، تواصل مع دعم Kavza.'**
  String get faqMessageA;

  /// No description provided for @contactSupport.
  ///
  /// In ar, this message translates to:
  /// **'تواصل مع دعم Kavza'**
  String get contactSupport;

  /// No description provided for @contactSupportHint.
  ///
  /// In ar, this message translates to:
  /// **'يرد الفريق خلال 24 ساعة.'**
  String get contactSupportHint;

  /// No description provided for @supportAbout.
  ///
  /// In ar, this message translates to:
  /// **'الموضوع'**
  String get supportAbout;

  /// No description provided for @supportNoOrder.
  ///
  /// In ar, this message translates to:
  /// **'ليس بخصوص طلبية'**
  String get supportNoOrder;

  /// No description provided for @supportMessage.
  ///
  /// In ar, this message translates to:
  /// **'رسالتك'**
  String get supportMessage;

  /// No description provided for @supportSend.
  ///
  /// In ar, this message translates to:
  /// **'إرسال'**
  String get supportSend;

  /// No description provided for @supportSent.
  ///
  /// In ar, this message translates to:
  /// **'تم إرسال رسالتك. يرد الدعم خلال 24 ساعة.'**
  String get supportSent;

  /// No description provided for @photoTaken.
  ///
  /// In ar, this message translates to:
  /// **'تم التقاط الصورة'**
  String get photoTaken;

  /// No description provided for @cameraCardHint.
  ///
  /// In ar, this message translates to:
  /// **'ضعي البطاقة داخل الإطار'**
  String get cameraCardHint;

  /// No description provided for @cameraFaceHint.
  ///
  /// In ar, this message translates to:
  /// **'ضعي وجهك داخل الدائرة'**
  String get cameraFaceHint;

  /// No description provided for @retake.
  ///
  /// In ar, this message translates to:
  /// **'إعادة الالتقاط'**
  String get retake;

  /// No description provided for @takePhoto.
  ///
  /// In ar, this message translates to:
  /// **'التقاط صورة'**
  String get takePhoto;

  /// No description provided for @proTitle.
  ///
  /// In ar, this message translates to:
  /// **'Kavza Pro'**
  String get proTitle;

  /// No description provided for @proBody.
  ///
  /// In ar, this message translates to:
  /// **'بالخطة المجانية تبيعين في فئة واحدة. مع Pro تبيعين في كل الفئات.'**
  String get proBody;

  /// No description provided for @planFree.
  ///
  /// In ar, this message translates to:
  /// **'مجاني'**
  String get planFree;

  /// No description provided for @planFreePrice.
  ///
  /// In ar, this message translates to:
  /// **'0'**
  String get planFreePrice;

  /// No description provided for @planFreeLine.
  ///
  /// In ar, this message translates to:
  /// **'فئة واحدة'**
  String get planFreeLine;

  /// No description provided for @perMonth.
  ///
  /// In ar, this message translates to:
  /// **'{price} / شهر'**
  String perMonth(String price);

  /// No description provided for @planProLine1.
  ///
  /// In ar, this message translates to:
  /// **'كل الفئات'**
  String get planProLine1;

  /// No description provided for @planProLine2.
  ///
  /// In ar, this message translates to:
  /// **'شارة Pro على متجرك'**
  String get planProLine2;

  /// No description provided for @proActive.
  ///
  /// In ar, this message translates to:
  /// **'Kavza Pro مفعّل في متجرك.'**
  String get proActive;

  /// No description provided for @proShort.
  ///
  /// In ar, this message translates to:
  /// **'يُدفع Pro من أرباحك. رصيدك {balance} لا يكفي بعد.'**
  String proShort(String balance);

  /// No description provided for @proFromBalance.
  ///
  /// In ar, this message translates to:
  /// **'يُقتطع من رصيد أرباحك ({balance}).'**
  String proFromBalance(String balance);

  /// No description provided for @getPro.
  ///
  /// In ar, this message translates to:
  /// **'الاشتراك في Kavza Pro'**
  String get getPro;

  /// No description provided for @welcomeTitle.
  ///
  /// In ar, this message translates to:
  /// **'بيعي ما تصنعينه في البيت'**
  String get welcomeTitle;

  /// No description provided for @welcomeBody.
  ///
  /// In ar, this message translates to:
  /// **'تصلك طلبيات زبائن Yassir. تتكفّل Kavza بالدفع والتوصيل.'**
  String get welcomeBody;

  /// No description provided for @getStarted.
  ///
  /// In ar, this message translates to:
  /// **'ابدئي الآن'**
  String get getStarted;

  /// No description provided for @haveStore.
  ///
  /// In ar, this message translates to:
  /// **'لديّ متجر'**
  String get haveStore;

  /// No description provided for @stepPhone.
  ///
  /// In ar, this message translates to:
  /// **'الهاتف'**
  String get stepPhone;

  /// No description provided for @stepCode.
  ///
  /// In ar, this message translates to:
  /// **'الرمز'**
  String get stepCode;

  /// No description provided for @stepCard.
  ///
  /// In ar, this message translates to:
  /// **'البطاقة'**
  String get stepCard;

  /// No description provided for @stepSelfie.
  ///
  /// In ar, this message translates to:
  /// **'صورة شخصية'**
  String get stepSelfie;

  /// No description provided for @stepOf.
  ///
  /// In ar, this message translates to:
  /// **'الخطوة {n} من {total}: {label}'**
  String stepOf(int n, int total, String label);

  /// No description provided for @phoneTitle.
  ///
  /// In ar, this message translates to:
  /// **'رقم هاتفك'**
  String get phoneTitle;

  /// No description provided for @phoneBody.
  ///
  /// In ar, this message translates to:
  /// **'سنرسل لك رمزًا من 6 أرقام عبر رسالة قصيرة.'**
  String get phoneBody;

  /// No description provided for @phoneLabel.
  ///
  /// In ar, this message translates to:
  /// **'رقم الهاتف المحمول'**
  String get phoneLabel;

  /// No description provided for @phoneHelper.
  ///
  /// In ar, this message translates to:
  /// **'لا يظهر للزبائن أبدًا.'**
  String get phoneHelper;

  /// No description provided for @phoneInvalid.
  ///
  /// In ar, this message translates to:
  /// **'أدخلي رقمًا محمولًا: 5 أو 6 أو 7 ثم 8 أرقام.'**
  String get phoneInvalid;

  /// No description provided for @sendCode.
  ///
  /// In ar, this message translates to:
  /// **'إرسال الرمز'**
  String get sendCode;

  /// No description provided for @otpTitle.
  ///
  /// In ar, this message translates to:
  /// **'أدخلي الرمز'**
  String get otpTitle;

  /// No description provided for @otpBody.
  ///
  /// In ar, this message translates to:
  /// **'أُرسل إلى {phone}.'**
  String otpBody(String phone);

  /// No description provided for @otpDemo.
  ///
  /// In ar, this message translates to:
  /// **'في النموذج، الرمز دائمًا {code}.'**
  String otpDemo(String code);

  /// No description provided for @otpLabel.
  ///
  /// In ar, this message translates to:
  /// **'رمز التحقق من 6 أرقام'**
  String get otpLabel;

  /// No description provided for @otpWrong.
  ///
  /// In ar, this message translates to:
  /// **'الرمز غير صحيح. تحققي من الرسالة وأعيدي المحاولة.'**
  String get otpWrong;

  /// No description provided for @resendIn.
  ///
  /// In ar, this message translates to:
  /// **'إعادة الإرسال بعد {time}'**
  String resendIn(String time);

  /// No description provided for @resendCode.
  ///
  /// In ar, this message translates to:
  /// **'إعادة إرسال الرمز'**
  String get resendCode;

  /// No description provided for @codeSent.
  ///
  /// In ar, this message translates to:
  /// **'تم إرسال رمز جديد.'**
  String get codeSent;

  /// No description provided for @newStoreName.
  ///
  /// In ar, this message translates to:
  /// **'متجري'**
  String get newStoreName;

  /// No description provided for @cardFrontTitle.
  ///
  /// In ar, this message translates to:
  /// **'بطاقة المقاول الذاتي: الوجه'**
  String get cardFrontTitle;

  /// No description provided for @cardBackTitle.
  ///
  /// In ar, this message translates to:
  /// **'بطاقة المقاول الذاتي: الظهر'**
  String get cardBackTitle;

  /// No description provided for @cardPhotoBody.
  ///
  /// In ar, this message translates to:
  /// **'صوّري البطاقة الأصلية الآن. تأكدي أن الكتابة مقروءة.'**
  String get cardPhotoBody;

  /// No description provided for @cardDetailsTitle.
  ///
  /// In ar, this message translates to:
  /// **'رقم البطاقة ونشاطك'**
  String get cardDetailsTitle;

  /// No description provided for @cardDetailsBody.
  ///
  /// In ar, this message translates to:
  /// **'كما هو مكتوب على بطاقة المقاول الذاتي.'**
  String get cardDetailsBody;

  /// No description provided for @cardNumber.
  ///
  /// In ar, this message translates to:
  /// **'رقم البطاقة'**
  String get cardNumber;

  /// No description provided for @cardNumberHelper.
  ///
  /// In ar, this message translates to:
  /// **'تراه Kavza فقط، للتحقق.'**
  String get cardNumberHelper;

  /// No description provided for @cardNumberInvalid.
  ///
  /// In ar, this message translates to:
  /// **'الرقم قصير جدًا: 8 أرقام على الأقل.'**
  String get cardNumberInvalid;

  /// No description provided for @activity.
  ///
  /// In ar, this message translates to:
  /// **'نشاطك'**
  String get activity;

  /// No description provided for @selfieTitle.
  ///
  /// In ar, this message translates to:
  /// **'صورة شخصية مباشرة'**
  String get selfieTitle;

  /// No description provided for @selfieBody.
  ///
  /// In ar, this message translates to:
  /// **'نقارنها بصورة البطاقة. صور المعرض غير مقبولة.'**
  String get selfieBody;

  /// No description provided for @sendForReview.
  ///
  /// In ar, this message translates to:
  /// **'إرسال للتحقق'**
  String get sendForReview;

  /// No description provided for @continueLabel.
  ///
  /// In ar, this message translates to:
  /// **'متابعة'**
  String get continueLabel;

  /// No description provided for @pendingTitle.
  ///
  /// In ar, this message translates to:
  /// **'نتحقق من وثائقك'**
  String get pendingTitle;

  /// No description provided for @pendingBody.
  ///
  /// In ar, this message translates to:
  /// **'يتم التحقق عادة خلال 24 ساعة. ستصلك رسالة هنا.'**
  String get pendingBody;

  /// No description provided for @pendingCanDo.
  ///
  /// In ar, this message translates to:
  /// **'يمكنك الآن'**
  String get pendingCanDo;

  /// No description provided for @pendingCanProfile.
  ///
  /// In ar, this message translates to:
  /// **'تجهيز ملف متجرك: الاسم والوصف والصورة'**
  String get pendingCanProfile;

  /// No description provided for @pendingCanProducts.
  ///
  /// In ar, this message translates to:
  /// **'إضافة منتجاتك، تُحفظ كمسودات'**
  String get pendingCanProducts;

  /// No description provided for @pendingLocked.
  ///
  /// In ar, this message translates to:
  /// **'بعد الموافقة'**
  String get pendingLocked;

  /// No description provided for @pendingLockedPublish.
  ///
  /// In ar, this message translates to:
  /// **'نشر منتجاتك للزبائن'**
  String get pendingLockedPublish;

  /// No description provided for @pendingLockedOrders.
  ///
  /// In ar, this message translates to:
  /// **'استقبال الطلبيات'**
  String get pendingLockedOrders;

  /// No description provided for @rejectedTitle.
  ///
  /// In ar, this message translates to:
  /// **'لم نتمكن من التحقق من متجرك'**
  String get rejectedTitle;

  /// No description provided for @rejectedBody.
  ///
  /// In ar, this message translates to:
  /// **'صوّري بطاقتك من جديد والتقطي صورة شخصية جديدة، ثم أعيدي الإرسال.'**
  String get rejectedBody;

  /// No description provided for @rejectedReason.
  ///
  /// In ar, this message translates to:
  /// **'السبب: صورة البطاقة غير مقروءة.'**
  String get rejectedReason;

  /// No description provided for @resubmit.
  ///
  /// In ar, this message translates to:
  /// **'إعادة الإرسال'**
  String get resubmit;

  /// No description provided for @addProduct.
  ///
  /// In ar, this message translates to:
  /// **'إضافة منتج'**
  String get addProduct;

  /// No description provided for @setUpStore.
  ///
  /// In ar, this message translates to:
  /// **'تجهيز متجري'**
  String get setUpStore;

  /// No description provided for @profileSaved.
  ///
  /// In ar, this message translates to:
  /// **'تم حفظ ملف المتجر.'**
  String get profileSaved;

  /// No description provided for @pauseTitle.
  ///
  /// In ar, this message translates to:
  /// **'إيقاف متجرك مؤقتًا؟'**
  String get pauseTitle;

  /// No description provided for @pauseBody.
  ///
  /// In ar, this message translates to:
  /// **'لن يرى الزبائن منتجاتك ولن تصلك طلبيات جديدة. الطلبيات المقبولة تستمر كالمعتاد.'**
  String get pauseBody;

  /// No description provided for @pauseConfirm.
  ///
  /// In ar, this message translates to:
  /// **'إيقاف مؤقت'**
  String get pauseConfirm;

  /// No description provided for @storePaused.
  ///
  /// In ar, this message translates to:
  /// **'متجرك متوقف مؤقتًا.'**
  String get storePaused;

  /// No description provided for @storeResumed.
  ///
  /// In ar, this message translates to:
  /// **'متجرك يستقبل الطلبيات من جديد.'**
  String get storeResumed;

  /// No description provided for @storeProfile.
  ///
  /// In ar, this message translates to:
  /// **'ملف المتجر'**
  String get storeProfile;

  /// No description provided for @storePicture.
  ///
  /// In ar, this message translates to:
  /// **'صورة المتجر'**
  String get storePicture;

  /// No description provided for @picturePhoto.
  ///
  /// In ar, this message translates to:
  /// **'صورة'**
  String get picturePhoto;

  /// No description provided for @pictureLogo.
  ///
  /// In ar, this message translates to:
  /// **'شعار'**
  String get pictureLogo;

  /// No description provided for @pictureNone.
  ///
  /// In ar, this message translates to:
  /// **'بدون'**
  String get pictureNone;

  /// No description provided for @storeName.
  ///
  /// In ar, this message translates to:
  /// **'اسم المتجر'**
  String get storeName;

  /// No description provided for @storeDescription.
  ///
  /// In ar, this message translates to:
  /// **'الوصف'**
  String get storeDescription;

  /// No description provided for @storeDescriptionHelper.
  ///
  /// In ar, this message translates to:
  /// **'ما تصنعينه وما يميّزه. بدون أرقام هاتف أو روابط.'**
  String get storeDescriptionHelper;

  /// No description provided for @storeLocation.
  ///
  /// In ar, this message translates to:
  /// **'المنطقة'**
  String get storeLocation;

  /// No description provided for @wilaya.
  ///
  /// In ar, this message translates to:
  /// **'الولاية'**
  String get wilaya;

  /// No description provided for @commune.
  ///
  /// In ar, this message translates to:
  /// **'البلدية'**
  String get commune;

  /// No description provided for @communeHelper.
  ///
  /// In ar, this message translates to:
  /// **'يرى الزبائن البلدية فقط، مع مسافة تقريبية.'**
  String get communeHelper;

  /// No description provided for @pickupTitle.
  ///
  /// In ar, this message translates to:
  /// **'مكان الاستلام'**
  String get pickupTitle;

  /// No description provided for @pickupBody.
  ///
  /// In ar, this message translates to:
  /// **'يستلم مندوب Yassir Express طلبياتك من هنا. اسحبي الدبوس إلى بابك.'**
  String get pickupBody;

  /// No description provided for @pickupMapSemantics.
  ///
  /// In ar, this message translates to:
  /// **'خريطة مكان الاستلام. المسي أو اسحبي لتحريك الدبوس.'**
  String get pickupMapSemantics;

  /// No description provided for @neverShownToClients.
  ///
  /// In ar, this message translates to:
  /// **'لا يظهر للزبائن أبدًا.'**
  String get neverShownToClients;

  /// No description provided for @payoutTitle.
  ///
  /// In ar, this message translates to:
  /// **'حساب استلام الأرباح'**
  String get payoutTitle;

  /// No description provided for @ccpLabel.
  ///
  /// In ar, this message translates to:
  /// **'حساب CCP / BaridiMob (الرقم + المفتاح)'**
  String get ccpLabel;

  /// No description provided for @ccpHelper.
  ///
  /// In ar, this message translates to:
  /// **'تُرسل أرباحك إلى هذا الحساب. تراه Kavza فقط.'**
  String get ccpHelper;

  /// No description provided for @ccpInvalid.
  ///
  /// In ar, this message translates to:
  /// **'بين 10 و20 رقمًا.'**
  String get ccpInvalid;

  /// No description provided for @pauseStore.
  ///
  /// In ar, this message translates to:
  /// **'إيقاف متجري مؤقتًا'**
  String get pauseStore;

  /// No description provided for @pauseStoreHint.
  ///
  /// In ar, this message translates to:
  /// **'تختفي منتجاتك من Kavza حتى تعيدي التشغيل.'**
  String get pauseStoreHint;

  /// No description provided for @save.
  ///
  /// In ar, this message translates to:
  /// **'حفظ'**
  String get save;

  /// No description provided for @productsPendingBanner.
  ///
  /// In ar, this message translates to:
  /// **'متجرك قيد التحقق. تبقى المنتجات الجديدة مسودات حتى الموافقة.'**
  String get productsPendingBanner;

  /// No description provided for @productsPausedBanner.
  ///
  /// In ar, this message translates to:
  /// **'متجرك متوقف مؤقتًا: الزبائن لا يرون منتجاتك.'**
  String get productsPausedBanner;

  /// No description provided for @tabProducts.
  ///
  /// In ar, this message translates to:
  /// **'المنتجات'**
  String get tabProducts;

  /// No description provided for @tabEarnings.
  ///
  /// In ar, this message translates to:
  /// **'الأرباح'**
  String get tabEarnings;

  /// No description provided for @tabMore.
  ///
  /// In ar, this message translates to:
  /// **'المزيد'**
  String get tabMore;

  /// No description provided for @noStoreProducts.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد منتجات بعد'**
  String get noStoreProducts;

  /// No description provided for @noStoreProductsHint.
  ///
  /// In ar, this message translates to:
  /// **'أضيفي أول منتج: جاهز للبيع، حسب الطلب، أو الاثنين.'**
  String get noStoreProductsHint;

  /// No description provided for @productLive.
  ///
  /// In ar, this message translates to:
  /// **'معروض'**
  String get productLive;

  /// No description provided for @productPaused.
  ///
  /// In ar, this message translates to:
  /// **'متوقف'**
  String get productPaused;

  /// No description provided for @productDraft.
  ///
  /// In ar, this message translates to:
  /// **'مسودة'**
  String get productDraft;

  /// No description provided for @lowStock.
  ///
  /// In ar, this message translates to:
  /// **'مخزون منخفض · {n}'**
  String lowStock(int n);

  /// No description provided for @stockCount.
  ///
  /// In ar, this message translates to:
  /// **'المخزون: {n}'**
  String stockCount(int n);

  /// No description provided for @productPausedDone.
  ///
  /// In ar, this message translates to:
  /// **'المنتج متوقف. لم يعد ظاهرًا للزبائن.'**
  String get productPausedDone;

  /// No description provided for @productLiveDone.
  ///
  /// In ar, this message translates to:
  /// **'المنتج معروض من جديد.'**
  String get productLiveDone;

  /// No description provided for @publishLocked.
  ///
  /// In ar, this message translates to:
  /// **'يمكنك النشر بعد موافقة Kavza على متجرك.'**
  String get publishLocked;

  /// No description provided for @untitledProduct.
  ///
  /// In ar, this message translates to:
  /// **'منتج بدون عنوان'**
  String get untitledProduct;

  /// No description provided for @productActions.
  ///
  /// In ar, this message translates to:
  /// **'إجراءات المنتج'**
  String get productActions;

  /// No description provided for @edit.
  ///
  /// In ar, this message translates to:
  /// **'تعديل'**
  String get edit;

  /// No description provided for @pause.
  ///
  /// In ar, this message translates to:
  /// **'إيقاف مؤقت'**
  String get pause;

  /// No description provided for @resume.
  ///
  /// In ar, this message translates to:
  /// **'إعادة العرض'**
  String get resume;

  /// No description provided for @editStock.
  ///
  /// In ar, this message translates to:
  /// **'تعديل المخزون'**
  String get editStock;

  /// No description provided for @delete.
  ///
  /// In ar, this message translates to:
  /// **'حذف'**
  String get delete;

  /// No description provided for @deleteTitle.
  ///
  /// In ar, this message translates to:
  /// **'حذف هذا المنتج؟'**
  String get deleteTitle;

  /// No description provided for @deleteBody.
  ///
  /// In ar, this message translates to:
  /// **'يختفي من متجرك نهائيًا. الطلبيات السابقة تبقى في السجل.'**
  String get deleteBody;

  /// No description provided for @deleteBlockedTitle.
  ///
  /// In ar, this message translates to:
  /// **'لا يمكن حذف هذا المنتج الآن'**
  String get deleteBlockedTitle;

  /// No description provided for @deleteBlockedBody.
  ///
  /// In ar, this message translates to:
  /// **'توجد طلبية جارية لهذا المنتج. أوقفيه مؤقتًا بدل حذفه، واحذفيه بعد انتهاء الطلبية.'**
  String get deleteBlockedBody;

  /// No description provided for @ok.
  ///
  /// In ar, this message translates to:
  /// **'حسنًا'**
  String get ok;

  /// No description provided for @productDeleted.
  ///
  /// In ar, this message translates to:
  /// **'تم حذف المنتج.'**
  String get productDeleted;

  /// No description provided for @stockReserved.
  ///
  /// In ar, this message translates to:
  /// **'{qty} محجوزة لطلبيات تنتظر ردّك.'**
  String stockReserved(String qty);

  /// No description provided for @stockAlertAt.
  ///
  /// In ar, this message translates to:
  /// **'تنبيه المخزون المنخفض عند {qty}.'**
  String stockAlertAt(String qty);

  /// No description provided for @stockSaved.
  ///
  /// In ar, this message translates to:
  /// **'تم تحديث المخزون.'**
  String get stockSaved;

  /// No description provided for @draftSaved.
  ///
  /// In ar, this message translates to:
  /// **'تم حفظ المسودة.'**
  String get draftSaved;

  /// No description provided for @draftSavedAt.
  ///
  /// In ar, this message translates to:
  /// **'حُفظت المسودة على {time}'**
  String draftSavedAt(String time);

  /// No description provided for @publishedDone.
  ///
  /// In ar, this message translates to:
  /// **'تم النشر. يراه الزبائن الآن.'**
  String get publishedDone;

  /// No description provided for @changesSaved.
  ///
  /// In ar, this message translates to:
  /// **'تم حفظ التعديلات.'**
  String get changesSaved;

  /// No description provided for @editorCategory.
  ///
  /// In ar, this message translates to:
  /// **'الفئة'**
  String get editorCategory;

  /// No description provided for @editorDetails.
  ///
  /// In ar, this message translates to:
  /// **'الصور والتفاصيل'**
  String get editorDetails;

  /// No description provided for @editorModes.
  ///
  /// In ar, this message translates to:
  /// **'طريقة البيع'**
  String get editorModes;

  /// No description provided for @editorRules.
  ///
  /// In ar, this message translates to:
  /// **'قواعد الطلب المسبق'**
  String get editorRules;

  /// No description provided for @editorOptions.
  ///
  /// In ar, this message translates to:
  /// **'الخيارات'**
  String get editorOptions;

  /// No description provided for @editorPreview.
  ///
  /// In ar, this message translates to:
  /// **'المعاينة'**
  String get editorPreview;

  /// No description provided for @newProduct.
  ///
  /// In ar, this message translates to:
  /// **'منتج جديد'**
  String get newProduct;

  /// No description provided for @editProduct.
  ///
  /// In ar, this message translates to:
  /// **'تعديل المنتج'**
  String get editProduct;

  /// No description provided for @closeEditor.
  ///
  /// In ar, this message translates to:
  /// **'إغلاق وحفظ المسودة'**
  String get closeEditor;

  /// No description provided for @previewHint.
  ///
  /// In ar, this message translates to:
  /// **'هكذا سيرى الزبائن منتجك.'**
  String get previewHint;

  /// No description provided for @next.
  ///
  /// In ar, this message translates to:
  /// **'التالي'**
  String get next;

  /// No description provided for @saveChanges.
  ///
  /// In ar, this message translates to:
  /// **'حفظ التعديلات'**
  String get saveChanges;

  /// No description provided for @publish.
  ///
  /// In ar, this message translates to:
  /// **'نشر'**
  String get publish;

  /// No description provided for @saveDraft.
  ///
  /// In ar, this message translates to:
  /// **'حفظ كمسودة'**
  String get saveDraft;

  /// No description provided for @freePlanCategory.
  ///
  /// In ar, this message translates to:
  /// **'الخطة المجانية: تبيعين في «{category}». Kavza Pro يفتح كل الفئات.'**
  String freePlanCategory(String category);

  /// No description provided for @chooseCategory.
  ///
  /// In ar, this message translates to:
  /// **'اختاري فئة.'**
  String get chooseCategory;

  /// No description provided for @photos.
  ///
  /// In ar, this message translates to:
  /// **'الصور'**
  String get photos;

  /// No description provided for @removePhoto.
  ///
  /// In ar, this message translates to:
  /// **'حذف الصورة'**
  String get removePhoto;

  /// No description provided for @addPhoto.
  ///
  /// In ar, this message translates to:
  /// **'إضافة صورة'**
  String get addPhoto;

  /// No description provided for @addPhotoShort.
  ///
  /// In ar, this message translates to:
  /// **'إضافة'**
  String get addPhotoShort;

  /// No description provided for @photosRequired.
  ///
  /// In ar, this message translates to:
  /// **'أضيفي صورة واحدة على الأقل.'**
  String get photosRequired;

  /// No description provided for @productTitle.
  ///
  /// In ar, this message translates to:
  /// **'العنوان'**
  String get productTitle;

  /// No description provided for @titleRequired.
  ///
  /// In ar, this message translates to:
  /// **'أضيفي عنوانًا.'**
  String get titleRequired;

  /// No description provided for @nameRequired.
  ///
  /// In ar, this message translates to:
  /// **'أضيفي اسمًا.'**
  String get nameRequired;

  /// No description provided for @productDescription.
  ///
  /// In ar, this message translates to:
  /// **'الوصف'**
  String get productDescription;

  /// No description provided for @ingredientsHelper.
  ///
  /// In ar, this message translates to:
  /// **'مهم لمن لديهم حساسية.'**
  String get ingredientsHelper;

  /// No description provided for @sellBy.
  ///
  /// In ar, this message translates to:
  /// **'يُباع بـ'**
  String get sellBy;

  /// No description provided for @freeDeliveryHint.
  ///
  /// In ar, this message translates to:
  /// **'يدفع الزبون صفرًا للتوصيل، وتُخصم رسومه من أرباحك.'**
  String get freeDeliveryHint;

  /// No description provided for @readyMadeHint.
  ///
  /// In ar, this message translates to:
  /// **'مصنوع مسبقًا وجاهز للتوصيل.'**
  String get readyMadeHint;

  /// No description provided for @madeToOrderHint.
  ///
  /// In ar, this message translates to:
  /// **'تصنعينه بعد كل طلبية. تحدّدين القواعد في الخطوة التالية.'**
  String get madeToOrderHint;

  /// No description provided for @pricePer.
  ///
  /// In ar, this message translates to:
  /// **'السعر لكل {unit}'**
  String pricePer(String unit);

  /// No description provided for @priceRequired.
  ///
  /// In ar, this message translates to:
  /// **'أدخلي سعرًا.'**
  String get priceRequired;

  /// No description provided for @stockLabel.
  ///
  /// In ar, this message translates to:
  /// **'المخزون'**
  String get stockLabel;

  /// No description provided for @lowStockAlertLabel.
  ///
  /// In ar, this message translates to:
  /// **'تنبيه المخزون المنخفض عند'**
  String get lowStockAlertLabel;

  /// No description provided for @readyInLabel.
  ///
  /// In ar, this message translates to:
  /// **'جاهز خلال'**
  String get readyInLabel;

  /// No description provided for @modeRequired.
  ///
  /// In ar, this message translates to:
  /// **'اختاري طريقة بيع واحدة على الأقل.'**
  String get modeRequired;

  /// No description provided for @suggestedByKafza.
  ///
  /// In ar, this message translates to:
  /// **'مقترح من Kavza. غيّري ما لا يناسبك.'**
  String get suggestedByKafza;

  /// No description provided for @minPerOrder.
  ///
  /// In ar, this message translates to:
  /// **'الحد الأدنى للطلبية'**
  String get minPerOrder;

  /// No description provided for @orderBy.
  ///
  /// In ar, this message translates to:
  /// **'بزيادة'**
  String get orderBy;

  /// No description provided for @setMaximum.
  ///
  /// In ar, this message translates to:
  /// **'حدّ أقصى للطلبية'**
  String get setMaximum;

  /// No description provided for @maxPerOrder.
  ///
  /// In ar, this message translates to:
  /// **'الحد الأقصى'**
  String get maxPerOrder;

  /// No description provided for @leadTimeLabel.
  ///
  /// In ar, this message translates to:
  /// **'يُطلب قبل'**
  String get leadTimeLabel;

  /// No description provided for @prepTimeLabel.
  ///
  /// In ar, this message translates to:
  /// **'مدة التحضير'**
  String get prepTimeLabel;

  /// No description provided for @prepLongerThanLead.
  ///
  /// In ar, this message translates to:
  /// **'لا يمكن أن يتجاوز التحضير المهلة التي تطلبينها.'**
  String get prepLongerThanLead;

  /// No description provided for @deliveryDays.
  ///
  /// In ar, this message translates to:
  /// **'أيام التوصيل'**
  String get deliveryDays;

  /// No description provided for @daysRequired.
  ///
  /// In ar, this message translates to:
  /// **'اختاري يومًا واحدًا على الأقل.'**
  String get daysRequired;

  /// No description provided for @optionsIntro.
  ///
  /// In ar, this message translates to:
  /// **'تسمح الخيارات للزبون باختيار الحجم أو النكهة أو اللون أو كتابة نص قصير. تُضاف الأسعار الإضافية إلى المجموع.'**
  String get optionsIntro;

  /// No description provided for @noOptions.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد خيارات. هذا ممكن: يطلب الزبون الكمية فقط.'**
  String get noOptions;

  /// No description provided for @addOptionGroup.
  ///
  /// In ar, this message translates to:
  /// **'إضافة مجموعة خيارات'**
  String get addOptionGroup;

  /// No description provided for @editOptionGroup.
  ///
  /// In ar, this message translates to:
  /// **'تعديل مجموعة الخيارات'**
  String get editOptionGroup;

  /// No description provided for @maxChars.
  ///
  /// In ar, this message translates to:
  /// **'{n} حرفًا كحد أقصى'**
  String maxChars(int n);

  /// No description provided for @optionSingle.
  ///
  /// In ar, this message translates to:
  /// **'اختيار واحد'**
  String get optionSingle;

  /// No description provided for @optionMultiple.
  ///
  /// In ar, this message translates to:
  /// **'عدة اختيارات'**
  String get optionMultiple;

  /// No description provided for @optionColour.
  ///
  /// In ar, this message translates to:
  /// **'لون'**
  String get optionColour;

  /// No description provided for @optionText.
  ///
  /// In ar, this message translates to:
  /// **'نص قصير'**
  String get optionText;

  /// No description provided for @choiceName.
  ///
  /// In ar, this message translates to:
  /// **'الاختيار'**
  String get choiceName;

  /// No description provided for @removeChoice.
  ///
  /// In ar, this message translates to:
  /// **'حذف الاختيار'**
  String get removeChoice;

  /// No description provided for @extraPrice.
  ///
  /// In ar, this message translates to:
  /// **'سعر إضافي (اختياري)'**
  String get extraPrice;

  /// No description provided for @perOrder.
  ///
  /// In ar, this message translates to:
  /// **'لكل طلبية'**
  String get perOrder;

  /// No description provided for @perUnitLabel.
  ///
  /// In ar, this message translates to:
  /// **'لكل {unit}'**
  String perUnitLabel(String unit);

  /// No description provided for @swatchN.
  ///
  /// In ar, this message translates to:
  /// **'اللون {n}'**
  String swatchN(int n);

  /// No description provided for @optionGroupName.
  ///
  /// In ar, this message translates to:
  /// **'اسم المجموعة'**
  String get optionGroupName;

  /// No description provided for @optionGroupNameHelper.
  ///
  /// In ar, this message translates to:
  /// **'مثلًا: الحجم، النكهة، الاسم على الكعكة'**
  String get optionGroupNameHelper;

  /// No description provided for @optionTypeLabel.
  ///
  /// In ar, this message translates to:
  /// **'النوع'**
  String get optionTypeLabel;

  /// No description provided for @optionRequired.
  ///
  /// In ar, this message translates to:
  /// **'إلزامي'**
  String get optionRequired;

  /// No description provided for @optionRequiredHint.
  ///
  /// In ar, this message translates to:
  /// **'لا يمكن للزبون المتابعة دون اختيار.'**
  String get optionRequiredHint;

  /// No description provided for @textOptionHint.
  ///
  /// In ar, this message translates to:
  /// **'يكتب الزبون نصًا قصيرًا، مثل اسم على الكعكة. أرقام الهاتف والروابط ممنوعة.'**
  String get textOptionHint;

  /// No description provided for @maxLengthLabel.
  ///
  /// In ar, this message translates to:
  /// **'الطول الأقصى'**
  String get maxLengthLabel;

  /// No description provided for @choices.
  ///
  /// In ar, this message translates to:
  /// **'الاختيارات'**
  String get choices;

  /// No description provided for @addChoice.
  ///
  /// In ar, this message translates to:
  /// **'إضافة اختيار'**
  String get addChoice;

  /// No description provided for @storePending.
  ///
  /// In ar, this message translates to:
  /// **'قيد التحقق'**
  String get storePending;

  /// No description provided for @storeRejected.
  ///
  /// In ar, this message translates to:
  /// **'مرفوض'**
  String get storeRejected;

  /// No description provided for @logOut.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الخروج'**
  String get logOut;

  /// No description provided for @storeApproved.
  ///
  /// In ar, this message translates to:
  /// **'تمت الموافقة على متجرك. يمكنك الآن نشر منتجاتك.'**
  String get storeApproved;

  /// No description provided for @storeRejectedNotice.
  ///
  /// In ar, this message translates to:
  /// **'لم نتمكن من التحقق من متجرك. افتحي الرئيسية لمعرفة السبب.'**
  String get storeRejectedNotice;

  /// No description provided for @noticeNewOrder.
  ///
  /// In ar, this message translates to:
  /// **'طلبية جديدة'**
  String get noticeNewOrder;

  /// No description provided for @noticeLowStock.
  ///
  /// In ar, this message translates to:
  /// **'المخزون منخفض'**
  String get noticeLowStock;

  /// No description provided for @noticeReview.
  ///
  /// In ar, this message translates to:
  /// **'تقييم جديد'**
  String get noticeReview;

  /// No description provided for @noticeStrike.
  ///
  /// In ar, this message translates to:
  /// **'حصلتِ على إنذار'**
  String get noticeStrike;

  /// No description provided for @noticeSuspended.
  ///
  /// In ar, this message translates to:
  /// **'تم تعليق متجرك'**
  String get noticeSuspended;

  /// No description provided for @noticeSuspendedBody.
  ///
  /// In ar, this message translates to:
  /// **'منتجاتك مخفية لمدة 7 أيام.'**
  String get noticeSuspendedBody;

  /// No description provided for @clientIn.
  ///
  /// In ar, this message translates to:
  /// **'زبون في {commune} · {detail}'**
  String clientIn(String commune, String detail);

  /// No description provided for @commissionLine.
  ///
  /// In ar, this message translates to:
  /// **'عمولة Kavza'**
  String get commissionLine;

  /// No description provided for @deliveryDeductedLine.
  ///
  /// In ar, this message translates to:
  /// **'التوصيل المجاني (يُخصم منك)'**
  String get deliveryDeductedLine;

  /// No description provided for @netEarnings.
  ///
  /// In ar, this message translates to:
  /// **'صافي أرباحك'**
  String get netEarnings;

  /// No description provided for @ordersNew.
  ///
  /// In ar, this message translates to:
  /// **'جديدة ({n})'**
  String ordersNew(int n);

  /// No description provided for @ordersInProgress.
  ///
  /// In ar, this message translates to:
  /// **'قيد التنفيذ ({n})'**
  String ordersInProgress(int n);

  /// No description provided for @ordersHistory.
  ///
  /// In ar, this message translates to:
  /// **'السجل'**
  String get ordersHistory;

  /// No description provided for @noNewOrders.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد طلبيات جديدة'**
  String get noNewOrders;

  /// No description provided for @noNewOrdersHint.
  ///
  /// In ar, this message translates to:
  /// **'تظهر هنا الطلبيات التي تنتظر ردك.'**
  String get noNewOrdersHint;

  /// No description provided for @noOrdersInProgress.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد طلبيات قيد التنفيذ'**
  String get noOrdersInProgress;

  /// No description provided for @noOrdersInProgressHint.
  ///
  /// In ar, this message translates to:
  /// **'تبقى الطلبيات المقبولة هنا حتى تسليمها.'**
  String get noOrdersInProgressHint;

  /// No description provided for @noOrderHistory.
  ///
  /// In ar, this message translates to:
  /// **'السجل فارغ'**
  String get noOrderHistory;

  /// No description provided for @noOrderHistoryHint.
  ///
  /// In ar, this message translates to:
  /// **'تظهر هنا الطلبيات المسلّمة والمرفوضة والملغاة.'**
  String get noOrderHistoryHint;

  /// No description provided for @storeMoneyPlaced.
  ///
  /// In ar, this message translates to:
  /// **'{total} ما زال في Yassir Cash الخاص بالزبون. يُقتطع عند قبولك.'**
  String storeMoneyPlaced(String total);

  /// No description provided for @storeMoneyHeld.
  ///
  /// In ar, this message translates to:
  /// **'تم تأكيد الطلبية، الدفع مضمون. تحتفظ Kavza بمبلغ {total} حتى التسليم.'**
  String storeMoneyHeld(String total);

  /// No description provided for @storeMoneyPaid.
  ///
  /// In ar, this message translates to:
  /// **'تم التسليم. أُضيف {amount} إلى أرباحك.'**
  String storeMoneyPaid(String amount);

  /// No description provided for @storeMoneyDisputed.
  ///
  /// In ar, this message translates to:
  /// **'أبلغ الزبون عن مشكلة. Kavza تراجعها.'**
  String get storeMoneyDisputed;

  /// No description provided for @storePaymentFailed.
  ///
  /// In ar, this message translates to:
  /// **'فشل الدفع: رصيد الزبون غير كافٍ. عاد المخزون، ولا إنذار.'**
  String get storePaymentFailed;

  /// No description provided for @storeMoneyDeclined.
  ///
  /// In ar, this message translates to:
  /// **'رفضتِ الطلبية. لم يُقتطع شيء من الزبون، ولا إنذار.'**
  String get storeMoneyDeclined;

  /// No description provided for @storeMoneyExpired.
  ///
  /// In ar, this message translates to:
  /// **'انتهت مهلة هذه الطلبية. لم يُقتطع شيء، ولا إنذار.'**
  String get storeMoneyExpired;

  /// No description provided for @storeMoneyCancelledByClient.
  ///
  /// In ar, this message translates to:
  /// **'ألغى الزبون الطلبية قبل ردك. لم يُقتطع شيء.'**
  String get storeMoneyCancelledByClient;

  /// No description provided for @storeMoneyCancelled.
  ///
  /// In ar, this message translates to:
  /// **'أُلغيت. استرجع الزبون {total} كاملًا، وحصلتِ على إنذار.'**
  String storeMoneyCancelled(String total);

  /// No description provided for @storeDeliveryFailedPaid.
  ///
  /// In ar, this message translates to:
  /// **'فشل التوصيل. المنتج حسب الطلب، لذا تحصلين على {amount}.'**
  String storeDeliveryFailedPaid(String amount);

  /// No description provided for @storeDeliveryFailedRefund.
  ///
  /// In ar, this message translates to:
  /// **'فشل التوصيل. عاد المنتج إلى مخزونك، واسترجع الزبون ماله دون رسوم التوصيل.'**
  String get storeDeliveryFailedRefund;

  /// No description provided for @orderCancelledStrike.
  ///
  /// In ar, this message translates to:
  /// **'أُلغيت الطلبية واسترجع الزبون ماله.'**
  String get orderCancelledStrike;

  /// No description provided for @orderDeclined.
  ///
  /// In ar, this message translates to:
  /// **'رُفضت الطلبية.'**
  String get orderDeclined;

  /// No description provided for @markReadyTitle.
  ///
  /// In ar, this message translates to:
  /// **'هل الطلبية جاهزة؟'**
  String get markReadyTitle;

  /// No description provided for @markReadyBody.
  ///
  /// In ar, this message translates to:
  /// **'سيأتي مندوب Yassir Express لاستلامها من نقطة الاستلام الخاصة بك.'**
  String get markReadyBody;

  /// No description provided for @ready.
  ///
  /// In ar, this message translates to:
  /// **'جاهزة'**
  String get ready;

  /// No description provided for @accept.
  ///
  /// In ar, this message translates to:
  /// **'قبول'**
  String get accept;

  /// No description provided for @decline.
  ///
  /// In ar, this message translates to:
  /// **'رفض'**
  String get decline;

  /// No description provided for @securingPayment.
  ///
  /// In ar, this message translates to:
  /// **'جارٍ تأمين الدفع…'**
  String get securingPayment;

  /// No description provided for @startPreparation.
  ///
  /// In ar, this message translates to:
  /// **'بدء التحضير'**
  String get startPreparation;

  /// No description provided for @markReady.
  ///
  /// In ar, this message translates to:
  /// **'جاهزة للاستلام'**
  String get markReady;

  /// No description provided for @answerBefore.
  ///
  /// In ar, this message translates to:
  /// **'ردّي قبل {time}، وإلا تنتهي مهلتها دون إنذار.'**
  String answerBefore(String time);

  /// No description provided for @waitingCourier.
  ///
  /// In ar, this message translates to:
  /// **'في انتظار المندوب'**
  String get waitingCourier;

  /// No description provided for @waitingCourierBody.
  ///
  /// In ar, this message translates to:
  /// **'طُلب مندوب Yassir Express. جهّزي الطلبية عند نقطة الاستلام.'**
  String get waitingCourierBody;

  /// No description provided for @courierOnTheWay.
  ///
  /// In ar, this message translates to:
  /// **'في الطريق مع Yassir Express'**
  String get courierOnTheWay;

  /// No description provided for @courierOnTheWayBody.
  ///
  /// In ar, this message translates to:
  /// **'تُضاف أرباحك عند التسليم.'**
  String get courierOnTheWayBody;

  /// No description provided for @deliveredToCommune.
  ///
  /// In ar, this message translates to:
  /// **'التوصيل إلى {commune}'**
  String deliveredToCommune(String commune);

  /// No description provided for @yourEarnings.
  ///
  /// In ar, this message translates to:
  /// **'أرباحك'**
  String get yourEarnings;

  /// No description provided for @clientPays.
  ///
  /// In ar, this message translates to:
  /// **'يدفع الزبون {total}.'**
  String clientPays(String total);

  /// No description provided for @cancelOrderStoreTitle.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء طلبية مقبولة'**
  String get cancelOrderStoreTitle;

  /// No description provided for @declineTitle.
  ///
  /// In ar, this message translates to:
  /// **'رفض الطلبية'**
  String get declineTitle;

  /// No description provided for @cancelStrikeWarning.
  ///
  /// In ar, this message translates to:
  /// **'يسترجع الزبون ماله كاملًا وتحصلين على إنذار ({n} من {max}). عند {max} إنذارات يُعلَّق متجرك 7 أيام.'**
  String cancelStrikeWarning(int n, int max);

  /// No description provided for @declineBody.
  ///
  /// In ar, this message translates to:
  /// **'لا يُقتطع شيء من الزبون ويعود المخزون. لا إنذار.'**
  String get declineBody;

  /// No description provided for @reasonTitle.
  ///
  /// In ar, this message translates to:
  /// **'السبب'**
  String get reasonTitle;

  /// No description provided for @reasonOutOfStock.
  ///
  /// In ar, this message translates to:
  /// **'نفد المنتج'**
  String get reasonOutOfStock;

  /// No description provided for @reasonNoTime.
  ///
  /// In ar, this message translates to:
  /// **'لا أستطيع تحضيرها في الوقت'**
  String get reasonNoTime;

  /// No description provided for @reasonDate.
  ///
  /// In ar, this message translates to:
  /// **'التاريخ غير مناسب'**
  String get reasonDate;

  /// No description provided for @reasonOther.
  ///
  /// In ar, this message translates to:
  /// **'سبب آخر'**
  String get reasonOther;

  /// No description provided for @reasonDetails.
  ///
  /// In ar, this message translates to:
  /// **'اشرحي السبب'**
  String get reasonDetails;

  /// No description provided for @reasonDetailsHelper.
  ///
  /// In ar, this message translates to:
  /// **'يراه الزبون. دون رقم أو رابط.'**
  String get reasonDetailsHelper;

  /// No description provided for @cancelWithStrike.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء مع إنذار'**
  String get cancelWithStrike;

  /// No description provided for @storeOpen.
  ///
  /// In ar, this message translates to:
  /// **'مفتوح'**
  String get storeOpen;

  /// No description provided for @storeSuspended.
  ///
  /// In ar, this message translates to:
  /// **'معلّق'**
  String get storeSuspended;

  /// No description provided for @suspendedBanner.
  ///
  /// In ar, this message translates to:
  /// **'متجرك معلّق حتى {date}: منتجاتك مخفية ولا تصلك طلبيات جديدة. واصلي الطلبيات المقبولة كالمعتاد.'**
  String suspendedBanner(String date);

  /// No description provided for @strikeStanding.
  ///
  /// In ar, this message translates to:
  /// **'{n} من {max} إنذارات قبل تعليق لمدة 7 أيام'**
  String strikeStanding(int n, int max);

  /// No description provided for @availableBalance.
  ///
  /// In ar, this message translates to:
  /// **'الرصيد المتاح'**
  String get availableBalance;

  /// No description provided for @todayOrders.
  ///
  /// In ar, this message translates to:
  /// **'طلبيات اليوم'**
  String get todayOrders;

  /// No description provided for @needsAnswer.
  ///
  /// In ar, this message translates to:
  /// **'تنتظر ردك ({n})'**
  String needsAnswer(int n);

  /// No description provided for @needsAnswerEmpty.
  ///
  /// In ar, this message translates to:
  /// **'لا شيء ينتظر. تظهر الطلبيات الجديدة هنا.'**
  String get needsAnswerEmpty;

  /// No description provided for @lowStockTitle.
  ///
  /// In ar, this message translates to:
  /// **'مخزون منخفض'**
  String get lowStockTitle;

  /// No description provided for @onHold.
  ///
  /// In ar, this message translates to:
  /// **'قيد الانتظار: {amount}'**
  String onHold(String amount);

  /// No description provided for @onHoldHint.
  ///
  /// In ar, this message translates to:
  /// **'أرباح الطلبيات المقبولة، تُضاف عند التسليم.'**
  String get onHoldHint;

  /// No description provided for @addCcpFirst.
  ///
  /// In ar, this message translates to:
  /// **'أضيفي حساب CCP في ملف المتجر لسحب أرباحك.'**
  String get addCcpFirst;

  /// No description provided for @withdrawMinimum.
  ///
  /// In ar, this message translates to:
  /// **'الحد الأدنى للسحب {amount}.'**
  String withdrawMinimum(String amount);

  /// No description provided for @withdrawMax.
  ///
  /// In ar, this message translates to:
  /// **'لا يمكنك سحب أكثر من {amount}.'**
  String withdrawMax(String amount);

  /// No description provided for @withdrawTo.
  ///
  /// In ar, this message translates to:
  /// **'إلى حساب CCP {account}'**
  String withdrawTo(String account);

  /// No description provided for @perOrderTitle.
  ///
  /// In ar, this message translates to:
  /// **'حسب الطلبية'**
  String get perOrderTitle;

  /// No description provided for @noEarningsYet.
  ///
  /// In ar, this message translates to:
  /// **'تظهر الأرباح هنا بعد أول تسليم.'**
  String get noEarningsYet;

  /// No description provided for @withdrawalsTitle.
  ///
  /// In ar, this message translates to:
  /// **'عمليات السحب'**
  String get withdrawalsTitle;

  /// No description provided for @noWithdrawals.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد عمليات سحب بعد.'**
  String get noWithdrawals;

  /// No description provided for @withdrawalRequested.
  ///
  /// In ar, this message translates to:
  /// **'قيد المعالجة'**
  String get withdrawalRequested;

  /// No description provided for @withdrawalSent.
  ///
  /// In ar, this message translates to:
  /// **'تم الإرسال'**
  String get withdrawalSent;

  /// No description provided for @withdrawalFailed.
  ///
  /// In ar, this message translates to:
  /// **'فشل'**
  String get withdrawalFailed;

  /// No description provided for @withdraw.
  ///
  /// In ar, this message translates to:
  /// **'سحب'**
  String get withdraw;

  /// No description provided for @withdrawAmount.
  ///
  /// In ar, this message translates to:
  /// **'المبلغ'**
  String get withdrawAmount;

  /// No description provided for @availableAmount.
  ///
  /// In ar, this message translates to:
  /// **'متاح: {amount}'**
  String availableAmount(String amount);

  /// No description provided for @withdrawConfirm.
  ///
  /// In ar, this message translates to:
  /// **'سحب {amount}'**
  String withdrawConfirm(String amount);

  /// No description provided for @withdrawDone.
  ///
  /// In ar, this message translates to:
  /// **'تم طلب سحب {amount}.'**
  String withdrawDone(String amount);

  /// No description provided for @reportReviewTitle.
  ///
  /// In ar, this message translates to:
  /// **'الإبلاغ عن هذا التقييم؟'**
  String get reportReviewTitle;

  /// No description provided for @reportReviewBody.
  ///
  /// In ar, this message translates to:
  /// **'ستراجعه Kavza. يبقى ظاهرًا حتى قرارها.'**
  String get reportReviewBody;

  /// No description provided for @reportReview.
  ///
  /// In ar, this message translates to:
  /// **'إبلاغ'**
  String get reportReview;

  /// No description provided for @reviewReported.
  ///
  /// In ar, this message translates to:
  /// **'تم الإبلاغ عن التقييم.'**
  String get reviewReported;

  /// No description provided for @reviewReportedBadge.
  ///
  /// In ar, this message translates to:
  /// **'مُبلَّغ عنه'**
  String get reviewReportedBadge;

  /// No description provided for @reviewsTitle.
  ///
  /// In ar, this message translates to:
  /// **'التقييمات'**
  String get reviewsTitle;

  /// No description provided for @reviewCount.
  ///
  /// In ar, this message translates to:
  /// **'{n, plural, =1{تقييم واحد} =2{تقييمان} few{{n} تقييمات} other{{n} تقييم}}'**
  String reviewCount(int n);

  /// No description provided for @reviewsNoReply.
  ///
  /// In ar, this message translates to:
  /// **'لا يمكن الرد على التقييمات. إن كان أحدها غير لائق، أبلغي Kavza.'**
  String get reviewsNoReply;

  /// No description provided for @strikesTitle.
  ///
  /// In ar, this message translates to:
  /// **'الإنذارات'**
  String get strikesTitle;

  /// No description provided for @strikesHow.
  ///
  /// In ar, this message translates to:
  /// **'يُضاف إنذار عند إلغاء طلبية بعد قبولها. عند 3 إنذارات يُعلَّق المتجر 7 أيام. الرفض قبل القبول وانتهاء المهلة لا يُحتسبان.'**
  String get strikesHow;

  /// No description provided for @strikesListTitle.
  ///
  /// In ar, this message translates to:
  /// **'إنذاراتك'**
  String get strikesListTitle;

  /// No description provided for @noStrikes.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد إنذارات.'**
  String get noStrikes;

  /// No description provided for @appeal.
  ///
  /// In ar, this message translates to:
  /// **'طعن'**
  String get appeal;

  /// No description provided for @appealSent.
  ///
  /// In ar, this message translates to:
  /// **'الطعن قيد المراجعة'**
  String get appealSent;

  /// No description provided for @appealTitle.
  ///
  /// In ar, this message translates to:
  /// **'الطعن في الإنذار'**
  String get appealTitle;

  /// No description provided for @appealBody.
  ///
  /// In ar, this message translates to:
  /// **'اشرحي ما حدث. تراجع Kavza طعنك وتردّ عليك هنا.'**
  String get appealBody;

  /// No description provided for @appealText.
  ///
  /// In ar, this message translates to:
  /// **'ما حدث'**
  String get appealText;

  /// No description provided for @appealAttachment.
  ///
  /// In ar, this message translates to:
  /// **'مرفقات (غير متاحة في النموذج)'**
  String get appealAttachment;

  /// No description provided for @appealDone.
  ///
  /// In ar, this message translates to:
  /// **'أُرسل الطعن.'**
  String get appealDone;

  /// No description provided for @sendAppeal.
  ///
  /// In ar, this message translates to:
  /// **'إرسال الطعن'**
  String get sendAppeal;

  /// No description provided for @noNotifications.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد إشعارات'**
  String get noNotifications;

  /// No description provided for @noNotificationsHint.
  ///
  /// In ar, this message translates to:
  /// **'تظهر هنا الطلبيات الجديدة والتقييمات والتنبيهات.'**
  String get noNotificationsHint;

  /// No description provided for @storeFaqPaidQ.
  ///
  /// In ar, this message translates to:
  /// **'متى أحصل على أرباحي؟'**
  String get storeFaqPaidQ;

  /// No description provided for @storeFaqPaidA.
  ///
  /// In ar, this message translates to:
  /// **'عند قبولك، يُقتطع المبلغ من الزبون وتحتفظ به Kavza. عند التسليم تُضاف أرباحك: ثمن المنتجات ناقص العمولة، وناقص رسوم التوصيل إن كان التوصيل مجانيًا.'**
  String get storeFaqPaidA;

  /// No description provided for @storeFaqAcceptQ.
  ///
  /// In ar, this message translates to:
  /// **'ماذا يحدث عند قبول طلبية؟'**
  String get storeFaqAcceptQ;

  /// No description provided for @storeFaqAcceptA.
  ///
  /// In ar, this message translates to:
  /// **'تؤمّن Kavza الدفع فورًا. إن كان رصيد الزبون غير كافٍ، تُلغى الطلبية ويعود المخزون، دون أي إنذار لكِ.'**
  String get storeFaqAcceptA;

  /// No description provided for @storeFaqStrikesQ.
  ///
  /// In ar, this message translates to:
  /// **'كيف تعمل الإنذارات؟'**
  String get storeFaqStrikesQ;

  /// No description provided for @storeFaqWithdrawQ.
  ///
  /// In ar, this message translates to:
  /// **'كيف أسحب أرباحي؟'**
  String get storeFaqWithdrawQ;

  /// No description provided for @storeFaqWithdrawA.
  ///
  /// In ar, this message translates to:
  /// **'من تبويب الأرباح، إلى حساب CCP المسجّل في ملف المتجر. الحد الأدنى {amount}.'**
  String storeFaqWithdrawA(String amount);

  /// No description provided for @storeFaqContactQ.
  ///
  /// In ar, this message translates to:
  /// **'لماذا لا أستطيع التواصل مع الزبون؟'**
  String get storeFaqContactQ;

  /// No description provided for @storeFaqContactA.
  ///
  /// In ar, this message translates to:
  /// **'لحماية الجميع، يمر كل شيء عبر Kavza: الدفع والتوصيل والمساعدة. لا تظهر لكِ إلا بلدية الزبون، والأرقام والروابط ممنوعة في كل النصوص.'**
  String get storeFaqContactA;

  /// No description provided for @storeSupportLine.
  ///
  /// In ar, this message translates to:
  /// **'سؤال آخر؟ فريق دعم Kavza يرد خلال 24 ساعة.'**
  String get storeSupportLine;

  /// No description provided for @orderTitleMore.
  ///
  /// In ar, this message translates to:
  /// **'{n, plural, =1{{title} ومنتج آخر} =2{{title} ومنتجان آخران} few{{title} و{n} منتجات أخرى} other{{title} و{n} منتج آخر}}'**
  String orderTitleMore(String title, int n);

  /// No description provided for @buyNowTotal.
  ///
  /// In ar, this message translates to:
  /// **'اشترِ الآن · {total}'**
  String buyNowTotal(String total);

  /// No description provided for @continueBrowsing.
  ///
  /// In ar, this message translates to:
  /// **'متابعة التسوق'**
  String get continueBrowsing;

  /// No description provided for @buyNowWithBasket.
  ///
  /// In ar, this message translates to:
  /// **'{n, plural, =1{يشمل الشراء أيضًا المنتج الآخر في سلتك.} =2{يشمل الشراء أيضًا المنتجين الآخرين في سلتك.} few{يشمل الشراء أيضًا {n} منتجات أخرى في سلتك.} other{يشمل الشراء أيضًا {n} منتج آخر في سلتك.}}'**
  String buyNowWithBasket(int n);

  /// No description provided for @addToBasket.
  ///
  /// In ar, this message translates to:
  /// **'أضف إلى السلة'**
  String get addToBasket;

  /// No description provided for @inBasket.
  ///
  /// In ar, this message translates to:
  /// **'في السلة: {qty}'**
  String inBasket(String qty);

  /// No description provided for @basketMadeToOrder.
  ///
  /// In ar, this message translates to:
  /// **'يُطلب وحده من صفحته، ولا يُضاف إلى السلة.'**
  String get basketMadeToOrder;

  /// No description provided for @basketOutOfStock.
  ///
  /// In ar, this message translates to:
  /// **'نفد المخزون، لا يمكن إضافته إلى السلة.'**
  String get basketOutOfStock;

  /// No description provided for @viewBasket.
  ///
  /// In ar, this message translates to:
  /// **'عرض السلة'**
  String get viewBasket;

  /// No description provided for @basketItems.
  ///
  /// In ar, this message translates to:
  /// **'{n, plural, =1{منتج واحد} =2{منتجان} few{{n} منتجات} other{{n} منتج}}'**
  String basketItems(int n);

  /// No description provided for @leaveStoreTitle.
  ///
  /// In ar, this message translates to:
  /// **'مغادرة المتجر؟'**
  String get leaveStoreTitle;

  /// No description provided for @leaveStoreBody.
  ///
  /// In ar, this message translates to:
  /// **'ستُفرَغ سلتك وتُحذف المنتجات التي اخترتها. تحتوي السلة على منتجات من متجر واحد فقط.'**
  String get leaveStoreBody;

  /// No description provided for @leaveStoreConfirm.
  ///
  /// In ar, this message translates to:
  /// **'المغادرة وإفراغ السلة'**
  String get leaveStoreConfirm;

  /// No description provided for @stayInStore.
  ///
  /// In ar, this message translates to:
  /// **'البقاء'**
  String get stayInStore;

  /// No description provided for @removeFromBasket.
  ///
  /// In ar, this message translates to:
  /// **'إزالة من السلة'**
  String get removeFromBasket;

  /// No description provided for @lineUnavailable.
  ///
  /// In ar, this message translates to:
  /// **'لم يعد متوفرًا. أزِله للمتابعة.'**
  String get lineUnavailable;

  /// No description provided for @lineOnlyLeft.
  ///
  /// In ar, this message translates to:
  /// **'المتوفر {qty} فقط. خفّض الكمية.'**
  String lineOnlyLeft(String qty);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
