import 'package:flutter/material.dart';
import 'models.dart';
import 'palette.dart';

/// All products grouped by category (17 base + 3 unlockable),
/// ported 1:1 from the web prototype.
const Map<Category, List<Product>> kProducts = {
  Category.foundation: [
    Product(category: Category.foundation, key: '00', name: '00 Porcelain', tone: 'fair', undertone: 'cool', swatch: Color(0xFFF4DDCF)),
    Product(category: Category.foundation, key: '0N', name: '0N Ivory', tone: 'fair', undertone: 'neutral', swatch: Color(0xFFEFD2BE)),
    Product(category: Category.foundation, key: '1N', name: '1N Beige', tone: 'light', undertone: 'neutral', swatch: Color(0xFFE6C2A4)),
    Product(category: Category.foundation, key: '2N', name: '2N Sand', tone: 'medium', undertone: 'neutral', swatch: Color(0xFFD5A47D)),
    Product(category: Category.foundation, key: '3W', name: '3W Honey', tone: 'tan', undertone: 'warm', swatch: Color(0xFFC68A5C)),
    Product(category: Category.foundation, key: '1W', name: '1W Amber', tone: 'light', undertone: 'warm', swatch: Color(0xFFE3B488), locked: true, price: 30),
  ],
  Category.blush: [
    Product(category: Category.blush, key: 'pink', name: 'Pink', temp: Temp.cool, swatch: Color(0xFFE8A0B4)),
    Product(category: Category.blush, key: 'berry', name: 'Berry', temp: Temp.cool, swatch: Color(0xFFB2506F)),
    Product(category: Category.blush, key: 'coral', name: 'Coral', temp: Temp.warm, swatch: Color(0xFFF0876B)),
    Product(category: Category.blush, key: 'peach', name: 'Peach', temp: Temp.warm, swatch: Color(0xFFF2B79C)),
    Product(category: Category.blush, key: 'mauve', name: 'Mauve', temp: Temp.cool, swatch: Color(0xFFC58AA0), locked: true, price: 40),
  ],
  Category.lip: [
    Product(category: Category.lip, key: 'oil', name: 'Oil', temp: Temp.warm, swatch: Color(0xFFE59A8C)),
    Product(category: Category.lip, key: 'balm', name: 'Balm', temp: Temp.neutral, swatch: Color(0xFFD98B8B)),
    Product(category: Category.lip, key: 'gloss', name: 'Gloss', temp: Temp.cool, swatch: Color(0xFFC95C7A)),
    Product(category: Category.lip, key: 'matte', name: 'Matte', temp: Temp.cool, swatch: Color(0xFFA84A5E)),
  ],
  Category.glow: [
    Product(category: Category.glow, key: 'pearl', name: 'Pearl', temp: Temp.cool, swatch: Color(0xFFF5EFE6)),
    Product(category: Category.glow, key: 'champagne', name: 'Champagne', temp: Temp.warm, swatch: Color(0xFFE8CFA0)),
    Product(category: Category.glow, key: 'rose', name: 'Rose', temp: Temp.cool, swatch: Color(0xFFEBC2C0)),
    Product(category: Category.glow, key: 'bronze', name: 'Bronze', temp: Temp.warm, swatch: Color(0xFFC98A52)),
    Product(category: Category.glow, key: 'holo', name: 'Holo', temp: Temp.cool, swatch: Color(0xFFD9C7E8), locked: true, price: 50),
  ],
};

/// The 5 sample customers from the prototype.
const List<Customer> kCustomers = [
  Customer(name: 'Mai', request: 'Clean girl look for brunch ☕', skinTone: 'fair', undertone: 'neutral', occasion: 'brunch', preferredBlush: 'peach', preferredLip: 'balm', preferredGlow: 'pearl'),
  Customer(name: 'Linh', request: 'Date night, make it glam ✨', skinTone: 'fair', undertone: 'cool', occasion: 'date night', preferredBlush: 'berry', preferredLip: 'gloss', preferredGlow: 'pearl'),
  Customer(name: 'Hà', request: 'Sunny beach day, sun-kissed 🏖️', skinTone: 'tan', undertone: 'warm', occasion: 'beach', preferredBlush: 'coral', preferredLip: 'oil', preferredGlow: 'bronze'),
  Customer(name: 'Trang', request: 'Office meeting, polished & calm', skinTone: 'medium', undertone: 'neutral', occasion: 'office', preferredBlush: 'pink', preferredLip: 'matte', preferredGlow: 'champagne'),
  Customer(name: 'Vy', request: 'Wedding guest, soft glam 💐', skinTone: 'light', undertone: 'warm', occasion: 'wedding', preferredBlush: 'pink', preferredLip: 'gloss', preferredGlow: 'rose'),
];

/// Lookup helper — find a product by category + key.
Product productByKey(Category cat, String key) =>
    kProducts[cat]!.firstWhere((p) => p.key == key);
