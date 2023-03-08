import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unicom_healthcare/database/local_storage/user_preferences.dart';
import 'package:unicom_healthcare/models/user_preferences_model.dart';
import 'package:unicom_healthcare/themes/healthcare/dropdowns.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'homepage_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static const route = "/welcome";

  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    String welcomeString =
        AppLocalizations.of(context)!.welcome_text; //.i18n();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildWelcomeHeaderPanel(context),
            buildWelcomeBodyPanel(context, welcomeString),
          ],
        ),
      ),
    );
  }

  Widget buildWelcomeHeaderPanel(context) {
    return SizedBox(
      height: 252,
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(45.0),
                child: SizedBox(
                    width: 85, child: Image.asset('assets/splashscreen/branding.png')),
              ),
            ),
            Center(
              child: Text(
                AppLocalizations.of(context)!.welcome_title,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildWelcomeBodyPanel(BuildContext context, String welcomeString) {
    const Radius borderRadius = Radius.circular(30);

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadiusDirectional.only(
              topStart: borderRadius,
              topEnd: borderRadius,
            ),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.shadow,
                offset: Offset.zero,
                spreadRadius: 0,
                blurRadius: 30,
              )
            ]),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 320),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    welcomeString,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  Consumer<UserPreferencesNotifier>(
                    builder: (context, localePreferences, child) {
                      return BaseDropdown(
                        dropdownItems: LinkedHashMap.from({
                          'en_US': const Text('English'),
                          'it_IT': const Text('Italiano'),
                        }),
                        selected: localePreferences.getLocale().toString(),
                        onChanged: (value) async => await localePreferences.setLocaleFromString(value!),
                      );
                    }
                  ),
                  Consumer<UserPreferencesNotifier>(
                      builder: (context, localePreferences, child) {
                      return ElevatedButton(
                        onPressed: () async {
                          UserPreferences.setLocaleSelected(true);
                          Navigator.popAndPushNamed(context, HomepageScreen.route);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text(AppLocalizations.of(context)!.button_next),
                        ),
                      );
                    }
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
