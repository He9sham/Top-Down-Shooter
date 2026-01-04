import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_games/game/components/background.dart';
import 'package:flutter_games/game/enemies/enemy_sprite.dart';
import 'package:flutter_games/game/player/player_sprite.dart';
import 'package:flutter_games/game/systems/collision_system.dart';
import 'package:flutter_games/game/ui/hud.dart';
import 'package:flutter_games/game/upgrades/upgrade.dart';
import 'package:flutter_games/game/upgrades/upgrade_manager.dart';
import 'package:flutter_games/game/wavefall_game.dart';

/// Enhanced WaveFall Game with visual assets and animations
class WaveFallGameEnhanced extends WaveFallGame {
  WaveFallGameEnhanced();

  bool _isDebugMode = false;

  // Upgrade System
  late final UpgradeManager _upgradeManager;
  List<Upgrade> currentUpgradeOptions = [];

  // HUD
  late final GameHud _hud;

  // Wave System (basic implementation)
  int _currentWave = 1;
  int _enemiesRemaining = 0;
  double _waveTimer = 0.0;

  void toggleDebugMode() {
    _isDebugMode = !_isDebugMode;
    debugMode = _isDebugMode;
  }

  @override
  Color backgroundColor() => const Color(0xFF0a0a1a);

  @override
  FutureOr<void> onLoad() async {
    _upgradeManager = UpgradeManager();

    // Load all images at startup for better performance
    await images.loadAll([
      'player/player.png',
      'enemies/enemy_basic.png',
      'enemies/enemy_fast.png',
      'enemies/enemy_tank.png',
      'bullets/bullet.png',
      'background/space_bg.png',
    ]);

    // Add space background
    world.add(SpaceBackground(worldSize: Vector2(2000, 2000)));

    // Joystick
    final joystick = JoystickComponent(
      knob: CircleComponent(
        radius: 20,
        paint: Paint()..color = Colors.cyan.withValues(alpha: 0.8),
      ),
      background: CircleComponent(
        radius: 60,
        paint: Paint()..color = Colors.cyan.withValues(alpha: 0.2),
      ),
      margin: const EdgeInsets.only(left: 40, bottom: 40),
    );

    // Add joystick to viewport (HUD)
    camera.viewport.add(joystick);

    // Player with sprite
    player = PlayerSpriteComponent(joystick: joystick);
    world.add(player);

    // Camera follow
    camera.follow(player);

    // Add collision system
    world.add(CollisionSystem());

    // Add HUD to viewport
    _hud = GameHud();
    camera.viewport.add(_hud);

    // Spawn initial enemies
    _spawnWave();

    // Initial setup
    debugMode = _isDebugMode;

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Wave management
    _waveTimer += dt;

    // Count remaining enemies
    _enemiesRemaining = world.children.query<EnemySprite>().length;

    // Update HUD
    _hud.updateWave(_currentWave, _enemiesRemaining);

    // Check if wave is complete
    if (_enemiesRemaining == 0 && _waveTimer > 5.0) {
      _nextWave();
    }
  }

  void _spawnWave() {
    _waveTimer = 0.0;

    // Spawn enemies based on wave number
    final enemyCount = 5 + (_currentWave * 2);

    for (int i = 0; i < enemyCount; i++) {
      _spawnEnemy();
    }
  }

  void _spawnEnemy() {
    // Random position around the player
    final angle = (world.children.length * 0.5) % (2 * 3.14159);
    final distance = 400.0 + (world.children.length % 3) * 100;

    final spawnPos =
        player.position + Vector2(distance * cos(angle), distance * sin(angle));

    // Determine enemy type based on wave
    EnemyType type;
    if (_currentWave < 3) {
      type = EnemyType.basic;
    } else if (_currentWave < 6) {
      type = (world.children.length % 2 == 0)
          ? EnemyType.basic
          : EnemyType.fast;
    } else {
      final rand = world.children.length % 3;
      type = rand == 0
          ? EnemyType.basic
          : rand == 1
          ? EnemyType.fast
          : EnemyType.tank;
    }

    world.add(EnemySprite(enemyType: type, position: spawnPos));
  }

  void _nextWave() {
    _currentWave++;

    // Show upgrade menu every 3 waves
    if (_currentWave % 3 == 0) {
      showUpgradeMenu();
    } else {
      _spawnWave();
    }
  }

  void showUpgradeMenu() {
    pauseEngine();
    currentUpgradeOptions = _upgradeManager.getRandomUpgrades(3);
    overlays.add('UpgradeMenu');
  }

  void selectUpgrade(Upgrade upgrade) {
    _upgradeManager.applyUpgrade(player, upgrade);
    overlays.remove('UpgradeMenu');
    currentUpgradeOptions.clear();
    resumeEngine();
    _spawnWave();
  }
}
