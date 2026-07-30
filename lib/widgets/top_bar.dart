import 'package:flutter/material.dart';
import '../data/palette.dart';

/// Serif display style for headings (mimics "Bodoni Moda" in the prototype).
const TextStyle kDisplay = TextStyle(
  fontFamily: 'serif',
  fontWeight: FontWeight.w600,
);

/// Persistent top bar: brand on the left, coin balance on the right.
class GlowTopBar extends StatelessWidget {
  final int coins;
  const GlowTopBar({super.key, required this.coins});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    center: Alignment(-0.4, -0.4),
                    colors: [Colors.white, GlowColors.mauve],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Text('Glow Lab',
                  style: TextStyle(
                      fontFamily: 'serif',
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      letterSpacing: 0.5,
                      color: GlowColors.plum)),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFF6E6), Color(0xFFFBEAD2)],
              ),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: GlowColors.goldSoft),
            ),
            child: Row(
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      center: Alignment(-0.4, -0.4),
                      colors: [Color(0xFFFBE6A8), GlowColors.gold],
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Text('$coins',
                    style: const TextStyle(
                        color: Color(0xFF8A6A1E),
                        fontWeight: FontWeight.w600,
                        fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// The primary pill button used throughout the app.
class GlowButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool expand;
  const GlowButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.expand = false,
  });

  @override
  Widget build(BuildContext context) {
    final button = DecoratedBox(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [GlowColors.mauve, GlowColors.mauveDeep],
        ),
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(
            color: GlowColors.plum.withValues(alpha: 0.25),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
    return expand ? SizedBox(width: double.infinity, child: button) : button;
  }
}
