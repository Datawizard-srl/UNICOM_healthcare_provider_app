import 'package:flutter/material.dart';

final ColorScheme appColorsLight = ColorScheme.fromSwatch().copyWith(
  brightness: Brightness.light,
  primary: const Color(0xff06bdd5),
  background: const Color(0xffe4f2f4),
  secondary: const Color(0xffbbe8ec),
  outline: const Color(0xff555555),
  shadow: const Color(0x1111110a),
  onBackground: Colors.black,
  onSurfaceVariant: const Color(0xff1757be),
);

final ColorScheme appColorsDark = ColorScheme.fromSwatch().copyWith(
  brightness: Brightness.dark,
  primary: const Color(0xff033a41),
  background: const Color(0xff575c5d),
  secondary: const Color(0xff647b7e),
  outline: const Color(0xff555555),
  shadow: const Color(0x11FFFF00),
  onBackground: Colors.white,
  onSurfaceVariant: const Color(0xff06bdd5),
);

const Color dividerColor = Color(0x94a2a266);