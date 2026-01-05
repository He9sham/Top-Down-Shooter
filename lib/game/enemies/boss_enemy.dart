import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:flutter_games/game/effects/particle_effects.dart';
import 'package:flutter_games/game/enemies/enemy.dart';
import 'package:flutter_games/game/wavefall_game.dart';
import 'package:flutter_games/game/weapons/enemy_bullet.dart';

class BossEnemy extends Enemy with HasGameReference<WaveFallGame> {
  BossEnemy({required Vector2 position})
    : super(position: position, size: Vector2(120, 120));

  @override
  double get maxHealth => 500.0; // 10x normal enemy (basic is 30)

  double _currentHealth = 500.0;
  @override
  double get currentHealth => _currentHealth;

  final double _baseSpeed = 40.0; // Slower movement
  double _currentSpeed = 40.0;

  // Timers for behaviors
  late Timer _attackTimer;
  late Timer _dashTimer;
  late Timer _dashDurationTimer;
  bool _isDashing = false;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Load boss sprite - using tank sprite as base or a distinct one if available
    // For now, using tank but scaled up visually via size
    sprite = await game.loadSprite('enemies/enemy_tank.png');

    // Set up attack patterns
    _attackTimer = Timer(2.0, onTick: _radialAttack, repeat: true);
    _dashTimer = Timer(5.0, onTick: _startDash, repeat: true);
    _dashDurationTimer = Timer(1.0, onTick: _stopDash);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _attackTimer.update(dt);
    _dashTimer.update(dt);
    _dashDurationTimer.update(dt);

    final player = game.player;
    final direction = (player.position - position).normalized();

    // Move toward player
    position.add(direction * _currentSpeed * dt);

    // Rotate to face player
    angle = direction.angleToSigned(Vector2(0, -1));
  }

  void _radialAttack() {
    const bulletCount = 12;
    for (int i = 0; i < bulletCount; i++) {
      final angle = (i * 2 * math.pi) / bulletCount;
      final direction = Vector2(math.cos(angle), math.sin(angle));

      game.world.add(
        EnemyBullet(
          position: position.clone(),
          direction: direction,
          speed: 150,
          damage: 10,
        ),
      );
    }
  }

  void _startDash() {
    if (_isDashing) return;

    _isDashing = true;
    _currentSpeed = _baseSpeed * 4; // Rapid dash

    // Visual feedback for dash
    add(
      ColorEffect(
        Colors.redAccent,
        EffectController(duration: 0.5, alternate: true, repeatCount: 1),
        opacityTo: 0.5,
      )..removeOnFinish = true,
    );

    // End dash after 1 second
    _dashDurationTimer.start();
  }

  void _stopDash() {
    _currentSpeed = _baseSpeed;
    _isDashing = false;
  }

  @override
  void takeDamage(double damage) {
    _currentHealth -= damage;

    // Flash effect
    add(
      ColorEffect(
        Colors.white,
        EffectController(duration: 0.1, alternate: true, repeatCount: 1),
        opacityTo: 0.8,
      )..removeOnFinish = true,
    );

    // Sparkles
    game.world.add(
      ParticleEffects.createHitEffect(
        position: position,
        color: Colors.purpleAccent,
      ),
    );

    if (_currentHealth <= 0) {
      _die();
    }
  }

  void _die() {
    // Big explosion
    game.world.add(
      ParticleEffects.createExplosion(
        position: position,
        color: Colors.purple,
        particleCount: 100,
        size: 8.0,
      ),
    );

    removeFromParent();
  }

  @override
  double getDamage() => 30.0;
}
