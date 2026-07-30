import 'dart:async';
import 'package:flutter/foundation.dart' show ChangeNotifier;
import 'package:shared_preferences/shared_preferences.dart';

import '../data/catalog.dart';
import '../data/models.dart';
import '../logic/score_calculator.dart';

/// Holds all mutable game state and notifies the UI on change.
///
/// Coins + unlocked products are persisted with shared_preferences
/// (the Flutter equivalent of Unity's PlayerPrefs).
class GameController extends ChangeNotifier {
  static const _coinsKey = 'coins';
  static const _unlockedKey = 'unlocked';

  SharedPreferences? _prefs;

  int coins = 0;
  int _index = 0;
  final Set<String> unlocked = {};

  /// Current per-category selection (product key, or null if not chosen yet).
  final Map<Category, String?> selection = {
    Category.foundation: null,
    Category.blush: null,
    Category.lip: null,
    Category.glow: null,
  };

  int timeLeft = ScoreCalculator.timerSeconds;
  Timer? _timer;

  ScoreResult? lastResult;

  Customer get customer => kCustomers[_index];

  /// Load persisted state at startup.
  Future<void> load() async {
    _prefs = await SharedPreferences.getInstance();
    coins = _prefs?.getInt(_coinsKey) ?? 0;
    unlocked
      ..clear()
      ..addAll(_prefs?.getStringList(_unlockedKey) ?? const []);
    notifyListeners();
  }

  Future<void> _persist() async {
    await _prefs?.setInt(_coinsKey, coins);
    await _prefs?.setStringList(_unlockedKey, unlocked.toList());
  }

  bool isUnlocked(Product p) => !p.locked || unlocked.contains(p.key);

  bool get hasFullSelection => selection.values.every((v) => v != null);

  Product? selectedProduct(Category cat) {
    final key = selection[cat];
    return key == null ? null : productByKey(cat, key);
  }

  /// Start a brand-new run from the first customer.
  void startGame() {
    _index = 0;
    _loadCustomer();
  }

  void _loadCustomer() {
    for (final cat in Category.values) {
      selection[cat] = null;
    }
    lastResult = null;
    _startTimer();
    notifyListeners();
  }

  void pick(Category cat, Product p) {
    selection[cat] = p.key;
    notifyListeners();
  }

  /// Returns true if the unlock succeeded, false if not enough coins.
  bool tryUnlock(Product p) {
    if (coins < p.price) return false;
    coins -= p.price;
    unlocked.add(p.key);
    _persist();
    notifyListeners();
    return true;
  }

  void _startTimer() {
    _timer?.cancel();
    timeLeft = ScoreCalculator.timerSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      timeLeft--;
      if (timeLeft <= 0) {
        timeLeft = 0;
        t.cancel();
      }
      notifyListeners();
    });
  }

  /// Score the current look, award coins, stop the timer.
  ScoreResult reveal() {
    _timer?.cancel();
    final result = ScoreCalculator.score(
      customer: customer,
      foundation: selectedProduct(Category.foundation)!,
      blush: selectedProduct(Category.blush)!,
      lip: selectedProduct(Category.lip)!,
      glow: selectedProduct(Category.glow)!,
      timeLeft: timeLeft,
    );
    coins += result.coins;
    lastResult = result;
    _persist();
    notifyListeners();
    return result;
  }

  /// Advance to the next customer. Returns false when the day is over.
  bool nextCustomer() {
    _index++;
    if (_index >= kCustomers.length) {
      _index = 0;
      return false;
    }
    _loadCustomer();
    return true;
  }

  /// How many locked products remain across all categories.
  int get lockedRemaining => kProducts.values
      .expand((list) => list)
      .where((p) => p.locked && !unlocked.contains(p.key))
      .length;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
