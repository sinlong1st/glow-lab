import '../data/catalog.dart';
import '../data/models.dart';
import '../data/palette.dart';

/// One line in the score breakdown.
class ScoreRow {
  final String label;
  final int points;
  final String detail;
  const ScoreRow(this.label, this.points, this.detail);
}

/// Full result of scoring a look.
class ScoreResult {
  final List<ScoreRow> rows;
  final int total;
  final int stars;
  final int coins;
  const ScoreResult(this.rows, this.total, this.stars, this.coins);
}

/// Pure scoring logic, ported from the prototype. No UI / no state here —
/// this is the part that's trivial to unit-test.
class ScoreCalculator {
  static const int timerSeconds = 30;

  /// Score a complete look. [timeLeft] is seconds remaining (0..30).
  static ScoreResult score({
    required Customer customer,
    required Product foundation,
    required Product blush,
    required Product lip,
    required Product glow,
    required int timeLeft,
  }) {
    final rows = <ScoreRow>[
      _foundation(customer, foundation),
      _preference(blush, customer.preferredBlush),
      _preference(lip, customer.preferredLip),
      _preference(glow, customer.preferredGlow),
      _harmony(blush, lip, glow),
      ScoreRow('Time bonus', ((timeLeft / timerSeconds) * 15).round(), '${timeLeft}s left'),
    ];

    final total = rows.fold<int>(0, (sum, r) => sum + r.points);
    final stars = total >= 95 ? 3 : total >= 65 ? 2 : total >= 35 ? 1 : 0;
    final coins = (total / 4).round();
    return ScoreResult(rows, total, stars, coins < 0 ? 0 : coins);
  }

  /// Foundation: tone distance is punished hard (like real life), undertone is a bonus.
  static ScoreRow _foundation(Customer c, Product p) {
    var pts = 0;
    String detail;
    final dist = (kToneOrder.indexOf(p.tone!) - kToneOrder.indexOf(c.skinTone)).abs();
    if (dist == 0) {
      pts += 30;
      detail = 'tone match';
    } else if (dist == 1) {
      pts += 10;
      detail = 'off by 1 shade';
    } else {
      pts -= 20;
      detail = 'tone way off';
    }
    if (p.undertone == c.undertone) {
      pts += 10;
      detail += ', undertone right';
    } else {
      detail += ', wrong undertone';
    }
    return ScoreRow(p.category.label, pts, detail);
  }

  /// Blush / lip / glow vs the customer's preferred key.
  static ScoreRow _preference(Product chosen, String preferredKey) {
    final preferred = productByKey(chosen.category, preferredKey);
    int pts;
    String detail;
    if (chosen.key == preferredKey) {
      pts = 20;
      detail = 'exactly right';
    } else if (chosen.temp != Temp.neutral && chosen.temp == preferred.temp) {
      pts = 8;
      detail = 'same temperature';
    } else {
      pts = 3;
      detail = 'not quite';
    }
    return ScoreRow(chosen.category.label, pts, detail);
  }

  /// Color harmony: non-neutral temps of blush/lip/glow should all match.
  static ScoreRow _harmony(Product blush, Product lip, Product glow) {
    final temps = [blush.temp, lip.temp, glow.temp].where((t) => t != Temp.neutral).toList();
    final allSame = temps.every((t) => t == temps.first);
    return ScoreRow('Color harmony', allSame ? 10 : 0, allSame ? 'in sync' : 'a bit clashing');
  }
}
