import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_games/game/ui/game_over_menu.dart';
import 'package:flutter_games/game/ui/pause_menu.dart';
import 'package:flutter_games/game/ui/upgrade_menu.dart';
import 'package:flutter_games/game/wavefall_game_enhanced.dart';

class GameView extends StatelessWidget {
  const GameView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
