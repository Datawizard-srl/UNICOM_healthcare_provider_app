import 'package:flutter/material.dart';
import 'package:unicom_healthcare/generated/app_localizations.dart';
import 'package:unicom_healthcare/app_icons_icons.dart';
import 'package:unicom_healthcare/entities/medication.dart';
import 'package:unicom_healthcare/screens/settings_screen.dart';

import 'package:unicom_healthcare/utilities/api_fhir.dart';


class HomepageScreen extends StatelessWidget {
  static const String route = '/home';
  const HomepageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String appDescription = AppLocalizations.of(context)!.homepage_text;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Unicom"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushNamed(context, SettingsScreen.route);
            },
          )
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(50.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(appDescription, textAlign: TextAlign.center,),
                buildQrButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ElevatedButton buildQrButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        // Apri schermata di scan QR e attendi risultato
        final qrResult = await Navigator.pushNamed(context, '/scan_qr');
        if (qrResult is Map && qrResult['gravitate-unicom-demostrator'] == true) {
          // Se il QR contiene il campo richiesto, mostra la lista farmaci reale
          final substitutions = await ApiFhir.fetchMockMedicationsFromFhir();
          if (substitutions.isNotEmpty) {
            final medication = substitutions.first;
            Navigator.pushNamed(
              context,
              '/substitution_list',
              arguments: {
                'medication': medication,
                'substitutions': substitutions,
              },
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Nessun farmaco trovato dal server FHIR')),
            );
          }
        } else if (qrResult != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('QR non valido per la demo Gravitate-UNICOM'), backgroundColor: Colors.red),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(side: BorderSide(color: Colors.white, width: 3)),
        padding: const EdgeInsets.all(95),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          Icon(AppIcons.qrcode, size: 90),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text("QrCode", style: TextStyle(fontSize: 20)),
          )
        ],
      )
    );
  }
}
