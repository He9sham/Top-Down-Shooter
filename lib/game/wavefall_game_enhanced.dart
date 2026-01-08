import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:flutter_games/game/components/background.dart';
import 'package:flutter_games/game/enemies/boss_enemy.dart';
import 'package:flutter_games/game/enemies/enemy.dart';
import 'package:flutter_games/game/enemies/enemy_sprite.dart';
import 'package:flutter_games/game/game_enums.dart';
import 'package:flutter_games/game/player/player_sprite.dart';
import 'package:flutter_games/game/systems/collision_system.dart';
import 'package:flutter_games/game/ui/hud.dart';
import 'package:flutter_games/game/upgrades/upgrade.dart';
import 'package:flutter_games/game/upgrades/upgrade_manager.dart';
import 'package:flutter_games/game/utils/asset_generator.dart';
import 'package:flutter_games/game/wavefall_game.dart';
import 'package:flutter_games/game/weapons/bullet_sprite.dart';
import 'package:flutter_games/game/weapons/enemy_bullet.dart';

/// A TextComponent that supports opacity effects
class FadingTextComponent extends TextComponent
    with HasPaint
    implements OpacityProvider {
  FadingTextComponent({
    required super.text,
    required super.textRenderer,
    required super.position,
    required super.anchor,
  });

  @override
  double get opacity => paint.color.opacity;

  @override
  set opacity(double value) {
    paint.color = paint.color.withOpacity(value);
    // Also update the text renderer if it's a TextPaint to ensure the text actually fades
    if (textRenderer is TextPaint) {
      final style = (textRenderer as TextPaint).style;
      textRenderer = TextPaint(
        style: style.copyWith(color: style.color?.withOpacity(value)),
      );
    }
  }
}

/// Enhanced WaveFall Game with visual assets and animations
class WaveFallGameEnhanced extends WaveFallGame {
  WaveFallGameEnhanced();

  GameState _gameState = GameState.playing;
  GameState get gameState => _gameState;

  bool _isDebugMode = false;

  // Upgrade System
  late final UpgradeManager _upgradeManager;
  @override
  // ignore: overridden_fields
  List<Upgrade> currentUpgradeOptions = [];

  // HUD
  late final GameHud _hud;

  // Wave System
  int _currentWave = 1;
  int get currentWave => _currentWave;
  int _enemiesRemaining = 0;
  double _waveTimer = 0.0;

  // Wave state management
  bool _isWaveActive = false;
  double _waveCooldownTimer = 0.0;
  static const double _timeBetweenWaves = 3.0;

  // Performance Clamps
  static const int _maxEnemies = 50;
  static const int _maxPlayerBullets = 150;
  static const int _maxEnemyBullets = 75;

  // Time Scale for slow-motion effect
  double _timeScale = 1.0;

  @override
  void toggleDebugMode() {
    _isDebugMode = !_isDebugMode;
    debugMode = _isDebugMode;
  }

  @override
  Color backgroundColor() => const Color(0xFF0a0a1a);

  @override
  @mustCallSuper
  FutureOr<void> onLoad() async {
    _upgradeManager = UpgradeManager();

    // Generate assets programmatically (Image as Code)
    await AssetGenerator.generateAndLoad(this);

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
    await camera.viewport.add(joystick);

    // Player with sprite
    player = PlayerSpriteComponent(joystick: joystick);
    await world.add(player);

    // Camera follow
    camera.follow(player);

    // Add collision system
    await world.add(CollisionSystem());

    // Add HUD to viewport
    _hud = GameHud();
    await camera.viewport.add(_hud);

    // Start first wave after a short delay
    _startWaveCooldown();

    // Initial setup
    debugMode = _isDebugMode;

    // Do NOT call super.onLoad() as it loads the base game assets (duplicates)
    // return super.onLoad();
  }

