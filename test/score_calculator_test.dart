import 'package:flutter_test/flutter_test.dart';
import 'package:glow_lab/data/catalog.dart';
import 'package:glow_lab/data/models.dart';
import 'package:glow_lab/logic/score_calculator.dart';

void main() {
  // Mai: fair / neutral / brunch, prefers peach blush, balm lip, pearl glow.
  final mai = kCustomers.first;

  ScoreResult scoreFor({
    required String foundation,
    required String blush,
    required String lip,
    required String glow,
    int timeLeft = 30,
  }) {
    return ScoreCalculator.score(
      customer: mai,
      foundation: productByKey(Category.foundation, foundation),
      blush: productByKey(Category.blush, blush),
      lip: productByKey(Category.lip, lip),
      glow: productByKey(Category.glow, glow),
      timeLeft: timeLeft,
    );
  }

  test('ideal answer scores 3 stars (note: Mai cannot reach 125)', () {
    // 0N Ivory = fair/neutral (tone+undertone match) + all preferences exact.
    // Quirk in prototype data: Mai prefers peach blush (warm) + pearl glow (cool),
    // which clash on temperature -> harmony gives 0 even on the "perfect" answer.
    // foundation 40 + blush 20 + lip 20 + glow 20 + harmony 0 + time 15 = 115
    final r = scoreFor(foundation: '0N', blush: 'peach', lip: 'balm', glow: 'pearl');
    expect(r.total, 115);
    expect(r.stars, 3); // >= 95
    expect(r.coins, 29); // round(115/4)
  });

  test('a fully temperature-matched look can earn the harmony bonus', () {
    // Cool blush (berry) + cool-ish lip + cool glow (pearl) all align.
    final r = scoreFor(foundation: '0N', blush: 'berry', lip: 'gloss', glow: 'pearl');
    final harmony = r.rows.firstWhere((row) => row.label == 'Color harmony');
    expect(harmony.points, 10);
  });

  test('foundation two shades off is penalised', () {
    // 3W Honey = tan (fair is 2 shades away) and warm undertone (wrong).
    final r = scoreFor(foundation: '3W', blush: 'peach', lip: 'balm', glow: 'pearl');
    final fnd = r.rows.firstWhere((row) => row.label == 'Foundation');
    expect(fnd.points, -20);
  });

  test('same-temperature blush gets partial credit', () {
    // Preferred peach (warm); coral is also warm -> 8 points.
    final r = scoreFor(foundation: '0N', blush: 'coral', lip: 'balm', glow: 'pearl');
    final blush = r.rows.firstWhere((row) => row.label == 'Blush');
    expect(blush.points, 8);
  });

  test('time bonus scales with seconds left', () {
    final full = scoreFor(foundation: '0N', blush: 'peach', lip: 'balm', glow: 'pearl', timeLeft: 30);
    final none = scoreFor(foundation: '0N', blush: 'peach', lip: 'balm', glow: 'pearl', timeLeft: 0);
    expect(full.total - none.total, 15);
  });
}
