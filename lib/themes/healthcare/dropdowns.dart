import 'dart:collection';

import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:unicom_healthcare/models/user_preferences_model.dart';
import 'package:unicom_healthcare/themes/healthcare/colors.dart';
import 'package:unicom_healthcare/utilities/locale_utils.dart';

class BaseDropdown extends StatefulWidget {
  final LinkedHashMap<String, Widget> dropdownItems;
  final ValueChanged<String?>? onChanged;
  final String? selected;
  final Color? backgroundColor;

  const BaseDropdown({super.key, required this.dropdownItems, this.onChanged, this.selected, this.backgroundColor});

  @override
  State<BaseDropdown> createState() => _BaseDropdownState();
}

class _BaseDropdownState extends State<BaseDropdown> {
  late String dropdownValue;

  @override
  void initState() {
    if(widget.selected == null || !widget.dropdownItems.containsKey(widget.selected)){
      dropdownValue = widget.dropdownItems.keys.first;
    } else {
      dropdownValue = widget.selected!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? Theme.of(context).colorScheme.background,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: dividerColor)
      ),
      child: DropdownButton(
        underline: const SizedBox(),
        isExpanded: true,
        value: dropdownValue,
        items: widget.dropdownItems.keys.map((key) =>
            DropdownMenuItem<String>(
              value: key,
              child: widget.dropdownItems[key]!,
            )
        ).toList(),
        onChanged: (value) {
          widget.onChanged?.call(value as String);
          setState(() {
            dropdownValue = value as String;
          });
        },
      ),
    );
  }
}

Widget _countryRow(String countryCode, String countryName) {
  return Row(children: [
    CountryFlags.flag(countryCode, height: 20, width: 30),
    const SizedBox(width: 5),
    Text(countryName)]
  );
}

Widget countryDropdown(BuildContext context, UserPreferencesNotifier localePreferences, {bool withNull=true}){
  LinkedHashMap<String, Widget> items;
  if (withNull) {
    items = LinkedHashMap.from({
      '': Text(LocaleUtils.translate(context).commons_SelectCountry),
      'us': _countryRow("us", "United States of America"),
      'it': _countryRow("it", "Italia"),
      'gr': _countryRow("gr", "Ελλάδα"),
    });
  } else {
    items = LinkedHashMap.from({
      'us': _countryRow("us", "United States of America"),
      'it': _countryRow("it", "Italia"),
      'gr': _countryRow("gr", "Ελλάδα"),
    });
  }

  return BaseDropdown(
    backgroundColor: Colors.transparent,
    dropdownItems: items,
    selected: localePreferences.getCountryCode() ?? '',
    onChanged: (value) async => await localePreferences.setCountryCode(value),
  );
}

Widget languageDropdown(BuildContext context, UserPreferencesNotifier localePreferences, {bool withNull=true}){
  LinkedHashMap<String, Widget> items;
  if (withNull) {
    items = LinkedHashMap.from({
      '': Text(LocaleUtils.translate(context).commons_SelectLanguage),
      'en_US': _countryRow("us", "English"),
      'it_IT': _countryRow("it", "Italiano")
    });
  } else {
    items = LinkedHashMap.from({
      'en_US': _countryRow("us", "English"),
      'it_IT': _countryRow("it", "Italiano")
    });
  }
  return BaseDropdown(
    backgroundColor: Colors.transparent,
    dropdownItems: items,
    selected: localePreferences.getLocale().toString(),
    onChanged: (value) async => await localePreferences.setLocaleFromString(value),
  );
}
