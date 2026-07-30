import 'package:flutter/material.dart';

/// Design tokens ported from the web prototype
/// (palette: rose / mauve / champagne, "vanity-table luxe").
class GlowColors {
  static const bg = Color(0xFFFBF4F1);
  static const bgGlow = Color(0xFFFCE9E4); // radial highlight at top
  static const card = Color(0xFFFFFDFC);
  static const mauve = Color(0xFFC98B9B);
  static const mauveDeep = Color(0xFFA8607A);
  static const plum = Color(0xFF4A2E3A);
  static const plumSoft = Color(0xFF7A5866);
  static const gold = Color(0xFFC9A24B);
  static const goldSoft = Color(0xFFE8CFA0);
  static const line = Color(0xFFEBD9D6);

  // result accents
  static const pos = Color(0xFF3E8E6E);
  static const neg = Color(0xFFC25B5B);
}

/// Colour "temperature" used for harmony / preference scoring.
enum Temp { cool, neutral, warm }

/// Skin tone ladder — index distance drives the foundation match score.
const List<String> kToneOrder = ['fair', 'light', 'medium', 'tan'];

/// Face base colour per skin tone (drives the painted face).
const Map<String, Color> kToneColor = {
  'fair': Color(0xFFF3D9C9),
  'light': Color(0xFFEAC4A6),
  'medium': Color(0xFFD6A37C),
  'tan': Color(0xFFBE855C),
};
