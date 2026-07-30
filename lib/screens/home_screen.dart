import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../data/palette.dart';
import '../state/game_controller.dart';
import '../widgets/top_bar.dart';

class HomeScreen extends StatelessWidget {
  final GameController controller;
  final VoidCallback onOpenStudio;

  const HomeScreen({super.key, required this.controller, required this.onOpenStudio});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(28, 24, 28, 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const _VanityMirror(),
            const SizedBox(height: 14),
            Text('YOUR BEAUTY STUDIO',
                style: TextStyle(
                  fontSize: 12,
                  letterSpacing: 3,
                  fontWeight: FontWeight.w500,
                  color: GlowColors.mauveDeep,
                )),
            const SizedBox(height: 4),
            const Text('Glow Lab',
                style: TextStyle(
                  fontFamily: 'serif',
                  fontWeight: FontWeight.w600,
                  fontSize: 46,
                  height: 1,
                  color: GlowColors.plum,
                )),
            const SizedBox(height: 10),
            const SizedBox(
              width: 280,
              child: Text(
                'A customer walks in with a vibe in mind. Pick the right foundation, blush, lip and glow to nail the look.',
                textAlign: TextAlign.center,
                style: TextStyle(color: GlowColors.plumSoft, fontSize: 15, height: 1.5),
              ),
            ),
            const SizedBox(height: 24),
            GlowButton(label: 'Open Studio', onPressed: onOpenStudio),
            const SizedBox(height: 18),
            Text(
              '5 customers today · unlock new products with coins',
              style: TextStyle(fontSize: 12.5, color: GlowColors.plumSoft),
            ),
          ],
        ),
      ),
    );
  }
}

/// Round vanity mirror ringed with little warm bulbs.
class _VanityMirror extends StatelessWidget {
  const _VanityMirror();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 170,
      height: 170,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // bulbs
          for (int i = 0; i < 14; i++)
            Align(
              alignment: Alignment(
                math.cos(i / 14 * 2 * math.pi) * 0.95,
                math.sin(i / 14 * 2 * math.pi) * 0.95,
              ),
              child: Container(
                width: 11,
                height: 11,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const RadialGradient(
                    center: Alignment(-0.3, -0.4),
                    colors: [Colors.white, Color(0xFFFBE6A8)],
                  ),
                  boxShadow: [
                    BoxShadow(color: const Color(0xFFF7D98A).withValues(alpha: 0.9), blurRadius: 8),
                  ],
                ),
              ),
            ),
          // mirror
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.elliptical(75, 75),
                bottom: Radius.elliptical(72, 72),
              ),
              gradient: const RadialGradient(
                center: Alignment(0, -0.6),
                radius: 0.9,
                colors: [Colors.white, Color(0xFFFBEFEC), Color(0xFFF3DDDA)],
              ),
              border: Border.all(color: Colors.white, width: 6),
              boxShadow: [
                BoxShadow(color: GlowColors.mauve, blurRadius: 0, spreadRadius: 2),
                BoxShadow(
                  color: GlowColors.plum.withValues(alpha: 0.35),
                  blurRadius: 30,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
