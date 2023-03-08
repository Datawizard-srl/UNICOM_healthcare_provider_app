import 'dart:collection';

import 'package:flutter/material.dart';

class AccordionTileItem {
  final Key? key;
  final Widget? leading;
  final Widget title;
  final Widget? subtitle;
  final ValueChanged<bool>? onExpansionChanged;
  final List<Widget> children;
  final Color? backgroundColor;
  final Color? collapsedBackgroundColor;
  final Widget? trailing;
  final bool maintainState;
  final EdgeInsetsGeometry? tilePadding;
  final Alignment? expandedAlignment;
  final CrossAxisAlignment? expandedCrossAxisAlignment;
  final EdgeInsetsGeometry? childrenPadding;
  final Color? iconColor;
  final Color? collapsedIconColor;
  final Color? textColor;
  final Color? collapsedTextColor;
  final ListTileControlAffinity? controlAffinity;

  const AccordionTileItem({
    this.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.onExpansionChanged,
    this.children = const <Widget>[],
    this.trailing,
    this.maintainState = false,
    this.tilePadding,
    this.expandedCrossAxisAlignment,
    this.expandedAlignment,
    this.childrenPadding,
    this.backgroundColor,
    this.collapsedBackgroundColor,
    this.textColor,
    this.collapsedTextColor,
    this.iconColor,
    this.collapsedIconColor,
    this.controlAffinity,
  }) :
  assert( expandedCrossAxisAlignment != CrossAxisAlignment.baseline,
      'CrossAxisAlignment.baseline is not supported since the expanded children '
      'are aligned in a column, not a row. Try to use another constant.',
  );


}

class AccordionsTile extends StatefulWidget {
  final LinkedHashMap<String, AccordionTileItem> accordionItems;
  final String? selected;
  final void Function(String panelKey, bool isOpen)? expansionCallback;
  final bool allowMultipleOpen;
  final Widget Function(BuildContext context, String key)? separatorBuilder;

  const AccordionsTile({
    super.key,
    required this.accordionItems,
    this.selected,
    this.expansionCallback,
    this.allowMultipleOpen=false,
    this.separatorBuilder,
  });

  @override
  State<AccordionsTile> createState() => _AccordionsTileState();
}

class _AccordionsTileState extends State<AccordionsTile> {
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
    List<String> keys = widget.accordionItems.keys.toList();
    return Expanded(
      child: ListView.separated(
        itemCount: widget.accordionItems.length,
        separatorBuilder: (context, index){
          if (widget.separatorBuilder != null){
            return widget.separatorBuilder!(context, keys[index]);
          }
          return const SizedBox(height: 0);
        },
        itemBuilder: (context, index) {
          String key = keys[index];
          AccordionTileItem accordionItem = widget.accordionItems[key]!;
          return Column(
            children: [
              ExpansionTile(
                key: accordionItem.key,
                title: accordionItem.title,
                initiallyExpanded: _expandedPanels[key]!,
                backgroundColor: accordionItem.backgroundColor,
                subtitle: accordionItem.subtitle,
                trailing: accordionItem.trailing,
                leading: accordionItem.leading,
                childrenPadding: accordionItem.childrenPadding,
                collapsedBackgroundColor: accordionItem.collapsedBackgroundColor,
                collapsedIconColor: accordionItem.collapsedIconColor,
                collapsedTextColor: accordionItem.collapsedTextColor,
                controlAffinity: accordionItem.controlAffinity,
                expandedAlignment: accordionItem.expandedAlignment,
                expandedCrossAxisAlignment: accordionItem.expandedCrossAxisAlignment,
                iconColor: accordionItem.iconColor,
                maintainState: accordionItem.maintainState,
                textColor: accordionItem.textColor,
                tilePadding: accordionItem.tilePadding,
                onExpansionChanged: (value) {
                  if(widget.expansionCallback != null){
                    widget.expansionCallback!(key, value);
                  }
                  if(accordionItem.onExpansionChanged != null) {
                    accordionItem.onExpansionChanged!(value);
                  }
                  if(!widget.allowMultipleOpen) {
                    setState(() {
                      //TODO not working
                      closeAll();
                    });
                  }
                },
                children: accordionItem.children,

              ),
            ],
          );
        },


      ),
    );
    return Column(
      children: widget.accordionItems.keys
        .map((String key) {
          AccordionTileItem accordionItem = widget.accordionItems[key]!;
          return ExpansionTile(
            key: accordionItem.key,
            title: accordionItem.title,
            initiallyExpanded: _expandedPanels[key]!,
            backgroundColor: accordionItem.backgroundColor,
            subtitle: accordionItem.subtitle,
            trailing: accordionItem.trailing,
            leading: accordionItem.leading,
            childrenPadding: accordionItem.childrenPadding,
            collapsedBackgroundColor: accordionItem.collapsedBackgroundColor,
            collapsedIconColor: accordionItem.collapsedIconColor,
            collapsedTextColor: accordionItem.collapsedTextColor,
            controlAffinity: accordionItem.controlAffinity,
            expandedAlignment: accordionItem.expandedAlignment,
            expandedCrossAxisAlignment: accordionItem.expandedCrossAxisAlignment,
            iconColor: accordionItem.iconColor,
            maintainState: accordionItem.maintainState,
            textColor: accordionItem.textColor,
            tilePadding: accordionItem.tilePadding,
            onExpansionChanged: (value) {
              if(widget.expansionCallback != null){
                widget.expansionCallback!(key, value);
              }
              if(accordionItem.onExpansionChanged != null) {
                accordionItem.onExpansionChanged!(value);
              }
              if(!widget.allowMultipleOpen) {
                setState(() {
                  //TODO not working
                  closeAll();
                });
              }
            },
            children: accordionItem.children,

          );
        }).toList(),
    );
  }
}
