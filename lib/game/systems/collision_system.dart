import 'package:flame/components.dart';
import 'package:flutter_games/game/effects/particle_effects.dart';
import 'package:flutter_games/game/effects/screen_shake.dart';
import 'package:flutter_games/game/enemies/enemy_sprite.dart';
import 'package:flutter_games/game/player/player_sprite.dart';
import 'package:flutter_games/game/wavefall_game.dart';
import 'package:flutter_games/game/weapons/bullet_sprite.dart';

/// Collision detection system for WaveFall game
class CollisionSystem extends Component with HasGameReference<WaveFallGame> {
  CollisionSystem() : super(priority: 50);

  @override
  void update(double dt) {
    super.update(dt);

    _checkBulletEnemyCollisions();
    _checkPlayerEnemyCollisions();
  }

  void _checkBulletEnemyCollisions() {
    // robust query to get all active bullets and enemies
    final bullets = game.world.children.whereType<BulletSprite>().toList();
    final enemies = game.world.children.whereType<EnemySprite>().toList();

    for (final bullet in bullets) {
      if (bullet.parent == null) continue; // Already removed

      for (final enemy in enemies) {
        if (enemy.parent == null) continue; // Already removed

        if (_isColliding(bullet, enemy)) {
          // Apply damage to enemy
          enemy.takeDamage(bullet.getDamage());

          // Create bullet impact effect
          game.world.add(
            ParticleEffects.createBulletImpact(position: bullet.position),
          );

          // Remove bullet
          bullet.removeFromParent();
          break; // Bullet can only hit one enemy
        }
      }
    }
  }

  void _checkPlayerEnemyCollisions() {
    final player = game.player;
    if (player is! PlayerSpriteComponent) return;

    final enemies = game.world.children.query<EnemySprite>();

    for (final enemy in enemies) {
      if (_isColliding(player, enemy)) {
        // Apply damage to player
        player.takeDamage(enemy.getDamage());

        // Trigger screen shake
        game.camera.viewport.add(
          ScreenShakeEffect(camera: game.camera, intensity: 8.0, duration: 0.2),
        );

        // Create hit effect on player
        game.world.add(
          ParticleEffects.createHitEffect(position: player.position),
        );

        // Remove enemy (they die on contact)
        enemy.removeFromParent();
      }
    }
  }

  bool _isColliding(PositionComponent a, PositionComponent b) {
    // Simple circle collision detection with buffer
    final distance = a.position.distanceTo(b.position);
    final radiusA = a.size.x / 2;
    final radiusB = b.size.x / 2;
    return distance <
        (radiusA + radiusB + 10.0); // 10.0 buffer for cleaner hits
  }
}
