import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter_games/game/config/game_config.dart';
import 'package:flutter_games/game/effects/particle_effects.dart';
import 'package:flutter_games/game/wavefall_game.dart';
import 'package:flutter_games/game/weapons/bullet_sprite.dart';

/// Enhanced Player component with sprite, animations, and visual effects
class PlayerSpriteComponent extends SpriteComponent
    with HasGameReference<WaveFallGame> {
  PlayerSpriteComponent({required this.joystick})
    : super(size: Vector2(40, 40), anchor: Anchor.center);

  final JoystickComponent joystick;

  // Movement tuning (mobile-friendly)
  static const double _speed = 260.0;

  // World bounds (should match world size in WaveFallGame)
  static const double _worldHalfSize = 1000.0;

  // Base Stats
  static const double _baseDamage = 10.0;

  // Stats & Multipliers
  double _currentHealth = 100.0;
  double _maxHealth = 100.0;
  double _damageMultiplier = 1.0;
  double _fireRateMultiplier = 1.0;
  double _speedMultiplier = 1.0;

  // Auto-Fire
  Vector2 _lastDirection = Vector2(0, -1);
  double _timeSinceLastShot = 0.0;

  // Engine trail effect
  double _timeSinceLastTrail = 0.0;
  static const double _trailInterval = 0.05;

  // Rotation smoothing
  double _currentAngle = -pi / 2; // Start pointing up
  static const double _rotationSpeed = 8.0;

  // Getters for UI
  double get currentHealth => _currentHealth;
  double get maxHealth => _maxHealth;
  double get healthPercentage => _currentHealth / _maxHealth;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Load player sprite
    sprite = await game.loadSprite('player/player.png');
  }

  @override
  void update(double dt) {
    super.update(dt);
    _handleMovement(dt);
    _handleRotation(dt);
    _handleShooting(dt);
    _handleEngineTrail(dt);
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
      Vector2(-_worldHalfSize + width / 2, -_worldHalfSize + height / 2),
      Vector2(_worldHalfSize - width / 2, _worldHalfSize - height / 2),
    );
  }

  void _handleRotation(double dt) {
    // Calculate target angle based on movement direction
    final targetAngle = atan2(_lastDirection.y, _lastDirection.x) + pi / 2;

    // Smoothly interpolate to target angle
    final angleDiff = _normalizeAngle(targetAngle - _currentAngle);
    _currentAngle += angleDiff * _rotationSpeed * dt;
    _currentAngle = _normalizeAngle(_currentAngle);

    // Apply rotation
    angle = _currentAngle;
  }

  double _normalizeAngle(double angle) {
    while (angle > pi) angle -= 2 * pi;
    while (angle < -pi) angle += 2 * pi;
    return angle;
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
    final bulletOffset = _lastDirection * (height / 2 + 10);
    game.world.add(
      BulletSprite(
        direction: _lastDirection,
        position: position + bulletOffset,
        damage: _baseDamage * _damageMultiplier,
      ),
    );
  }

  void _handleEngineTrail(double dt) {
    _timeSinceLastTrail += dt;

    if (_timeSinceLastTrail >= _trailInterval &&
        !joystick.relativeDelta.isZero()) {
      _timeSinceLastTrail = 0.0;

      // Spawn trail particle behind the ship
      final trailPosition = position - (_lastDirection * (height / 2));
      game.world.add(
        ParticleEffects.createEngineTrail(
          position: trailPosition,
          direction: _lastDirection,
        ),
      );
    }
  }

  /// Reset player state
  void reset() {
    _currentHealth = _maxHealth;
    _timeSinceLastShot = 0.0;
    _timeSinceLastTrail = 0.0;
    position = Vector2.zero();
    _currentAngle = -pi / 2;
  }

  /// Take damage and trigger visual feedback
  void takeDamage(double damage) {
    _currentHealth -= damage;
    if (_currentHealth < 0) _currentHealth = 0;

    // Trigger screen shake
    // Note: This would be called from the game when implementing collision
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
