import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_games/game/ui/game_over_menu.dart';
import 'package:flutter_games/game/ui/pause_menu.dart';
import 'package:flutter_games/game/ui/upgrade_menu.dart';
import 'package:flutter_games/game/wavefall_game_enhanced.dart';

void main() {
  runApp(const GameApp());
}

class GameApp extends StatelessWidget {
  const GameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wave Fall',
      theme: ThemeData.dark(),
      home: Scaffold(
        body: GameWidget<WaveFallGameEnhanced>(
          game: WaveFallGameEnhanced(),
          overlayBuilderMap: {
            'PauseMenu': (context, game) => PauseMenu(game: game),
            'UpgradeMenu': (context, game) => UpgradeMenu(game: game),
            'GameOverMenu': (context, game) => GameOverMenu(game: game),
          },
        ),
      ),
    );
  }
}
