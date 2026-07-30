import 'package:flutter/material.dart';

import '../data/catalog.dart';
import '../data/models.dart';
import '../data/palette.dart';
import '../state/game_controller.dart';
import '../widgets/face_preview.dart';
import '../widgets/top_bar.dart';

class GameScreen extends StatelessWidget {
  final GameController controller;
  final VoidCallback onReveal;

  const GameScreen({super.key, required this.controller, required this.onReveal});

  @override
  Widget build(BuildContext context) {
    final c = controller.customer;
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 4, 18, 16),
      child: Column(
        children: [
          _RequestCard(customer: c, timeLeft: controller.timeLeft),
          const SizedBox(height: 12),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildFace(),
                  const SizedBox(height: 8),
                  for (final cat in Category.values) _CategoryRow(controller: controller, category: cat),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          GlowButton(
            label: 'Reveal look',
            expand: true,
            onPressed: () {
              if (!controller.hasFullSelection) {
                _toast(context, 'Pick all 4 products first');
                return;
              }
              onReveal();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFace() {
    final c = controller.customer;
    final blush = controller.selectedProduct(Category.blush);
    final lip = controller.selectedProduct(Category.lip);
    final glow = controller.selectedProduct(Category.glow);
    final isBronze = glow?.key == 'bronze';
    final lipShine = lip != null && (lip.key == 'gloss' || lip.key == 'oil');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: FacePreview(
        skin: kToneColor[c.skinTone]!,
        blush: blush?.swatch,
        glow: glow?.swatch,
        glowOpacity: isBronze ? 0.5 : 0.75,
        lip: lip?.swatch ?? const Color(0xFFC97D7E),
        lipShine: lipShine,
      ),
    );
  }

  static void _toast(BuildContext context, String msg) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        backgroundColor: GlowColors.plum,
        duration: const Duration(milliseconds: 1600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      ));
  }
}

class _RequestCard extends StatelessWidget {
  final Customer customer;
  final int timeLeft;
  const _RequestCard({required this.customer, required this.timeLeft});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Colors.white, Color(0xFFFDF3F0)]),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: GlowColors.line),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(customer.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 13, color: GlowColors.mauveDeep)),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(customer.tags,
                          style: const TextStyle(
                              fontSize: 11, color: GlowColors.plumSoft, fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text('"${customer.request}"',
                    style: const TextStyle(
                        fontFamily: 'serif',
                        fontStyle: FontStyle.italic,
                        fontSize: 16,
                        height: 1.25,
                        color: GlowColors.plum)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            children: [
              const Text('⏱', style: TextStyle(fontSize: 13)),
              Text('$timeLeft',
                  style: const TextStyle(
                      fontFamily: 'serif', fontSize: 20, fontWeight: FontWeight.w600, color: GlowColors.plum)),
            ],
          ),
        ],
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  final GameController controller;
  final Category category;
  const _CategoryRow({required this.controller, required this.category});

  @override
  Widget build(BuildContext context) {
    final products = kProducts[category]!;
    final selectedKey = controller.selection[category];
    final chosen = controller.selectedProduct(category);

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(category.label.toUpperCase(),
                    style: const TextStyle(
                        fontSize: 11,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w600,
                        color: GlowColors.mauveDeep)),
                Text(chosen?.name ?? 'pick one',
                    style: const TextStyle(fontSize: 12, color: GlowColors.plumSoft, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          const SizedBox(height: 5),
          SizedBox(
            height: 56,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: products.length,
              separatorBuilder: (_, _) => const SizedBox(width: 9),
              itemBuilder: (context, i) {
                final p = products[i];
                return _Swatch(
                  product: p,
                  selected: selectedKey == p.key,
                  locked: !controller.isUnlocked(p),
                  onTap: () {
                    if (!controller.isUnlocked(p)) {
                      final ok = controller.tryUnlock(p);
                      _toast(context, ok ? 'Unlocked ${p.name} 🎉' : 'Need ${p.price} coins to unlock');
                    } else {
                      controller.pick(category, p);
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  static void _toast(BuildContext context, String msg) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        backgroundColor: GlowColors.plum,
        duration: const Duration(milliseconds: 1600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      ));
  }
}

class _Swatch extends StatelessWidget {
  final Product product;
  final bool selected;
  final bool locked;
  final VoidCallback onTap;

  const _Swatch({
    required this.product,
    required this.selected,
    required this.locked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        width: 48,
        height: 48,
        transform: selected ? Matrix4.translationValues(0, -2, 0) : Matrix4.identity(),
        decoration: BoxDecoration(
          color: product.swatch,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: [
            BoxShadow(
              color: selected ? GlowColors.mauveDeep : GlowColors.line,
              blurRadius: selected ? 8 : 1,
              spreadRadius: selected ? 1.5 : 1,
            ),
          ],
        ),
        child: locked
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.lock_outline, size: 14, color: GlowColors.plum),
                    Text('${product.price}',
                        style: const TextStyle(
                            fontSize: 9, fontWeight: FontWeight.w600, color: GlowColors.plum)),
                  ],
                ),
              )
            : Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xC7FFFFFF),
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(11)),
                  ),
                  child: Text(
                    product.shortLabel,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: GlowColors.plum.withValues(alpha: 0.7)),
                  ),
                ),
              ),
      ),
    );
  }
}
