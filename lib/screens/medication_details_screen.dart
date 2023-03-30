import 'package:fhir/r5.dart' as fhir_r5;
import 'package:flutter/material.dart';
import 'package:unicom_healthcare/database/local_storage/user_preferences.dart';
import 'package:unicom_healthcare/entities/medication.dart';
import 'package:unicom_healthcare/screens/qr_screen.dart';
import 'package:unicom_healthcare/screens/substitution_list_screen.dart';
import 'package:unicom_healthcare/settings/countries.dart';
import 'package:unicom_healthcare/utilities/api_fhir.dart';
import 'package:unicom_healthcare/utilities/locale_utils.dart';
import 'package:unicom_healthcare/widgets/buttons/primary_button.dart';

class MedicationDetailsScreen extends StatefulWidget {
  static const String route = '/medication_details';

  const MedicationDetailsScreen({super.key});

  @override
  State<MedicationDetailsScreen> createState() =>
      _MedicationDetailsScreenState();
}

class _MedicationDetailsScreenState extends State<MedicationDetailsScreen> {
  late Medication _medication;
  late Medication? _substitutionOf;

  @override
  void didChangeDependencies() {
    Map<String, dynamic> arguments =
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    if (arguments.isEmpty) return super.didChangeDependencies();

    if (arguments['medication'] != null) _medication = arguments['medication'] as Medication;
    if (arguments['substitutionOf'] != null) {_substitutionOf = arguments['substitutionOf'] as Medication;
    } else {
      _substitutionOf = null;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: _substitutionOf != null
            ? Text(LocaleUtils.translate(context).medicationDetailsScreen_Appbar_Title_Substitution)
            : Text(LocaleUtils.translate(context).medicationDetailsScreen_Appbar_Title_Scanned)
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: ListView(
                  children: [
                    buildHeader(context),
                    ...buildInformations(context),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 8),
                      child: Divider(
                        height: 2,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    ...buildSpecificInformations(context),
                  ],
                ),
              ),
            ),
            Column(
              verticalDirection: VerticalDirection.down,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: _substitutionOf != null
                ? [buildQrCodeButton(context)]
                : [buildSubstitutionListButton(context)]
            )
          ],
        ),
      ),
    );
  }

  Widget buildQrCodeButton(BuildContext context) {
    return PrimaryButton(
      onPressed: () {
        Navigator.pushNamed(context,
          QrScreen.route,
          arguments: {"medication": _substitutionOf, "substitution": _medication}
        );
      },
      child: Center(
        child: Text(
          LocaleUtils.translate(context).medicationDetailsScreen_Button_GenerateQrCode,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.background),
        ),
      ),
    );
  }

  Widget buildSubstitutionListButton(BuildContext context) {
    String doseformCode = DoseForms.codes[_medication.administrableDoseForm]!;
    String languageCode = Languages.getCodeFromISOCode(UserPreferences.getCountryCode()!);
    //String languageCode = Countries.codes[_medication.country]!;
    String substanceCode = Substances.codes[_medication.substanceName]!;

    return PrimaryButton(
      onPressed: () async {
        await ApiFhir.getSubstitutions(doseformCode: doseformCode, languageCode: languageCode, substanceCode: substanceCode)
        .then((bundleSubstitutions) {
          List<Medication> substitutions = [];
          if (bundleSubstitutions.entry != null) {
            substitutions = bundleSubstitutions.entry!.map((e) {
              return ApiFhir.getMedicationByMPD(e.resource as fhir_r5.MedicinalProductDefinition);
            }).toList();
          }

          Navigator.pushNamed(context,
            SubstitutionListScreen.route,
            arguments: {
              'medication': _medication,
              'substitutions': substitutions,
            }
          );
        });
        // Medications list
      },
      child: Text(
        LocaleUtils.translate(context).medicationDetailsScreen_Button_GenerateSubstitution,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.background),
      ),
    );
  }

  Widget infoRow(String? label, String? text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          Flexible(
            child: Text(
              text?.toUpperCase() ?? '',
              overflow: TextOverflow.visible,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> buildInformations(BuildContext context) {
    return [
      Align(
        alignment: Alignment.topLeft,
        child: Column(children: [
          infoRow(LocaleUtils.translate(context).commons_Informations, ""),
          infoRow(LocaleUtils.translate(context).commons_Name, _medication.name),
          infoRow(LocaleUtils.translate(context).commons_SubstanceName, _medication.substanceName),
          infoRow(LocaleUtils.translate(context).commons_MoietyName, _medication.moietyName),
        ]),
      )
    ];
  }

  Widget specificInfoRow(String label, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "$label: ",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          Flexible(
            child: Text(
              text,
              overflow: TextOverflow.visible,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> buildSpecificInformations(BuildContext context) {
    return [
      Align(
        alignment: Alignment.topLeft,
        child: Column(children: [
          specificInfoRow(
              LocaleUtils.translate(context).commons_AdministrableDoseForm,
              _medication.administrableDoseForm
          ),
          specificInfoRow(
              LocaleUtils.translate(context).commons_ProductUnitOfPresentation,
              _medication.productUnitOfPresentation
          ),
          specificInfoRow(
              LocaleUtils.translate(context).commons_RoutesOfAdministration,
              _medication.routesOfAdministration
          ),
          specificInfoRow(
              LocaleUtils.translate(context).commons_ReferenceStrength,
              _medication.referenceStrength
          ),
          specificInfoRow(
              LocaleUtils.translate(context).commons_MarketingAuthorizationHolderLabel,
              _medication.marketingAuthorizationHolderLabel
          ),
          specificInfoRow(
              LocaleUtils.translate(context).commons_Country,
              _medication.country
          ),
        ]),
      )
    ];
  }

  Widget buildHeader(BuildContext context) {
    return Center(
      child: Column(children: [
        Image.asset(
          "assets/images/placeholders/generic_drug.png",
          height: 60,
          width: 60,
          fit: BoxFit.fill,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Text(
            '${LocaleUtils.translate(context).commons_Name}:',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 35),
          child: Text(
            _medication.name,
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
        )
      ]),
    );
  }
}