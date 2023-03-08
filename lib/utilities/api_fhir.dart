import 'dart:convert';

import 'package:fhir/r5.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:unicom_healthcare/entities/medication.dart' as app_medication;


class ResourcesNames {
  static const String medicinalProductDefinition = "MedicinalProductDefinition";
  static const String administrableProductDefinition = "AdministrableProductDefinition";
  static const String ingredient = "Ingredient";
  static const String regulatedAuthorization = "RegulatedAuthorization";
  static const String organization = "Organization";
}

class ApiFhir {
  late final String serverUrl;
  late final String substitutionUrl;

  static ApiFhir instance = ApiFhir();
  static var headers = {'Content-type': 'application/fhir+json'};

  static init({required String serverUrl, required String substitutionUrl}){
    instance.serverUrl = serverUrl;
    instance.substitutionUrl = substitutionUrl;
  }

  static Uri getUri(String baseUrl, String endpoint, Map<String, dynamic>? queryParameters){
    List<String> url = baseUrl.split("://");
    String protocol = url[0];
    String serverUrl = url[1];
    if (protocol.toLowerCase() == 'https') {
      return Uri.https(serverUrl, endpoint, queryParameters);
    }
    return Uri.http(serverUrl, endpoint, queryParameters);

  }

  static Future<MedicinalProductDefinition> getMedicinalProductDefinitionById(String id) async {
    var response = await http.get(getUri(instance.serverUrl, '/fhir/${ResourcesNames.medicinalProductDefinition}/$id', null), headers: headers);
    return MedicinalProductDefinition.fromJson(jsonDecode(response.body));
  }

  static Future<MedicinalProductDefinition> getMedicinalProductDefinition(Map<String, dynamic>? queryParameters) async {
    var response = await http.get(getUri(instance.serverUrl, '/fhir/${ResourcesNames.medicinalProductDefinition}', queryParameters), headers: headers);
    return MedicinalProductDefinition.fromJson(jsonDecode(response.body));
  }

  static Future<Ingredient> getIngredient(Map<String, dynamic>? queryParameters) async {
    var response = await http.get(getUri(instance.serverUrl, '/fhir/${ResourcesNames.ingredient}', queryParameters), headers: headers);
    Bundle ingredientSearchSet = Bundle.fromJson(jsonDecode(response.body));
    return Ingredient.fromJson(ingredientSearchSet.entry![0].resource!.toJson());
  }

  static Future<AdministrableProductDefinition> getAdministrableProductDefinition(Map<String, dynamic>? queryParameters) async {
    var response = await http.get(getUri(instance.serverUrl, '/fhir/${ResourcesNames.administrableProductDefinition}', queryParameters), headers: headers);
    Bundle administrableProductDefinitionSearchSet = Bundle.fromJson(jsonDecode(response.body));
    return AdministrableProductDefinition.fromJson(administrableProductDefinitionSearchSet.entry![0].resource!.toJson());
  }

  static Future<RegulatedAuthorization> getRegulatedAuthorization(Map<String, dynamic>? queryParameters) async {
    var response = await http.get(getUri(instance.serverUrl, '/fhir/${ResourcesNames.regulatedAuthorization}', queryParameters), headers: headers);
    Bundle regulatedAuthorizationSearchSet = Bundle.fromJson(jsonDecode(response.body));
    return RegulatedAuthorization.fromJson(regulatedAuthorizationSearchSet.entry![0].resource!.toJson());
  }

  static Future<Organization> getOrganizationById(String id) async {
    var response = await http.get(getUri(instance.serverUrl, '/fhir/${ResourcesNames.organization}/$id', null), headers: headers);
    return Organization.fromJson(jsonDecode(response.body));
  }

  static app_medication.Medication getMedicationByMPD(MedicinalProductDefinition mpd){
    return app_medication.Medication.compiled(
      id: mpd.id.toString(),
      mpid: mpd.identifier![0].value!,
      name: mpd.name[0].productName!,
    );
  }

