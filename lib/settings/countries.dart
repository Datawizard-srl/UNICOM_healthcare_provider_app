import 'package:country_flags/country_flags.dart';
import 'package:fhir/r5.dart';
import 'package:flutter/material.dart';
import 'package:unicom_healthcare/utilities/api_fhir.dart';

class CodeSystemIds {
  static String countries = 'country-ema-cs';
  static String languages = 'language-ema-cs';
  static String substances = 'substance-sms-cs';
  static String doseforms = 'pharmaceutical-dose-form-ema-cs';
}

// countries for substitutions
const Map<String, String> countries = {
  'Italian Republic': 'it',
  'United States of America': 'us',
  'Hellenic Republic': 'gr',
};

const Map<String, String> languageMapping = {
  'it': 'Italian',
  'us': 'English',
  'gr': 'Greek',
};

class Languages {
  static Map<String, String> codes = {};

  static Future<void> initCodes() async {
    assert (countries.length == languageMapping.length);

    var jsonResponse = await ApiFhir.getResource(resourceType: ResourcesNames.codeSystem, id: CodeSystemIds.languages);
    CodeSystem countriesCodeSystem = CodeSystem.fromJson(jsonResponse);
    for (CodeSystemConcept concept in countriesCodeSystem.concept!){
      codes[concept.display!] = concept.code.toString();
    }
  }

  static String getNameFromISOCode(String isoCode){
    return languageMapping[isoCode]!;
  }

  static String getCodeFromISOCode(String isoCode){
    return codes[getNameFromISOCode(isoCode)]!;
  }
}

class Countries {
  static Map<String, String> codes = {};

  static Future<void> initCodes() async {
    assert (countries.length == languageMapping.length);

    var jsonResponse = await ApiFhir.getResource(resourceType: ResourcesNames.codeSystem, id: CodeSystemIds.countries);
    CodeSystem countriesCodeSystem = CodeSystem.fromJson(jsonResponse);
    for (CodeSystemConcept concept in countriesCodeSystem.concept!){
      codes[concept.display!] = concept.code.toString();
    }
  }

  static Widget getFlag(String country, {double height=20, double width=30}){
    String? countryCode = countries[country];
    if (countryCode == null){
      return const Icon(Icons.question_mark, size: 10);
    }
    return CountryFlags.flag(countryCode, height: height, width: width);
  }
}

class Substances {
  static Map<String, String> codes = {};

  static Future<void> initCodes() async {
    var jsonResponse = await ApiFhir.getResource(resourceType: ResourcesNames.codeSystem, id: CodeSystemIds.substances);
    CodeSystem substanceCodeSystem = CodeSystem.fromJson(jsonResponse);
    for (CodeSystemConcept concept in substanceCodeSystem.concept!){
      codes[concept.display!] = concept.code.toString();
    }
  }
}

class DoseForms {
  static Map<String, String> codes = {};

  static Future<void> initCodes() async {
    var jsonResponse = await ApiFhir.getResource(resourceType: ResourcesNames.codeSystem, id: CodeSystemIds.doseforms);
    CodeSystem substanceCodeSystem = CodeSystem.fromJson(jsonResponse);
    for (CodeSystemConcept concept in substanceCodeSystem.concept!){
      codes[concept.display!] = concept.code.toString();
    }
  }
}

