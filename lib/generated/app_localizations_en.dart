// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get commons_Name => 'Name';

  @override
  String get commons_Informations => 'Informations';

  @override
  String get commons_SubstanceName => 'Substance Name';

  @override
  String get commons_MoietyName => 'Moiety Name';

  @override
  String get commons_AdministrableDoseForm => 'Administrable Dose Form';

  @override
  String get commons_ProductUnitOfPresentation =>
      'Product Unit Of Presentation';

  @override
  String get commons_RoutesOfAdministration => 'Route Of Administration';

  @override
  String get commons_ReferenceStrength => 'Reference Strength';

  @override
  String get commons_MarketingAuthorizationHolderLabel =>
      'Marketing Authorization Holder Label';

  @override
  String get commons_Country => 'Country';

  @override
  String get commons_SelectLanguage => 'Select Language';

  @override
  String get commons_SelectCountry => 'Select Country';

  @override
  String get appbar_settings_title => 'Settings';

  @override
  String get button_next => 'NEXT';

  @override
  String get button_save => 'SAVE';

  @override
  String get welcome_title => 'Welcome!';

  @override
  String get welcome_text =>
      '(English)\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Neque, hendrerit dui in purus libero non sollicitudin purus dolor. Fermentum tempor et magna ipsum aliquet.\n       \n       Dignissim quisque in nec laoreet pellentesque mauris. Sem enim, nibh felis, donec turpis diam senectus magna at. Amet eu egestas metus, facilisi at.';

  @override
  String get search => 'Search';

  @override
  String get homepage_text =>
      'With Unicom app you can scan a drug and check the substitution similar for patient.\n\nAfter Qr scan you can see feature of drug and visualize list of substitutions.';

  @override
  String get settings_dark_mode => 'Dark Mode';

  @override
  String get medicationDetailsScreen_Appbar_Title_Scanned => 'Drug scanned';

  @override
  String get medicationDetailsScreen_Appbar_Title_Substitution =>
      'Drug selected';

  @override
  String get medicationDetailsScreen_Button_GenerateSubstitution =>
      'GENERATE LIST OF SIMILAR DRUGS';

  @override
  String get medicationDetailsScreen_Button_GenerateQrCode =>
      'GENERATE QR CODE FOR USER';

  @override
  String get substitutionListScreen_Appbar_Title => 'List of similar drugs';

  @override
  String get substitutionListScreen_Header_Text =>
      'You can find similar drug of:';

  @override
  String get substitutionListScreen_Search_Placeholder =>
      'Find drug or substance';

  @override
  String substitutionListScreen_ResultsFound(int numFound) {
    return 'You have <b>$numFound</b> results';
  }

  @override
  String get substitutionFilterDialog_Title => 'Filter research';

  @override
  String get qrScreen_Info_Text =>
      'Show this QR code to the user so that he can scan it and see your selection.';
}