  static Future<app_medication.Medication> getMedicationById(String id) async {
    var headers = {'Content-type': 'application/fhir+json'};

    var response = await http.get(getUri(instance.serverUrl, '/fhir/${ResourcesNames.medicinalProductDefinition}/$id', null), headers: headers);
    var jsonResponse = jsonDecode(response.body);
    MedicinalProductDefinition medicinalProductDefinition = MedicinalProductDefinition.fromJson(jsonResponse);
    var country = jsonResponse['name'][0]['usage'][0]['country']['coding'][0]['display'];

    response = await http.get(getUri(instance.serverUrl, '/fhir/${ResourcesNames.ingredient}', {'for': id}), headers: headers);
    Bundle ingredientSearchSet = Bundle.fromJson(jsonDecode(response.body));
    Ingredient ingredient = Ingredient.fromJson(ingredientSearchSet.entry![0].resource!.toJson());

    response = await http.get(getUri(instance.serverUrl, '/fhir/${ResourcesNames.administrableProductDefinition}', {'form-of': id}), headers: headers);
    Bundle administrableProductDefinitionSearchSet = Bundle.fromJson(jsonDecode(response.body));
    AdministrableProductDefinition administrableProductDefinition = AdministrableProductDefinition.fromJson(administrableProductDefinitionSearchSet.entry![0].resource!.toJson());

    response = await http.get(getUri(instance.serverUrl, '/fhir/${ResourcesNames.regulatedAuthorization}', {'subject': id}), headers: headers);
    Bundle regulatedAuthorizationSearchSet = Bundle.fromJson(jsonDecode(response.body));
    RegulatedAuthorization regulatedAuthorization = RegulatedAuthorization.fromJson(regulatedAuthorizationSearchSet.entry![0].resource!.toJson());

    response = await http.get(getUri(instance.serverUrl, '/fhir/${regulatedAuthorization.holder!.reference}', null), headers: headers);
    Organization organization = Organization.fromJson(jsonDecode(response.body));

    IngredientStrength ingredientStrength = ingredient.substance.strength![0];
    IngredientReferenceStrength? ingredientReferenceStrength = ingredientStrength.referenceStrength?[0];
    Ratio? ratio = ingredientStrength.concentrationRatio ?? ingredientReferenceStrength?.strengthRatio;

    String referenceStrength = "Unknown";
    if (ratio != null){
      referenceStrength = "${ratio.numerator?.value} ${ratio.numerator?.unit} / ";
      referenceStrength += "${ratio.denominator?.value} ${ratio.denominator?.unit}";
    }

    return app_medication.Medication.fromMap({
      'id': id,
      'mpid': medicinalProductDefinition.identifier?[0].value ?? 'Unknown',
      'name': medicinalProductDefinition.name[0].productName,
      'substanceName': ingredient.substance.code.concept?.coding![0].display ?? 'Unknown',
      'moietyName': '',
      'administrableDoseForm': medicinalProductDefinition.combinedPharmaceuticalDoseForm?.coding?[0].display ?? 'Unknown',
      'productUnitOfPresentation': administrableProductDefinition.unitOfPresentation?.coding?[0].display ?? 'Unknown',
      'routesOfAdministration': administrableProductDefinition.routeOfAdministration[0].code.coding?[0].display ?? 'Unknown',
      'referenceStrength': referenceStrength,
      'marketingAuthorizationHolderLabel': organization.name ?? 'Unknown',
      'country': country ?? 'Unknown',
    });

  }

  static Future<List<app_medication.Medication>> getMedicationsByPrefix(String prefix) async {
    var headers = {'Content-type': 'application/fhir+json'};

    var queryParameters = {'name': prefix};
    Uri uri = getUri(instance.serverUrl, '/fhir/${ResourcesNames.medicinalProductDefinition}', queryParameters);

    var response = await http.get(uri, headers: headers);
    Bundle medicinalProductDefinitionSearchSet = Bundle.fromJson(jsonDecode(response.body));

    List<app_medication.Medication> ret = [];
    MedicinalProductDefinition mpd;
    for (var element in medicinalProductDefinitionSearchSet.entry!) {
      if (element.resource == null) continue;
      mpd = MedicinalProductDefinition.fromJson(element.resource!.toJson());
      ret.add( app_medication.Medication(
          id: mpd.id!.toString(),
          mpid: mpd.identifier![0].value!,
          name: mpd.name[0].productName!,
          substanceName: '',
          moietyName: '',
          administrableDoseForm: mpd.combinedPharmaceuticalDoseForm!.coding![0].display!,
          productUnitOfPresentation: '',
          routesOfAdministration: '',
          referenceStrength: '',
          marketingAuthorizationHolderLabel: '',
          country: mpd.name[0].countryLanguage![0].country.coding![0].display!,
      ));
    }
    return ret;
  }

  static Future<Bundle> getSubstitutions(
    {
      required String doseformCode,
      required String languageCode,
      required String substanceCode
    }) async {

    List<String> ids = ["AMLaccord-10mg-Tablet-SE-IS-MedicinalProductDefinition", "LantusSolostar-EE-MPD", "AMLmedvalley-10mg-Tablet-SE-IS-MedicinalProductDefinition", "Hipres-5mg-Tablet-EE-MPD", "AMLbluefish-5mg-Tablet-SE-IS-MedicinalProductDefinition", "Betaklav-500mg-125mg-EE-MPD", "Paracetamol-Kabi-10mg-1ml-solinj-EE-MPD", "Lodipin-10mg-Capsule-GR-MPD", "Amlodistad-10mg-Tablet-SE-IS-MedicinalProductDefinition", "Agen-5mg-Tablet-EE-MPD", "AMLbluefish-10mg-Tablet-SE-IS-MedicinalProductDefinition", "AMLteva-10mg-Tablet-SE-IS-MedicinalProductDefinition", "AMLteva-5mg-Tablet-SE-IS-MedicinalProductDefinition", "Cefuroxime-MIP-1500mg-EE-MPD", "CefuroximStragen-1.5g-Powder-SE-IS-MedicinalProductDefinition", "Hipres-10mg-Tablet-EE-MPD", "Clexane-60mg-06ml-solinj-EE-MPD", "AMLsandoz-5mg-Tablet-SE-IS-MedicinalProductDefinition", "Panodil500mgoralsolutionsachet-SE-PLC-MPD",];

    var errors = [];

    List<BundleEntry?> entries = await Future.wait(ids.map((id) async {
      var response = await http.get(getUri(instance.serverUrl, '/fhir/${ResourcesNames.medicinalProductDefinition}/$id', null), headers: headers);
      var jsonResponse = jsonDecode(response.body);

      try {
        return BundleEntry(resource: MedicinalProductDefinition.fromJson(jsonResponse));
      } catch (e) {
        errors.add({jsonResponse['id']: e});
      }
    }).toList());

    return Bundle(entry: entries.whereType<BundleEntry>().toList());
  }

  static Future<List<app_medication.Medication>> getSubstitutionsMedications({
    required List<app_medication.Medication> medications,
  }) async {

    List<app_medication.Medication> substitutions = [];

    for (var m in medications) {
      substitutions.add(await ApiFhir.getMedicationById(m.id));
    }
    return substitutions;
  }
}

