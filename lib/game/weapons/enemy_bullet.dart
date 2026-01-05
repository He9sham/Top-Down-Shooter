import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_games/game/wavefall_game.dart';

class EnemyBullet extends CircleComponent with HasGameReference<WaveFallGame> {
  EnemyBullet({
    required this.direction,
    required Vector2 position,
    this.speed = 200.0,
    this.damage = 15.0,
  }) : super(
         position: position,
         radius: 6,
         anchor: Anchor.center,
         paint: Paint()
           ..color = Colors.purpleAccent
           ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
       );

  final Vector2 direction;
  final double speed;
  final double damage;

  @override
  void update(double dt) {
    super.update(dt);
    position.add(direction * speed * dt);

    if (_isOffScreen()) {
      removeFromParent();
    }
  }

  bool _isOffScreen() {
    final cameraCenter = game.camera.viewfinder.position;
    return position.distanceTo(cameraCenter) > 1200;
  }
}
