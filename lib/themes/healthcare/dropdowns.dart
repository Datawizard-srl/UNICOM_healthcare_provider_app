import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:unicom_healthcare/themes/healthcare/colors.dart';

class BaseDropdown extends StatefulWidget {
  final LinkedHashMap<String, Widget> dropdownItems;
  final ValueChanged<String?>? onChanged;
  final String? selected;

  const BaseDropdown({super.key, required this.dropdownItems, this.onChanged, this.selected});

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
        color: Theme.of(context).colorScheme.background,
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
