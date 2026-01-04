import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_games/wave_fall_game/wave_fall_game.dart';

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

  @override
  void update(double dt) {
    super.update(dt);
    _handleMovement(dt);
  }

  void _handleMovement(double dt) {
    final movement = joystick.relativeDelta;

    // No input
    if (movement.isZero()) return;

    // Normalize for consistent speed in all directions
    final delta = movement.normalized() * _speed * dt;
    position.add(delta);

    // Clamp inside world bounds (considering radius)
    position.clamp(
      Vector2(
        -_worldHalfSize + radius,
        -_worldHalfSize + radius,
      ),
      Vector2(
        _worldHalfSize - radius,
        _worldHalfSize - radius,
      ),
    );
  }
}
