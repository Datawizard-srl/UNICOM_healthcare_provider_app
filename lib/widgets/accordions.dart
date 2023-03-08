import 'dart:collection';

import 'package:flutter/material.dart';

class AccordionItem {
  final Widget body;
  final ExpansionPanelHeaderBuilder headerBuilder;
  final Color? expandedBackgroundColor;
  final Color? closedBackgroundColor;
  final Color? contentBackground;
  final bool canTapOnHeader;

  const AccordionItem({
    required this.headerBuilder,
    required this.body,
    this.canTapOnHeader = true,
    this.expandedBackgroundColor = const Color.fromRGBO(255, 255, 255, 1),
    this.closedBackgroundColor = const Color.fromRGBO(255, 255, 255, 1),
    this.contentBackground = const Color.fromRGBO(255, 255, 255, 1),
  });

}

class Accordions extends StatefulWidget {
  final LinkedHashMap<String, AccordionItem> accordionItems;
  final String? selected;
  final void Function(String panelKey, bool isOpen)? expansionCallback;
  final bool allowMultipleOpen;

  const Accordions({super.key, required this.accordionItems, this.selected, this.expansionCallback, this.allowMultipleOpen=false});

  @override
  State<Accordions> createState() => _AccordionsState();
}

class _AccordionsState extends State<Accordions> {
  late Map<String, bool> _expandedPanels;

  void closeAll(){
    _expandedPanels = { for (var e in widget.accordionItems.keys) e : false };
  }

  @override
  void initState() {
    closeAll();
    if(widget.selected !=  null ) {
      _expandedPanels[widget.selected!] = true;
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      expandedHeaderPadding: EdgeInsets.zero,
      expansionCallback: (i, isOpen) {
        String panelKey = List.from(widget.accordionItems.keys)[i];
        if (!widget.allowMultipleOpen){
          closeAll();
        }
        setState(() {
          _expandedPanels[panelKey] = !isOpen;
        });
        if(widget.expansionCallback != null){
          widget.expansionCallback!(panelKey, isOpen);
        }
      },
      children: widget.accordionItems.keys
        .map((String key) {
          AccordionItem accordionItem = widget.accordionItems[key]!;
          bool isExpanded = _expandedPanels[key]!;
          return ExpansionPanel(
            headerBuilder: accordionItem.headerBuilder,
            body: accordionItem.body,
            isExpanded: isExpanded,
            backgroundColor: isExpanded ? accordionItem.expandedBackgroundColor : accordionItem.closedBackgroundColor,
            canTapOnHeader: accordionItem.canTapOnHeader,
          );
        }).toList(),
    );
  }
}