  void resetGame() {
    _timeScale = 1.0;

    // Clear enemies and bullets
    world.children.whereType<Enemy>().forEach((e) => e.removeFromParent());
    world.children.whereType<BulletSprite>().forEach(
      (b) => b.removeFromParent(),
    );
    world.children.whereType<EnemyBullet>().forEach(
      (b) => b.removeFromParent(),
    );

    // Reset player
    if (player is PlayerSpriteComponent) {
      (player as PlayerSpriteComponent).reset();
    }

    // Reset Wave
    _currentWave = 1;
    _waveTimer = 0.0;
    _isWaveActive = false;

    // Reset State
    changeState(GameState.playing);
    _startWaveCooldown();
  }

  @override
  void update(double dt) {
    // Only update game logic if playing
    if (_gameState != GameState.playing) {
      // Allow minor slow-mo update during death even if state is technically gameOver
      if (_gameState == GameState.gameOver && _timeScale < 1.0) {
        _updateSlowMo(dt);
      }
      return;
    }

    final scaledDt = dt * _timeScale;

    // Check Player Health for Game Over
    if (player is PlayerSpriteComponent &&
        (player as PlayerSpriteComponent).currentHealth <= 0) {
      _triggerPlayerDeath();
      return;
    }

    super.update(scaledDt);

    // Wave management
    if (_isWaveActive) {
      _waveTimer += scaledDt;
      _enemiesRemaining = world.children.whereType<Enemy>().length;

      if (_enemiesRemaining == 0 && _waveTimer > 2.0) {
        _isWaveActive = false;
        _nextWave();
      }
    } else {
      _waveCooldownTimer -= dt; // Real time cooldown
      if (_waveCooldownTimer <= 0) {
        _spawnWave();
      }
    }

    // Update HUD
    _hud.updateWave(_currentWave, _enemiesRemaining);

    // Performance: Clamp Bullets
    _clampProjectiles();
  }

