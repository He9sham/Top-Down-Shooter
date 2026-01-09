import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_games/game/enemies/boss_enemy.dart';
import 'package:flutter_games/game/game_enums.dart';
import 'package:flutter_games/game/player/player_sprite.dart';
import 'package:flutter_games/game/wavefall_game.dart';

/// Enhanced HUD component with health bar and wave counter
class GameHud extends PositionComponent with HasGameReference<WaveFallGame> {
  GameHud() : super(priority: 100);

  late TextComponent _healthText;
  late TextComponent _waveText;
  late RectangleComponent _healthBarBackground;
  late RectangleComponent _healthBarFill;
  late PauseButton _pauseButton;

  // Boss Health Bar
  late RectangleComponent _bossHealthBarBackground;
  late RectangleComponent _bossHealthBarFill;
  late TextComponent _bossHealthText;
  bool _isBossBarVisible = false;

  static const double _barWidth = 200.0;
  static const double _barHeight = 20.0;
  static const double _bossBarWidth = 400.0;
  static const double _bossBarHeight = 15.0;
  static const double _padding = 20.0;

  int currentWave = 1;
  int enemiesRemaining = 0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final viewportWidth = game.camera.viewport.size.x;

    // Pause Button
    _pauseButton = PauseButton()
      ..position = Vector2(viewportWidth - 50, _padding);
    add(_pauseButton);

    // Player Health bar background
    _healthBarBackground = RectangleComponent(
      position: Vector2(_padding, _padding),
      size: Vector2(_barWidth, _barHeight),
      paint: Paint()
        ..color = Colors.red.withValues(alpha: 0.3)
        ..style = PaintingStyle.fill,
    );
    add(_healthBarBackground);

    // Player Health bar fill
    _healthBarFill = RectangleComponent(
      position: Vector2(_padding, _padding),
      size: Vector2(_barWidth, _barHeight),
      paint: Paint()
        ..shader = const LinearGradient(
          colors: [Colors.green, Colors.lightGreen],
        ).createShader(const Rect.fromLTWH(0, 0, _barWidth, _barHeight))
        ..style = PaintingStyle.fill,
    );
    add(_healthBarFill);

    // Health bar border
    add(
      RectangleComponent(
        position: Vector2(_padding, _padding),
        size: Vector2(_barWidth, _barHeight),
        paint: Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      ),
    );

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

    // Boss Health Bar (Hidden by default)
    final bossX = (viewportWidth - _bossBarWidth) / 2;
    _bossHealthBarBackground = RectangleComponent(
      position: Vector2(bossX, 70),
      size: Vector2(_bossBarWidth, _bossBarHeight),
      paint: Paint()..color = Colors.black.withValues(alpha: 0.5),
    );

    _bossHealthBarFill = RectangleComponent(
      position: Vector2(bossX, 60),
      size: Vector2(_bossBarWidth, _bossBarHeight),
      paint: Paint()..color = Colors.purpleAccent,
    );

    _bossHealthText = TextComponent(
      text: 'BOSS',
      anchor: Anchor.center,
      position: Vector2(viewportWidth / 2, 50),
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.purpleAccent,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        ),
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Player Health
    final player = game.player;
    if (player is PlayerSpriteComponent) {
      final healthPercent = player.healthPercentage;
      _healthBarFill.size.x = _barWidth * healthPercent;
      _healthText.text =
          'HP: ${player.currentHealth.toInt()}/${player.maxHealth.toInt()}';
      _updateHealthBarColor(healthPercent);
    }

    // Wave text
    final waveStr = 'Wave: $currentWave';
    final enemiesStr = enemiesRemaining > 0
        ? 'Enemies: $enemiesRemaining'
        : 'WAVE CLEARED!';
    _waveText.text = '$waveStr | $enemiesStr';

    // Boss Health
    final bosses = game.world.children.whereType<BossEnemy>().toList();
    if (bosses.isNotEmpty) {
      final boss = bosses.first;
      if (!_isBossBarVisible) {
        add(_bossHealthBarBackground);
        add(_bossHealthBarFill);
        add(_bossHealthText);
        _isBossBarVisible = true;
      }

      _bossHealthBarFill.size.x = _bossBarWidth * boss.healthPercentage;
      _bossHealthText.text = 'BOSS HP: ${boss.currentHealth.toInt()}';
    } else if (_isBossBarVisible) {
      _bossHealthBarBackground.removeFromParent();
      _bossHealthBarFill.removeFromParent();
      _bossHealthText.removeFromParent();
      _isBossBarVisible = false;
    }
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
      ).createShader(const Rect.fromLTWH(0, 0, _barWidth, _barHeight))
      ..style = PaintingStyle.fill;
  }

  /// Update wave information
  void updateWave(int wave, int enemies) {
    currentWave = wave;
    enemiesRemaining = enemies;
  }
}

class PauseButton extends PositionComponent
    with TapCallbacks, HasGameReference<WaveFallGame> {
  PauseButton() : super(size: Vector2(40, 40), anchor: Anchor.topRight);

  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Draw pause icon (two vertical bars)
    canvas.drawRect(const Rect.fromLTWH(10, 10, 6, 20), paint);
    canvas.drawRect(const Rect.fromLTWH(24, 10, 6, 20), paint);

    // Draw border
    final borderPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRect(Rect.fromLTWH(0, 0, width, height), borderPaint);
  }

  @override
  void onTapDown(TapDownEvent event) {
    try {
      // ignore: avoid_dynamic_calls
      (game as dynamic).changeState(GameState.paused);
    } catch (e) {
      debugPrint('Error pausing game: $e');
    }
  }
}
