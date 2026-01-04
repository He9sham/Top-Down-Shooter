import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';

/// Particle effects factory for WaveFall game
class ParticleEffects {
  /// Creates an explosion particle effect (for enemy death)
  static ParticleSystemComponent createExplosion({
    required Vector2 position,
    Color color = Colors.orange,
    int particleCount = 20,
    double size = 3.0,
  }) {
    final random = Random();

    return ParticleSystemComponent(
      position: position,
      particle: Particle.generate(
        count: particleCount,
        lifespan: 0.8,
        generator: (i) {
          final velocity = Vector2(
            random.nextDouble() * 200 - 100,
            random.nextDouble() * 200 - 100,
          );

          return AcceleratedParticle(
            acceleration: Vector2(0, 50), // Slight gravity
            speed: velocity,
            child: CircleParticle(
              radius: size * (0.5 + random.nextDouble() * 0.5),
              paint: Paint()
                ..color = color.withValues(
                  alpha: 0.8 - (i / particleCount) * 0.3,
                ),
            ),
          );
        },
      ),
    );
  }

  /// Creates a hit particle effect (for enemy hit)
  static ParticleSystemComponent createHitEffect({
    required Vector2 position,
    Color color = Colors.red,
    int particleCount = 8,
  }) {
    return ParticleSystemComponent(
      position: position,
      particle: Particle.generate(
        count: particleCount,
        lifespan: 0.4,
        generator: (i) {
          final angle = (i / particleCount) * 2 * pi;
          final velocity = Vector2(cos(angle) * 100, sin(angle) * 100);

          return AcceleratedParticle(
            acceleration: Vector2.zero(),
            speed: velocity,
            child: CircleParticle(
              radius: 2.0,
              paint: Paint()..color = color.withValues(alpha: 0.9),
            ),
          );
        },
      ),
    );
  }

  /// Creates a bullet impact particle effect
  static ParticleSystemComponent createBulletImpact({
    required Vector2 position,
    Color color = const Color(0xFFFFCC00),
  }) {
    final random = Random();

    return ParticleSystemComponent(
      position: position,
      particle: Particle.generate(
        count: 5,
        lifespan: 0.3,
        generator: (i) {
          final velocity = Vector2(
            random.nextDouble() * 80 - 40,
            random.nextDouble() * 80 - 40,
          );

          return AcceleratedParticle(
            acceleration: Vector2.zero(),
            speed: velocity,
            child: CircleParticle(
              radius: 1.5,
              paint: Paint()..color = color.withValues(alpha: 0.8),
            ),
          );
        },
      ),
    );
  }

  /// Creates a subtle glow effect for bullets
  static Component createBulletGlow({
    required Vector2 position,
    Color color = const Color(0xFFFFCC00),
    double radius = 15.0,
  }) {
    return CircleComponent(
      position: position,
      radius: radius,
      anchor: Anchor.center,
      paint: Paint()
        ..color = color.withValues(alpha: 0.2)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
    );
  }

  /// Creates engine trail particles for player movement
  static ParticleSystemComponent createEngineTrail({
    required Vector2 position,
    required Vector2 direction,
  }) {
    final random = Random();

    return ParticleSystemComponent(
      position: position,
      particle: Particle.generate(
        count: 3,
        lifespan: 0.5,
        generator: (i) {
          final offset = Vector2(
            random.nextDouble() * 10 - 5,
            random.nextDouble() * 10 - 5,
          );

          return AcceleratedParticle(
            acceleration: direction * -50,
            speed: offset,
            child: CircleParticle(
              radius: 2.0,
              paint: Paint()..color = Colors.cyan.withValues(alpha: 0.6),
            ),
          );
        },
      ),
    );
  }
}
