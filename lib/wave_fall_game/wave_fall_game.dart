import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart'; // For Colors
import 'package:flutter_games/game/player/player_component.dart';

class WaveFallGame extends FlameGame {
  WaveFallGame()
    : super(
        camera: CameraComponent.withFixedResolution(width: 400, height: 800),
        world: World(),
      );

  bool _isDebugMode = false;

  void toggleDebugMode() {
    _isDebugMode = !_isDebugMode;
    debugMode = _isDebugMode;
  }

  @override
  Color backgroundColor() => const Color(0xFF222222);

  @override
  FutureOr<void> onLoad() async {
    
    // - Create Player component
    // - Add movement controls (Joystick or Keyboard)
    // - Implement shooting mechanics

   
    // - Create basic Enemy component
    // - Implement enemy AI (chase player)
    // - Add enemy spawning logic

   
    // - Create WaveManager
    // - Track current wave, remaining enemies, spawn rates

    
    // - Health bar
    // - Score display
    // - Wave counter
    // - Game Over screen

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
    final player = PlayerComponent(joystick: joystick);
    world.add(player);

    // Camera follow
    camera.follow(player);

    // Initial setup
    debugMode = _isDebugMode;

    return super.onLoad();
  }

  // @override
  // void update(double dt) {
  //   super.update(dt);
  //   // Game logic updates usually go into components,
  //   // but global managers can be updated here.
  // }

  // @override
  // void render(Canvas canvas) {
  //   super.render(canvas);
  //   // Custom global rendering if needed
  // }
}
