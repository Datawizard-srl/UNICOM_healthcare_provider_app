import 'package:flutter/material.dart';

import 'abstacts.dart';

class PrimaryButton extends AbsButton {
  const PrimaryButton({super.key, required super.onPressed, required super.child, super.backgroundColor, super.disabledColor});

  bool _isEnabled() { return super.onPressed != null;}
  MaterialStatePropertyAll<Color> _getColor(Color color) {return MaterialStatePropertyAll<Color>(color);}

  @override
  Widget build(BuildContext context) {
    MaterialStatePropertyAll<Color> backgroundColor;
    if(_isEnabled()){
      backgroundColor = super.backgroundColor == null
          ? _getColor(Theme.of(context).colorScheme.primary)
          : _getColor(super.backgroundColor!);

    } else {
      backgroundColor = super.backgroundColor == null
          ? _getColor(Colors.grey[300]!)
          : _getColor(super.disabledColor!);
    }

    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        foregroundColor: _isEnabled() ? _getColor(Theme.of(context).colorScheme.onPrimary) : _getColor(Colors.grey),
        backgroundColor: backgroundColor,
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          )
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: child,
      )
    );
  }

}
