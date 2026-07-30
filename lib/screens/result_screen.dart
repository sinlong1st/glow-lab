import 'package:flutter/material.dart';

import '../data/palette.dart';
import '../logic/score_calculator.dart';
import '../state/game_controller.dart';
import '../widgets/top_bar.dart';

class ResultScreen extends StatelessWidget {
  final GameController controller;
  final VoidCallback onNext;

  const ResultScreen({super.key, required this.controller, required this.onNext});

  static const _titles = ['Try again', 'Not bad', 'Looking good!', 'Gorgeous!'];
  static const _subs = [
    'The customer is not convinced',
    'The customer thinks it is okay',
    'The customer is quite happy',
    'The customer loves this look',
  ];

  @override
  Widget build(BuildContext context) {
    final result = controller.lastResult;
    if (result == null) return const SizedBox.shrink();
    final stars = result.stars;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(26, 16, 26, 24),
        child: Column(
          children: [
            _Stars(count: stars),
            const SizedBox(height: 6),
            Text(_titles[stars],
                style: const TextStyle(
                    fontFamily: 'serif', fontWeight: FontWeight.w600, fontSize: 30, color: GlowColors.plum)),
            const SizedBox(height: 2),
            Text(_subs[stars],
                style: const TextStyle(color: GlowColors.plumSoft, fontSize: 14)),
            const SizedBox(height: 16),
            _ScoreCard(result: result),
            const SizedBox(height: 16),
            Text.rich(TextSpan(children: [
              const TextSpan(text: '+ ', style: TextStyle(color: GlowColors.plumSoft, fontSize: 15)),
              TextSpan(
                  text: '${result.coins}',
                  style: const TextStyle(
                      fontFamily: 'serif', fontSize: 22, color: Color(0xFF8A6A1E), fontWeight: FontWeight.w600)),
              const TextSpan(text: ' coins', style: TextStyle(color: GlowColors.plumSoft, fontSize: 15)),
            ])),
            const SizedBox(height: 18),
            GlowButton(label: 'Next customer', onPressed: onNext),
            const SizedBox(height: 12),
            Text(
              controller.lockedRemaining > 0
                  ? '${controller.lockedRemaining} products still locked. Save coins and unlock them in the picker.'
                  : 'All products unlocked. Fabulous!',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: GlowColors.plumSoft, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}

/// Renders [count] gold stars out of 3, the rest greyed out.
class _Stars extends StatelessWidget {
  final int count;
  const _Stars({required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        3,
        (i) => Text('★',
            style: TextStyle(
                fontSize: 34,
                letterSpacing: 6,
                color: i < count ? GlowColors.gold : GlowColors.line)),
      ),
    );
  }
}

class _ScoreCard extends StatelessWidget {
  final ScoreResult result;
  const _ScoreCard({required this.result});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFFDF6F4),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: GlowColors.line),
      ),
      child: Column(
        children: [
          for (final row in result.rows) _row(row.label, row.detail, row.points),
          const Divider(height: 1, color: GlowColors.line),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                Text('${result.total}',
                    style: const TextStyle(
                        fontFamily: 'serif', fontWeight: FontWeight.w600, fontSize: 16, color: GlowColors.plum)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String detail, int points) {
    final color = points > 0 ? GlowColors.pos : (points < 0 ? GlowColors.neg : GlowColors.plumSoft);
    final sign = points > 0 ? '+' : '';
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 9),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: GlowColors.line, width: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text.rich(TextSpan(children: [
              TextSpan(text: '$label ', style: const TextStyle(fontSize: 14, color: GlowColors.plum)),
              TextSpan(text: '· $detail', style: const TextStyle(fontSize: 12, color: GlowColors.plumSoft)),
            ])),
          ),
          Text('$sign$points',
              style: TextStyle(fontFamily: 'serif', fontWeight: FontWeight.w600, color: color)),
        ],
      ),
    );
  }
}
