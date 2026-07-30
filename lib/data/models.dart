import 'package:flutter/material.dart';
import 'palette.dart';

/// Product categories in the order they appear in the picker.
enum Category { foundation, blush, lip, glow }

extension CategoryLabel on Category {
  String get label {
    switch (this) {
      case Category.foundation:
        return 'Foundation';
      case Category.blush:
        return 'Blush';
      case Category.lip:
        return 'Lip';
      case Category.glow:
        return 'Glow';
    }
  }
}

/// A single makeup product. Mirrors the prototype's product objects.
///
/// [tone] and [undertone] are only meaningful for foundation.
/// [temp] is only meaningful for blush / lip / glow (color harmony).
@immutable
class Product {
  final Category category;
  final String key;
  final String name;
  final Color swatch;
  final String? tone;
  final String? undertone;
  final Temp? temp;
  final bool locked;
  final int price;

  const Product({
    required this.category,
    required this.key,
    required this.name,
    required this.swatch,
    this.tone,
    this.undertone,
    this.temp,
    this.locked = false,
    this.price = 0,
  });

  /// Short label shown on the swatch (first word of the name).
  String get shortLabel => name.split(' ').first;
}

/// A customer with a request and their hidden "correct" preferences.
@immutable
class Customer {
  final String name;
  final String request;
  final String skinTone;
  final String undertone;
  final String occasion;
  final String preferredBlush;
  final String preferredLip;
  final String preferredGlow;

  const Customer({
    required this.name,
    required this.request,
    required this.skinTone,
    required this.undertone,
    required this.occasion,
    required this.preferredBlush,
    required this.preferredLip,
    required this.preferredGlow,
  });

  String get tags => '$skinTone · $undertone · $occasion';
}
