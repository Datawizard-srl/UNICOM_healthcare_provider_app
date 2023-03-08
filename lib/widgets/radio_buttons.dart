import 'dart:collection';

import 'package:flutter/material.dart';

class RadioButtons extends StatefulWidget {
  final LinkedHashMap<String, Widget> radioButtonItems;
  final ValueChanged<String?>? onChanged;
  final String? selected;
  final EdgeInsetsGeometry? contentPadding;

  const RadioButtons({super.key, required this.radioButtonItems, this.onChanged, this.selected, this.contentPadding});

  @override
  State<RadioButtons> createState() => _RadioButtonsState();
}

class _RadioButtonsState extends State<RadioButtons> {
  late String? currentValue;

  @override
  void initState() {
    currentValue = widget.selected;
    if(currentValue != null) {
      widget.onChanged?.call(currentValue);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.radioButtonItems.keys
        .map((key) => RadioListTile(
          contentPadding: widget.contentPadding ?? const EdgeInsets.all(20),
          title: widget.radioButtonItems[key],
          value: key,
          groupValue: currentValue,
          onChanged: (String? value) {
            setState(() {
              currentValue = value as String;
            });
            widget.onChanged?.call(value as String);
          },
        ))
      .toList(),
    );
  }
}
