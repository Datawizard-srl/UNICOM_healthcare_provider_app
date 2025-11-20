// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get commons_Name => 'Nome';

  @override
  String get commons_Informations => 'Informazioni';

  @override
  String get commons_SubstanceName => 'Nome Sostanza';

  @override
  String get commons_MoietyName => 'Nome Moiety';

  @override
  String get commons_AdministrableDoseForm =>
      'Forma Della Dose Somministrabile';

  @override
  String get commons_ProductUnitOfPresentation =>
      'Unità Di Presentazione Del Prodotto';

  @override
  String get commons_RoutesOfAdministration => 'Via Di Somministrazione';

  @override
  String get commons_ReferenceStrength => 'Reference Strength';

  @override
  String get commons_MarketingAuthorizationHolderLabel => 'Azienda';

  @override
  String get commons_Country => 'Nazione';

  @override
  String get commons_SelectLanguage => 'Seleziona Lingua';

  @override
  String get commons_SelectCountry => 'Seleziona Nazione';

  @override
  String get appbar_settings_title => 'Impostazioni';

  @override
  String get button_next => 'AVANTI';

  @override
  String get button_save => 'SAVE';

  @override
  String get welcome_title => 'Benvenuto!';

  @override
  String get welcome_text =>
      '(Italiano)\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Neque, hendrerit dui in purus libero non sollicitudin purus dolor. Fermentum tempor et magna ipsum aliquet.\n       \n       Dignissim quisque in nec laoreet pellentesque mauris. Sem enim, nibh felis, donec turpis diam senectus magna at. Amet eu egestas metus, facilisi at.';

  @override
  String get search => 'Cerca';

  @override
  String get homepage_text =>
      'Con l\'app Unicom puoi scansionare un farmaco e controllare la sostituzione simile per paziente.\n\nDopo la scansione Qr puoi vedere le caratteristiche del farmaco e visualizzare l\'elenco delle sostituzioni.';

  @override
  String get settings_dark_mode => 'Modalità Notturna';

  @override
  String get medicationDetailsScreen_Appbar_Title_Scanned =>
      'Medicinale trovato';

  @override
  String get medicationDetailsScreen_Appbar_Title_Substitution =>
      'Medicinale selezionato';

  @override
  String get medicationDetailsScreen_Button_GenerateSubstitution =>
      'GENERA LISTA DI MEDICINALI SIMILI';

  @override
  String get medicationDetailsScreen_Button_GenerateQrCode =>
      'GENERA QR CODE PER L\'UTENTE';

  @override
  String get substitutionListScreen_Appbar_Title =>
      'Lista dei medicinali simili';

  @override
  String get substitutionListScreen_Header_Text =>
      'Puoi trovare prodotti simili a:';

  @override
  String get substitutionListScreen_Search_Placeholder =>
      'Cerca medicinale o sostanza';

  @override
  String substitutionListScreen_ResultsFound(int numFound) {
    return 'Ci sono <b>$numFound</b> risultati';
  }

  @override
  String get substitutionFilterDialog_Title => 'Filtra ricerca';

  @override
  String get qrScreen_Info_Text =>
      'Mostra il codice QR all\'utente, in modo che possa scansionarlo e vedere la sostituzione selezionata.';
}
