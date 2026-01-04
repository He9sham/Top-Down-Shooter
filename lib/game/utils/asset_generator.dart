import 'dart:ui';

import 'package:flame/game.dart';
import 'package:flutter/material.dart' hide Image;

/// Generates creating assets programmatically (Image as Code)
/// This allows the game to run without external asset files.
class AssetGenerator {
  static Future<void> generateAndLoad(FlameGame game) async {
    // Generate Player Image
    final playerImage = await _generatePlayer();
    game.images.add('player/player.png', playerImage);

    // Generate Enemy Images
    final enemyBasic = await _generateEnemy(Colors.green, 'basic');
    game.images.add('enemies/enemy_basic.png', enemyBasic);

    final enemyFast = await _generateEnemy(Colors.red, 'fast');
    game.images.add('enemies/enemy_fast.png', enemyFast);

    final enemyTank = await _generateEnemy(Colors.purple, 'tank');
    game.images.add('enemies/enemy_tank.png', enemyTank);

    // Generate Bullet
    final bullet = await _generateBullet();
    game.images.add('bullets/bullet.png', bullet);

    // Generate Background
    final bg = await _generateBackground();
    game.images.add('background/space_bg.png', bg);
  }

  static Future<Image> _generatePlayer() async {
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);
    const size = Size(128, 128);

    // Draw Spaceship
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(64, 10); // Nose
    path.lineTo(118, 118); // Right Wing
    path.lineTo(64, 98); // Center back
    path.lineTo(10, 118); // Left Wing
    path.close();

    canvas.drawPath(path, paint);

    // Cockpit
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(64, 64), width: 20, height: 40),
      Paint()..color = Colors.cyanAccent,
    );

    // Engine Glow
    canvas.drawCircle(
      const Offset(35, 118),
      5,
      Paint()
        ..color = Colors.blueAccent.withValues(alpha: 0.8)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
    );
    canvas.drawCircle(
      const Offset(93, 118),
      5,
      Paint()
        ..color = Colors.blueAccent.withValues(alpha: 0.8)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
    );

    return recorder.endRecording().toImage(
      size.width.toInt(),
      size.height.toInt(),
    );
  }

  static Future<Image> _generateEnemy(Color color, String type) async {
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);
    const size = Size(64, 64);

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    if (type == 'basic') {
      canvas.drawCircle(const Offset(32, 32), 28, paint);
      // Eyes
      canvas.drawCircle(const Offset(22, 25), 4, Paint()..color = Colors.black);
      canvas.drawCircle(const Offset(42, 25), 4, Paint()..color = Colors.black);
    } else if (type == 'fast') {
      final path = Path();
      path.moveTo(32, 5);
      path.lineTo(58, 58);
      path.lineTo(32, 48);
      path.lineTo(6, 58);
      path.close();
      canvas.drawPath(path, paint);
    } else {
      // Tank
      canvas.drawRect(const Rect.fromLTWH(10, 10, 44, 44), paint);
      canvas.drawRect(
        const Rect.fromLTWH(20, 5, 24, 54),
        Paint()..color = color.withGreen(100),
      );
    }

    return recorder.endRecording().toImage(
      size.width.toInt(),
      size.height.toInt(),
    );
  }

  static Future<Image> _generateBullet() async {
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);
    const size = Size(32, 32);

    // Glow
    canvas.drawCircle(
      const Offset(16, 16),
      10,
      Paint()
        ..color = Colors.yellow.withValues(alpha: 0.5)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
    );

    // Core
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(16, 16), width: 8, height: 16),
      Paint()..color = Colors.white,
    );

    return recorder.endRecording().toImage(
      size.width.toInt(),
      size.height.toInt(),
    );
  }

  static Future<Image> _generateBackground() async {
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);
    const size = Size(512, 512);

    // Dark void
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = const Color(0xFF050510),
    );

    // Stars
    final random = List.generate(100, (index) => index);
    for (var i in random) {
      final x = (i * 17.0) % size.width;
      final y = (i * 43.0) % size.height;
      final r = (i % 3 + 1).toDouble();

      canvas.drawCircle(
        Offset(x, y),
        r * 0.5,
        Paint()..color = Colors.white.withValues(alpha: (i % 10) / 10.0),
      );
    }

    return recorder.endRecording().toImage(
      size.width.toInt(),
      size.height.toInt(),
    );
  }
}
