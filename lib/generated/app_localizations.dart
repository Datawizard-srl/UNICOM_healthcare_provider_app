import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_it.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
    Locale('en'),
    Locale('it')
  ];

  /// No description provided for @commons_Name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get commons_Name;

  /// No description provided for @commons_Informations.
  ///
  /// In en, this message translates to:
  /// **'Informations'**
  String get commons_Informations;

  /// No description provided for @commons_SubstanceName.
  ///
  /// In en, this message translates to:
  /// **'Substance Name'**
  String get commons_SubstanceName;

  /// No description provided for @commons_MoietyName.
  ///
  /// In en, this message translates to:
  /// **'Moiety Name'**
  String get commons_MoietyName;

  /// No description provided for @commons_AdministrableDoseForm.
  ///
  /// In en, this message translates to:
  /// **'Administrable Dose Form'**
  String get commons_AdministrableDoseForm;

  /// No description provided for @commons_ProductUnitOfPresentation.
  ///
  /// In en, this message translates to:
  /// **'Product Unit Of Presentation'**
  String get commons_ProductUnitOfPresentation;

  /// No description provided for @commons_RoutesOfAdministration.
  ///
  /// In en, this message translates to:
  /// **'Route Of Administration'**
  String get commons_RoutesOfAdministration;

  /// No description provided for @commons_ReferenceStrength.
  ///
  /// In en, this message translates to:
  /// **'Reference Strength'**
  String get commons_ReferenceStrength;

  /// No description provided for @commons_MarketingAuthorizationHolderLabel.
  ///
  /// In en, this message translates to:
  /// **'Marketing Authorization Holder Label'**
  String get commons_MarketingAuthorizationHolderLabel;

  /// No description provided for @commons_Country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get commons_Country;

  /// No description provided for @commons_SelectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get commons_SelectLanguage;

  /// No description provided for @commons_SelectCountry.
  ///
  /// In en, this message translates to:
  /// **'Select Country'**
  String get commons_SelectCountry;

  /// No description provided for @appbar_settings_title.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get appbar_settings_title;

  /// No description provided for @button_next.
  ///
  /// In en, this message translates to:
  /// **'NEXT'**
  String get button_next;

  /// No description provided for @button_save.
  ///
  /// In en, this message translates to:
  /// **'SAVE'**
  String get button_save;

  /// No description provided for @welcome_title.
  ///
  /// In en, this message translates to:
  /// **'Welcome!'**
  String get welcome_title;

  /// No description provided for @welcome_text.
  ///
  /// In en, this message translates to:
  /// **'(English)\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Neque, hendrerit dui in purus libero non sollicitudin purus dolor. Fermentum tempor et magna ipsum aliquet.\n       \n       Dignissim quisque in nec laoreet pellentesque mauris. Sem enim, nibh felis, donec turpis diam senectus magna at. Amet eu egestas metus, facilisi at.'**
  String get welcome_text;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @homepage_text.
  ///
  /// In en, this message translates to:
  /// **'With Unicom app you can scan a drug and check the substitution similar for patient.\n\nAfter Qr scan you can see feature of drug and visualize list of substitutions.'**
  String get homepage_text;

  /// No description provided for @settings_dark_mode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get settings_dark_mode;

  /// No description provided for @medicationDetailsScreen_Appbar_Title_Scanned.
  ///
  /// In en, this message translates to:
  /// **'Drug scanned'**
  String get medicationDetailsScreen_Appbar_Title_Scanned;

  /// No description provided for @medicationDetailsScreen_Appbar_Title_Substitution.
  ///
  /// In en, this message translates to:
  /// **'Drug selected'**
  String get medicationDetailsScreen_Appbar_Title_Substitution;

  /// No description provided for @medicationDetailsScreen_Button_GenerateSubstitution.
  ///
  /// In en, this message translates to:
  /// **'GENERATE LIST OF SIMILAR DRUGS'**
  String get medicationDetailsScreen_Button_GenerateSubstitution;

  /// No description provided for @medicationDetailsScreen_Button_GenerateQrCode.
  ///
  /// In en, this message translates to:
  /// **'GENERATE QR CODE FOR USER'**
  String get medicationDetailsScreen_Button_GenerateQrCode;

  /// No description provided for @substitutionListScreen_Appbar_Title.
  ///
  /// In en, this message translates to:
  /// **'List of similar drugs'**
  String get substitutionListScreen_Appbar_Title;

  /// No description provided for @substitutionListScreen_Header_Text.
  ///
  /// In en, this message translates to:
  /// **'You can find similar drug of:'**
  String get substitutionListScreen_Header_Text;

  /// No description provided for @substitutionListScreen_Search_Placeholder.
  ///
  /// In en, this message translates to:
  /// **'Find drug or substance'**
  String get substitutionListScreen_Search_Placeholder;

  /// No description provided for @substitutionListScreen_ResultsFound.
  ///
  /// In en, this message translates to:
  /// **'You have <b>{numFound}</b> results'**
  String substitutionListScreen_ResultsFound(int numFound);

  /// No description provided for @substitutionFilterDialog_Title.
  ///
  /// In en, this message translates to:
  /// **'Filter research'**
  String get substitutionFilterDialog_Title;

  /// No description provided for @qrScreen_Info_Text.
  ///
  /// In en, this message translates to:
  /// **'Show this QR code to the user so that he can scan it and see your selection.'**
  String get qrScreen_Info_Text;
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
      <String>['en', 'it'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'it':
      return AppLocalizationsIt();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
