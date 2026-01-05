import 'package:flame/components.dart';

abstract class Enemy extends SpriteComponent {
  Enemy({
    required super.position,
    required super.size,
    super.anchor = Anchor.center,
  });

  double get maxHealth;
  double get currentHealth;
  double get healthPercentage => currentHealth / maxHealth;

  void takeDamage(double damage);
  double getDamage();
}
