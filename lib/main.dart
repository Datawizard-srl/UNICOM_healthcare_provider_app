import 'package:flutter/material.dart';
import 'package:unicom_healthcare/screens/medication_details_screen.dart';

import 'package:provider/provider.dart';
import 'package:unicom_healthcare/database/local_storage/user_preferences.dart';
import 'package:unicom_healthcare/database/locations_repository.dart';

import 'package:unicom_healthcare/models/user_preferences_model.dart';
import 'package:unicom_healthcare/screens/homepage_screen.dart';
import 'package:unicom_healthcare/screens/qr_scan_screen.dart';
import 'package:unicom_healthcare/screens/qr_screen.dart';
import 'package:unicom_healthcare/screens/settings_screen.dart';
import 'package:unicom_healthcare/screens/substitution_list_screen.dart';
import 'package:unicom_healthcare/screens/welcome_screen.dart';
import 'package:unicom_healthcare/settings/countries.dart';
import 'package:unicom_healthcare/settings/locale.dart';
import 'package:unicom_healthcare/themes/healthcare/theme.dart';
import 'package:unicom_healthcare/utilities/api_fhir.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserPreferences.init();
  await LocationsRepository.init();

  ApiFhir.init(
      serverUrl: "https://jpa.unicom.datawizard.it",
      substitutionUrl: 'https://unicom.gnomon.com.gr',
      substitutionEndpoint: 'r5/substitutes'
  );
  await Countries.initCodes();
  await Languages.initCodes();
  await Substances.initCodes();
  await DoseForms.initCodes();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // @override
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserPreferencesNotifier(),
      child: Consumer<UserPreferencesNotifier>(builder: (context, locale, child) {
        return MaterialApp(
          title: 'Unicom Healthcare',
          // themes
          theme: getTheme(darkTheme: false, fontSize: UserPreferences.getFontSize()),
          darkTheme: getTheme(darkTheme: true, fontSize: UserPreferences.getFontSize()),
          themeMode: UserPreferences.isDarkMode() ? ThemeMode.dark : ThemeMode.light,

          // locales
          supportedLocales: supportedLocales,
          locale: locale.getLocale(),
          localizationsDelegates: localizationsDelegate,

          localeResolutionCallback: (locale, supportedLocales) {
            return supportedLocales.contains(locale)
                ? locale
                : defaultLocale;
          },

          // routes
          home: UserPreferences.isLocaleSelected()
              ? const HomepageScreen()
              : const WelcomeScreen(),


          routes: {
            WelcomeScreen.route: (context) => const WelcomeScreen(),
            HomepageScreen.route: (context) => const HomepageScreen(),
            SettingsScreen.route: (context) => const SettingsScreen(),
            QrScanScreen.route: (context) => const QrScanScreen(),
            MedicationDetailsScreen.route: (context) => const MedicationDetailsScreen(),
            SubstitutionListScreen.route: (context) => const SubstitutionListScreen(),
            QrScreen.route: (context) => const QrScreen(),
          },
        );
      }),
    );
  }
}