  void _triggerPlayerDeath() {
    // Start slow motion effect
    _timeScale = 0.2;

    // Switch to game over after a delay
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (_gameState == GameState.playing) {
        changeState(GameState.gameOver);
      }
    });
  }

  void _updateSlowMo(double dt) {
    // Optional: add any visual updates for slow-mo here
  }

  void _clampProjectiles() {
    final playerBullets = world.children.whereType<BulletSprite>().toList();
    if (playerBullets.length > _maxPlayerBullets) {
      playerBullets.first.removeFromParent();
    }

    final enemyBullets = world.children.whereType<EnemyBullet>().toList();
    if (enemyBullets.length > _maxEnemyBullets) {
      enemyBullets.first.removeFromParent();
    }
  }

  void _startWaveCooldown() {
    _isWaveActive = false;
    _waveCooldownTimer = _timeBetweenWaves;

    // Show wave announcement message
    _showWaveAnnouncement();
  }

  void _showWaveAnnouncement() {
    final text = FadingTextComponent(
      text: 'WAVE $_currentWave INCOMING',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 32,
          fontWeight: FontWeight.bold,
          letterSpacing: 4,
          shadows: [Shadow(color: Colors.cyan, blurRadius: 10)],
        ),
      ),
      position: Vector2(camera.viewport.size.x / 2, camera.viewport.size.y / 3),
      anchor: Anchor.center,
    );

    camera.viewport.add(text);

    // Fade out and remove
    text.add(
      OpacityEffect.fadeOut(EffectController(duration: 3.0))
        ..onComplete = () => text.removeFromParent(),
    );

    text.add(ScaleEffect.by(Vector2.all(1.2), EffectController(duration: 3.0)));
  }

  void _spawnWave() {
    _waveTimer = 0.0;
    _isWaveActive = true;

    // Boss Wave every 5 waves
    if (_currentWave % 5 == 0) {
      _spawnBoss();
      return;
    }

    // --- CURVED SCALING ---
    // Count scales exponentially but starts slow: 5, 8, 12, 16, 21...
    final enemyCount = (5 + 1.2 * pow(_currentWave, 1.4)).toInt().clamp(
      5,
      _maxEnemies,
    );

    // Stat multipliers
    final healthMultiplier =
        1.0 + 0.15 * pow(_currentWave - 1, 1.1); // Health scales faster
    final speedMultiplier = (1.0 + 0.1 * log(_currentWave)).clamp(
      1.0,
      1.6,
    ); // Speed scales slower & capped
    final damageMultiplier = 1.0 + 0.1 * (_currentWave / 2);

    for (int i = 0; i < enemyCount; i++) {
      _spawnEnemy(healthMultiplier, speedMultiplier, damageMultiplier);
    }
  }

  void _spawnBoss() {
    final spawnPos = player.position + Vector2(0, -500);
    // Boss scales its own health and damage internally based on wave
    world.add(BossEnemy(position: spawnPos, waveNumber: _currentWave));
  }

  void _spawnEnemy(double healthMult, double speedMult, double damageMult) {
    // Random position around the player
    final rand = Random();
    final angle = rand.nextDouble() * 2 * pi;
    final distance = 500.0 + rand.nextDouble() * 200.0;

    final spawnPos =
        player.position + Vector2(cos(angle), sin(angle)) * distance;

    // --- WAVE COMPOSITION ---
    EnemyType type;
    final roll = rand.nextDouble();

    if (_currentWave < 3) {
      // Early: 100% Basic
      type = EnemyType.basic;
    } else if (_currentWave < 6) {
      // Mid: 70% Basic, 30% Fast
      type = roll < 0.7 ? EnemyType.basic : EnemyType.fast;
    } else if (_currentWave < 10) {
      // Late: 50% Basic, 35% Fast, 15% Tank
      if (roll < 0.5) {
        type = EnemyType.basic;
      } else if (roll < 0.85) {
        type = EnemyType.fast;
      } else {
        type = EnemyType.tank;
      }
    } else {
      // End-game: 30% Basic, 40% Fast, 30% Tank
      if (roll < 0.3) {
        type = EnemyType.basic;
      } else if (roll < 0.7) {
        type = EnemyType.fast;
      } else {
        type = EnemyType.tank;
      }
    }

    world.add(
      EnemySprite(
        enemyType: type,
        position: spawnPos,
        healthMultiplier: healthMult,
        speedMultiplier: speedMult,
        damageMultiplier: damageMult,
      ),
    );
  }

  void _nextWave() {
    _currentWave++;

    // Show upgrade menu every 3 waves
    if ((_currentWave - 1) % 3 == 0) {
      changeState(GameState.upgrading);
    } else {
      _startWaveCooldown();
    }
  }

  /// variable to handle menu overlays based on game state
  void changeState(GameState newState) {
    if (_gameState == newState) return;

    // 1. Exit current state (Cleanup)
    switch (_gameState) {
      case GameState.playing:
        pauseEngine();
        break;
      case GameState.paused:
        overlays.remove('PauseMenu');
        break;
      case GameState.upgrading:
        overlays.remove('UpgradeMenu');
        currentUpgradeOptions.clear();
        break;
      case GameState.gameOver:
        overlays.remove('GameOverMenu');
        break;
    }

    // Update state
    _gameState = newState;

    // 2. Enter new state (Setup)
    switch (_gameState) {
      case GameState.playing:
        resumeEngine();
        break;
      case GameState.paused:
        overlays.add('PauseMenu');
        break;
      case GameState.upgrading:
        currentUpgradeOptions = _upgradeManager.getRandomUpgrades(3);
        overlays.add('UpgradeMenu');
        break;
      case GameState.gameOver:
        overlays.add('GameOverMenu');
        break;
    }
  }

  @override
  void selectUpgrade(Upgrade upgrade) {
    _upgradeManager.applyUpgrade(player, upgrade);
    changeState(GameState.playing);
    _spawnWave();
  }
}
