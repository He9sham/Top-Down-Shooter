import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart'; // For Colors
import 'package:flutter_games/game/player/player.dart';
import 'package:flutter_games/game/upgrades/upgrade.dart';
import 'package:flutter_games/game/upgrades/upgrade_manager.dart';

class WaveFallGame extends FlameGame {
  WaveFallGame()
    : super(
        camera: CameraComponent.withFixedResolution(width: 400, height: 800),
        world: World(),
      );

  bool _isDebugMode = false;

  // Upgrade System
  late final UpgradeManager _upgradeManager;
  List<Upgrade> currentUpgradeOptions = [];
  late final PositionComponent player;

  void toggleDebugMode() {
    _isDebugMode = !_isDebugMode;
    debugMode = _isDebugMode;
  }

  @override
  Color backgroundColor() => const Color(0xFF222222);

  @override
  FutureOr<void> onLoad() async {
    _upgradeManager = UpgradeManager();

    // Temporary background
    world.add(
      RectangleComponent(
        size: Vector2(2000, 2000),
        position: Vector2(-1000, -1000),
        paint: Paint()..color = const Color(0xFF333333),
      ),
    );

    // Joystick
    final joystick = JoystickComponent(
      knob: CircleComponent(
        radius: 20,
        paint: Paint()..color = Colors.white.withValues(alpha: 0.8),
      ),
      background: CircleComponent(
        radius: 60,
        paint: Paint()..color = Colors.white.withValues(alpha: 0.2),
      ),
      margin: const EdgeInsets.only(left: 40, bottom: 40),
    );

    // Add joystick to viewport (HUD)
    camera.viewport.add(joystick);

    // Player
    player = PlayerComponent(joystick: joystick);
    world.add(player);

    // Camera follow
    camera.follow(player);

    // Initial setup
    debugMode = _isDebugMode;

    return super.onLoad();
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
  }
}
