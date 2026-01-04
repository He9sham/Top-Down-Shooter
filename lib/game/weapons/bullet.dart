import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_games/game/config/game_config.dart';
import 'package:flutter_games/game/wavefall_game.dart';

class Bullet extends CircleComponent with HasGameReference<WaveFallGame> {
  Bullet({required this.direction, required Vector2 position})
    : super(
        position: position,
        radius: GameConfig.bulletRadius,
        paint: Paint()..color = const Color(0xFFFFCC00), // Gold/Yellow color
        anchor: Anchor.center,
      );

  final Vector2 direction;
  final double _speed = GameConfig.bulletSpeed;

  @override
  void update(double dt) {
    super.update(dt);

    // Move bullet
    position.add(direction * _speed * dt);

    // Optimization: Remove if too far from player/camera
    // Using simple distance check for now.
    // Ideally, check collision with world bounds or screen bounds.
    if (_isOffScreen()) {
      removeFromParent();
    }
  }

  bool _isOffScreen() {
    // Basic check: if far outside world bounds
    // Or simpler: distance from camera center
    final cameraCenter = game.camera.viewfinder.position;
    return position.distanceTo(cameraCenter) >
        1000; // Arbitrary cull distance (~screen height + buffer)
  }
}
