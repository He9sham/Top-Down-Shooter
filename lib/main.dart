import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_games/game/ui/upgrade_menu.dart';
import 'package:flutter_games/game/wavefall_game.dart';

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
        body: GameWidget<WaveFallGame>(
          game: WaveFallGame(),
          overlayBuilderMap: {
            'UpgradeMenu': (context, game) => UpgradeMenu(game: game),
          },
        ),
      ),
    );
  }
}
