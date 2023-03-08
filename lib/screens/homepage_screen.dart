import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:unicom_healthcare/app_icons_icons.dart';
import 'package:unicom_healthcare/screens/qr_scan_screen.dart';
import 'package:unicom_healthcare/screens/settings_screen.dart';


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
      onPressed: (){ Navigator.pushNamed(context, QrScanScreen.route); },
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
