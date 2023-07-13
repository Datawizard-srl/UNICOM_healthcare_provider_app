import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:unicom_healthcare/utilities/locale_utils.dart';
import 'package:unicom_healthcare/entities/medication.dart';


class QrScreen extends StatefulWidget {
  static const String route = '/qr_screen';

  const QrScreen({super.key});

  @override
  State<QrScreen> createState() => _QrScreen();
}

class _QrScreen extends State<QrScreen> {
  late Medication _medication;
  late Medication _substitution;

  @override
  void didChangeDependencies() {
    Map<String, dynamic> arguments = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    if (arguments.isEmpty){ return super.didChangeDependencies();}
    if (arguments['medication'] != null) _medication = arguments['medication'] as Medication;
    if (arguments['substitution'] != null) _substitution = arguments['substitution'] as Medication;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(LocaleUtils.translate(context).medicationDetailsScreen_Appbar_Title_Substitution),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildHeader(context),
            QrImageView(
              data: jsonEncode({"medication": _medication.id, "substitution": _substitution.id}),
              version: QrVersions.auto,
              size: 300,
              backgroundColor: Colors.white,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom:50.0),
              child: Text(
                LocaleUtils.translate(context).qrScreen_Info_Text,
                textAlign: TextAlign.center,
              ),
            ),
          ]
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context) {
    return Center(
      child: Column(
          children:[
            Image.asset(
              "assets/images/placeholders/generic_drug.png",
              height: 60,
              width: 60,
              fit: BoxFit.fill,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                '${LocaleUtils.translate(context).commons_Name}:',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top:10),
              child: Text(
                _medication.name,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
            ),
          ]
      ),
    );
  }
}