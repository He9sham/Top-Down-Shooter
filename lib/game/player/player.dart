import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_games/game/config/game_config.dart';
import 'package:flutter_games/game/wavefall_game.dart';
import 'package:flutter_games/game/weapons/bullet.dart';

class PlayerComponent extends CircleComponent
    with HasGameReference<WaveFallGame> {
  PlayerComponent({required this.joystick})
    : super(
        radius: 20,
        paint: Paint()..color = Colors.white,
        anchor: Anchor.center,
      );

  final JoystickComponent joystick;

  // Movement tuning (mobile-friendly)
  static const double _speed = 260.0;

  // World bounds (should match world size in WaveFallGame)
  static const double _worldHalfSize = 1000.0;

  // Stats & Multipliers
  double _currentHealth = 100.0;
  double _maxHealth = 100.0;
  double _damageMultiplier = 1.0;
  double _fireRateMultiplier = 1.0;
  double _speedMultiplier = 1.0;

  // Auto-Fire
  Vector2 _lastDirection = Vector2(0, -1);
  double _timeSinceLastShot = 0.0;

  @override
  void update(double dt) {
    super.update(dt);
    _handleMovement(dt);
    _handleShooting(dt);
  }

  void _handleMovement(double dt) {
    final movement = joystick.relativeDelta;

    // No input
    if (movement.isZero()) return;

    // Update last direction only when moving
    _lastDirection = movement.normalized();

    // Normalize for consistent speed in all directions
    final currentSpeed = _speed * _speedMultiplier;
    final delta = movement.normalized() * currentSpeed * dt;
    position.add(delta);

    // Clamp inside world bounds
    position.clamp(
      Vector2(-_worldHalfSize + radius, -_worldHalfSize + radius),
      Vector2(_worldHalfSize - radius, _worldHalfSize - radius),
    );
  }

  void _handleShooting(double dt) {
    _timeSinceLastShot += dt;

    // Apply fire rate multiplier (higher multiplier = faster fire rate / lower interval)
    final currentFireInterval = GameConfig.fireRate / _fireRateMultiplier;

    if (_timeSinceLastShot >= currentFireInterval) {
      _fireBullet();
      _timeSinceLastShot = 0.0;
    }
  }

  void _fireBullet() {
    game.world.add(
      Bullet(
        direction: _lastDirection,
        position: position + (_lastDirection * (radius + 5)),
      ),
    );
  }

  // --- UPGRADE METHODS ---

  void upgradeHealth(double percent) {
    final increase = _maxHealth * percent;
    _maxHealth += increase;
    _currentHealth += increase;
  }

  void upgradeSpeed(double percent) {
    _speedMultiplier += percent;
  }

  void upgradeDamage(double percent) {
    _damageMultiplier += percent;
  }

  void upgradeFireRate(double percent) {
    _fireRateMultiplier += percent;
  }
}
