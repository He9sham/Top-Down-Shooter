import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
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

  // World bounds
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
  double _currentAngle = -pi / 2;
  static const double _rotationSpeed = 8.0;

  // Movement smoothing
  Vector2 _velocity = Vector2.zero();
  static const double _friction = 10.0;
  static const double _acceleration = 15.0;
  static const double _deadZone = 0.15;

  // Getters for UI
  double get currentHealth => _currentHealth;
  double get maxHealth => _maxHealth;
  double get healthPercentage => _currentHealth / _maxHealth;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
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
    var delta = joystick.relativeDelta;

    if (delta.length < _deadZone) {
      final frictionFactor = 1.0 - (_friction * dt);
      _velocity.scale(frictionFactor.clamp(0.0, 1.0));
    } else {
      final targetVelocity = delta.normalized() * (_speed * _speedMultiplier);
      _velocity.lerp(targetVelocity, _acceleration * dt);
    }

    position.add(_velocity * dt);

    if (delta.length > _deadZone) {
      _lastDirection = delta.normalized();
    }

    position.clamp(
      Vector2(-_worldHalfSize + width / 2, -_worldHalfSize + height / 2),
      Vector2(_worldHalfSize - width / 2, _worldHalfSize - height / 2),
    );
  }

  void _handleRotation(double dt) {
    if (_lastDirection.isZero()) return;
    final targetAngle = atan2(_lastDirection.y, _lastDirection.x) + pi / 2;
    final angleDiff = _normalizeAngle(targetAngle - _currentAngle);
    _currentAngle += angleDiff * _rotationSpeed * dt;
    _currentAngle = _normalizeAngle(_currentAngle);
    angle = _currentAngle;
  }

  double _normalizeAngle(double angle) {
    while (angle > pi) {
      angle -= 2 * pi;
    }
    while (angle < -pi) {
      angle += 2 * pi;
    }
    return angle;
  }

  void _handleShooting(double dt) {
    _timeSinceLastShot += dt;
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

    _createMuzzleFlash();

    game.camera.viewfinder.add(
      MoveEffect.by(
        Vector2(1.5, 1.5),
        EffectController(duration: 0.04, reverseDuration: 0.04),
      ),
    );
  }

  void _createMuzzleFlash() {
    final muzzlePos = _lastDirection * (height / 2);
    final flash = CircleComponent(
      radius: 4,
      position: muzzlePos + (size / 2),
      paint: Paint()..color = Colors.white,
      anchor: Anchor.center,
    );
    add(flash);
    flash.add(
      OpacityEffect.fadeOut(EffectController(duration: 0.15))
        ..onComplete = () => flash.removeFromParent(),
    );
    flash.add(
      ScaleEffect.by(Vector2.all(2.0), EffectController(duration: 0.1)),
    );
  }

  void _handleEngineTrail(double dt) {
    _timeSinceLastTrail += dt;
    if (_timeSinceLastTrail >= _trailInterval &&
        !joystick.relativeDelta.isZero()) {
      _timeSinceLastTrail = 0.0;
      final trailPosition = position - (_lastDirection * (height / 2));
      game.world.add(
        ParticleEffects.createEngineTrail(
          position: trailPosition,
          direction: _lastDirection,
        ),
      );
    }
  }

  void reset() {
    _currentHealth = _maxHealth;
    _timeSinceLastShot = 0.0;
    _timeSinceLastTrail = 0.0;
    position = game.camera.viewport.virtualSize / 2;
    _currentAngle = -pi / 2;
    _velocity = Vector2.zero();
    _lastDirection = Vector2(0, -1);
  }

  void takeDamage(double damage) {
    _currentHealth -= damage;
    if (_currentHealth < 0) _currentHealth = 0;
  }

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
