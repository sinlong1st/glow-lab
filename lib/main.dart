import 'package:flutter/material.dart';

import 'data/palette.dart';
import 'screens/home_screen.dart';
import 'screens/game_screen.dart';
import 'screens/result_screen.dart';
import 'state/game_controller.dart';
import 'widgets/top_bar.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const GlowLabApp());
}

/// The three in-app screens (no Navigator — a single shell that swaps bodies,
/// matching the web prototype's structure).
enum Screen { home, game, result }

class GlowLabApp extends StatelessWidget {
  const GlowLabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Glow Lab',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: GlowColors.bg,
        colorScheme: ColorScheme.fromSeed(
          seedColor: GlowColors.mauve,
          primary: GlowColors.mauveDeep,
          surface: GlowColors.card,
        ),
      ),
      home: const GlowLabShell(),
    );
  }
}

class GlowLabShell extends StatefulWidget {
  const GlowLabShell({super.key});

  @override
  State<GlowLabShell> createState() => _GlowLabShellState();
}

class _GlowLabShellState extends State<GlowLabShell> {
  final GameController controller = GameController();
  Screen _screen = Screen.home;

  @override
  void initState() {
    super.initState();
    controller.load();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _go(Screen screen) => setState(() => _screen = screen);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final Widget body;
        switch (_screen) {
          case Screen.home:
            body = HomeScreen(
              controller: controller,
              onOpenStudio: () {
                controller.startGame();
                _go(Screen.game);
              },
            );
            break;
          case Screen.game:
            body = GameScreen(
              controller: controller,
              onReveal: () {
                controller.reveal();
                _go(Screen.result);
              },
            );
            break;
          case Screen.result:
            body = ResultScreen(
              controller: controller,
              onNext: () {
                final more = controller.nextCustomer();
                _go(more ? Screen.game : Screen.home);
              },
            );
            break;
        }

        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                GlowTopBar(coins: controller.coins),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    child: KeyedSubtree(key: ValueKey(_screen), child: body),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
