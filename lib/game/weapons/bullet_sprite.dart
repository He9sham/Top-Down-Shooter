import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_games/game/config/game_config.dart';
import 'package:flutter_games/game/wavefall_game.dart';

/// Enhanced Bullet component with sprite and glow effect
class BulletSprite extends SpriteComponent with HasGameReference<WaveFallGame> {
  BulletSprite({
    required this.direction,
    required Vector2 position,
    this.damage = 1.0,
  }) : super(position: position, size: Vector2(16, 16), anchor: Anchor.center);

  final Vector2 direction;
  final double damage;
  final double _speed = GameConfig.bulletSpeed;

  // Glow effect component
  CircleComponent? _glowEffect;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Load bullet sprite
    sprite = await game.loadSprite('bullets/bullet.png');

    // Add glow effect
    _glowEffect = CircleComponent(
      radius: 12,
      anchor: Anchor.center,
      paint: Paint()
        ..color = const Color(0xFFFFCC00).withValues(alpha: 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );
    add(_glowEffect!);

    // Rotate bullet to face direction
    angle = direction.angleToSigned(Vector2(0, -1));
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Move bullet
    position.add(direction * _speed * dt);

    // Optimization: Remove if too far from player/camera
    if (_isOffScreen()) {
      removeFromParent();
    }
  }

  bool _isOffScreen() {
    // Basic check: if far outside world bounds
    final cameraCenter = game.camera.viewfinder.position;
    return position.distanceTo(cameraCenter) >
        1000; // Arbitrary cull distance (~screen height + buffer)
  }

  /// Get damage value for collision detection
  double getDamage() => damage;
}
