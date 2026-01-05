import 'package:flame/components.dart';
import 'package:flutter_games/game/effects/particle_effects.dart';
import 'package:flutter_games/game/effects/screen_shake.dart';
import 'package:flutter_games/game/enemies/boss_enemy.dart';
import 'package:flutter_games/game/enemies/enemy.dart';
import 'package:flutter_games/game/player/player_sprite.dart';
import 'package:flutter_games/game/wavefall_game.dart';
import 'package:flutter_games/game/weapons/bullet_sprite.dart';
import 'package:flutter_games/game/weapons/enemy_bullet.dart';

/// Collision detection system for WaveFall game
class CollisionSystem extends Component with HasGameReference<WaveFallGame> {
  CollisionSystem() : super(priority: 50);

  @override
  void update(double dt) {
    super.update(dt);

    _checkBulletEnemyCollisions();
    _checkPlayerEnemyCollisions();
    _checkPlayerEnemyBulletCollisions();
  }

  void _checkBulletEnemyCollisions() {
    final bullets = game.world.children.whereType<BulletSprite>().toList();
    final enemies = game.world.children.whereType<Enemy>().toList();

    for (final bullet in bullets) {
      if (bullet.parent == null) continue;

      for (final enemy in enemies) {
        if (enemy.parent == null) continue;

        if (_isColliding(bullet, enemy)) {
          enemy.takeDamage(bullet.getDamage());
          game.world.add(
            ParticleEffects.createBulletImpact(position: bullet.position),
          );
          bullet.removeFromParent();
          break;
        }
      }
    }
  }

  void _checkPlayerEnemyCollisions() {
    final player = game.player;
    if (player is! PlayerSpriteComponent) return;

    final enemies = game.world.children.whereType<Enemy>().toList();

    for (final enemy in enemies) {
      if (_isColliding(player, enemy)) {
        player.takeDamage(enemy.getDamage());
        game.camera.viewport.add(
          ScreenShakeEffect(camera: game.camera, intensity: 8.0, duration: 0.2),
        );
        game.world.add(
          ParticleEffects.createHitEffect(position: player.position),
        );

        // Only remove regular enemies, bosses stay
        if (enemy is! BossEnemy) {
          enemy.removeFromParent();
        }
      }
    }
  }

  void _checkPlayerEnemyBulletCollisions() {
    final player = game.player;
    if (player is! PlayerSpriteComponent) return;

    final bullets = game.world.children.whereType<EnemyBullet>().toList();

    for (final bullet in bullets) {
      if (_isColliding(player, bullet)) {
        player.takeDamage(bullet.damage);
        game.camera.viewport.add(
          ScreenShakeEffect(camera: game.camera, intensity: 4.0, duration: 0.1),
        );
        game.world.add(
          ParticleEffects.createHitEffect(position: player.position),
        );
        bullet.removeFromParent();
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
