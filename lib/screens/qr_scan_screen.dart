import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:unicom_healthcare/screens/medication_details_screen.dart';
import 'package:unicom_healthcare/utilities/api_fhir.dart';

class QrScanScreen extends StatefulWidget {
  static const String route = '/scan_qr';
  const QrScanScreen({Key? key}) : super(key: key);

  @override
  State<QrScanScreen> createState() => _QrScanScreenState();
}

class _QrScanScreenState extends State<QrScanScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Qr Code'), centerTitle: true),
      body: MobileScanner(
          allowDuplicates: false,
          onDetect: (barcode, args) async {
            if (barcode.rawValue == null) {
              debugPrint('Failed to scan Qr Code');
            } else {
              try {
                var rawValue = jsonDecode(barcode.rawValue!);
                ApiFhir.getMedicationById(rawValue["medication"]).then(
                    (medication) {
                      Navigator.popAndPushNamed(
                          context,
                          MedicationDetailsScreen.route,
                          arguments: {'medication': medication}
                      );
                    }
                );

              } catch (error) {
                debugPrint("Invalid Qr code");
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Invalid Qr code"),
                  backgroundColor: Colors.red,
                ));
              }
            }
          }),
    );
  }
}
