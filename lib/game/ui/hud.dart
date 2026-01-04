import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_games/game/player/player_sprite.dart';
import 'package:flutter_games/game/wavefall_game.dart';

/// Enhanced HUD component with health bar and wave counter
class GameHud extends PositionComponent with HasGameReference<WaveFallGame> {
  GameHud() : super(priority: 100);

  late TextComponent _healthText;
  late TextComponent _waveText;
  late RectangleComponent _healthBarBackground;
  late RectangleComponent _healthBarFill;

  static const double _barWidth = 200.0;
  static const double _barHeight = 20.0;
  static const double _padding = 20.0;

  int currentWave = 1;
  int enemiesRemaining = 0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Health bar background
    _healthBarBackground = RectangleComponent(
      position: Vector2(_padding, _padding),
      size: Vector2(_barWidth, _barHeight),
      paint: Paint()
        ..color = Colors.red.withValues(alpha: 0.3)
        ..style = PaintingStyle.fill,
    );
    add(_healthBarBackground);

    // Health bar fill
    _healthBarFill = RectangleComponent(
      position: Vector2(_padding, _padding),
      size: Vector2(_barWidth, _barHeight),
      paint: Paint()
        ..shader = LinearGradient(
          colors: [Colors.green, Colors.lightGreen],
        ).createShader(Rect.fromLTWH(0, 0, _barWidth, _barHeight))
        ..style = PaintingStyle.fill,
    );
    add(_healthBarFill);

    // Health bar border
    final healthBarBorder = RectangleComponent(
      position: Vector2(_padding, _padding),
      size: Vector2(_barWidth, _barHeight),
      paint: Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    add(healthBarBorder);

    // Health text
    _healthText = TextComponent(
      text: 'HP: 100/100',
      position: Vector2(_padding + _barWidth + 10, _padding + 5),
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    add(_healthText);

    // Wave text
    _waveText = TextComponent(
      text: 'Wave: 1',
      position: Vector2(_padding, _padding + _barHeight + 15),
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    add(_waveText);
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Update health bar based on player health
    final player = game.player;
    if (player is PlayerSpriteComponent) {
      final healthPercent = player.healthPercentage;
      _healthBarFill.size.x = _barWidth * healthPercent;

      // Update health text
      _healthText.text =
          'HP: ${player.currentHealth.toInt()}/${player.maxHealth.toInt()}';

      // Change health bar color based on health percentage
      _updateHealthBarColor(healthPercent);
    }

    // Update wave text
    _waveText.text = 'Wave: $currentWave | Enemies: $enemiesRemaining';
  }

  void _updateHealthBarColor(double healthPercent) {
    Color startColor;
    Color endColor;

    if (healthPercent > 0.5) {
      startColor = Colors.green;
      endColor = Colors.lightGreen;
    } else if (healthPercent > 0.25) {
      startColor = Colors.orange;
      endColor = Colors.yellow;
    } else {
      startColor = Colors.red;
      endColor = Colors.deepOrange;
    }

    _healthBarFill.paint = Paint()
      ..shader = LinearGradient(
        colors: [startColor, endColor],
      ).createShader(Rect.fromLTWH(0, 0, _barWidth, _barHeight))
      ..style = PaintingStyle.fill;
  }

  /// Update wave information
  void updateWave(int wave, int enemies) {
    currentWave = wave;
    enemiesRemaining = enemies;
  }
}
