import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_games/game/ui/upgrade_menu.dart';
import 'package:flutter_games/game/wavefall_game_enhanced.dart';

void main() {
  runApp(const WaveFallApp());
}

class WaveFallApp extends StatelessWidget {
  const WaveFallApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WaveFall - Top Down Shooter',
      theme: ThemeData.dark(),
      home: const GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final WaveFallGameEnhanced _game;

  @override
  void initState() {
    super.initState();
    _game = WaveFallGameEnhanced();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget(
        game: _game,
        overlayBuilderMap: {
          'UpgradeMenu': (context, game) {
            return UpgradeMenuOverlay(game: game as WaveFallGameEnhanced);
          },
        },
      ),
    );
  }
}
