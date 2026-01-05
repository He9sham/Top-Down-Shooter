import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:flutter_games/game/effects/particle_effects.dart';
import 'package:flutter_games/game/enemies/enemy.dart';
import 'package:flutter_games/game/wavefall_game.dart';

/// Enemy type enumeration
enum EnemyType { basic, fast, tank }

/// Base enemy component with sprite and AI
class EnemySprite extends Enemy with HasGameReference<WaveFallGame> {
  EnemySprite({required this.enemyType, required Vector2 position})
    : super(
        position: position,
        anchor: Anchor.center,
        size: Vector2(
          32,
          32,
        ), // Default size, will be updated in _initializeStats
      ) {
    _initializeStats();
  }

  final EnemyType enemyType;
  @override
  double get maxHealth => _maxHealth;
  @override
  double get currentHealth => _currentHealth;
  @override
  double getDamage() => _damage;

  // Stats based on type
  late double _maxHealth;
  late double _currentHealth;
  late double _speed;
  late double _damage;
  late Vector2 _size;
  late String _spritePath;
  late Color _particleColor;

  void _initializeStats() {
    switch (enemyType) {
      case EnemyType.basic:
        _maxHealth = 30.0;
        _speed = 100.0;
        _damage = 10.0;
        _size = Vector2(32, 32);
        _spritePath = 'enemies/enemy_basic.png';
        _particleColor = Colors.green;
        break;
      case EnemyType.fast:
        _maxHealth = 15.0;
        _speed = 180.0;
        _damage = 5.0;
        _size = Vector2(28, 28);
        _spritePath = 'enemies/enemy_fast.png';
        _particleColor = Colors.red;
        break;
      case EnemyType.tank:
        _maxHealth = 80.0;
        _speed = 60.0;
        _damage = 20.0;
        _size = Vector2(48, 48);
        _spritePath = 'enemies/enemy_tank.png';
        _particleColor = Colors.purple;
        break;
    }
    _currentHealth = _maxHealth;
    size = _size;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Load enemy sprite
    sprite = await game.loadSprite(_spritePath);
  }

  @override
  void update(double dt) {
    super.update(dt);

    // AI: Chase player
    final player = game.player;

    final direction = (player.position - position).normalized();
    position.add(direction * _speed * dt);

    // Rotate to face player
    angle = direction.angleToSigned(Vector2(0, -1));

    // Remove if too far from camera (optimization)
    if (_isOffScreen()) {
      removeFromParent();
    }
  }

  bool _isOffScreen() {
    final cameraCenter = game.camera.viewfinder.position;
    return position.distanceTo(cameraCenter) > 1500;
  }

  /// Take damage from bullet
  @override
  void takeDamage(double damage) {
    _currentHealth -= damage;

    // Visual feedback: Flash white
    add(
      ColorEffect(
        Colors.white,
        EffectController(duration: 0.1, alternate: true, repeatCount: 1),
        opacityTo: 0.8,
      )..removeOnFinish = true,
    );

    // Spawn hit particle effect
    game.world.add(
      ParticleEffects.createHitEffect(
        position: position,
        color: _particleColor,
      ),
    );

    if (_currentHealth <= 0) {
      _die();
    }
  }

  void _die() {
    // Spawn explosion particle effect
    game.world.add(
      ParticleEffects.createExplosion(
        position: position,
        color: _particleColor,
        particleCount: enemyType == EnemyType.tank ? 30 : 20,
        size: enemyType == EnemyType.tank ? 4.0 : 3.0,
      ),
    );

    // Remove enemy
    removeFromParent();
  }
}
