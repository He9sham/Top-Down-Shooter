import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';
import 'package:flutter_games/game/wavefall_game.dart';

/// Tiled background component for space environment
class SpaceBackground extends SpriteComponent
    with HasGameReference<WaveFallGame> {
  SpaceBackground({required Vector2 worldSize})
    : super(size: worldSize, anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Load background sprite
    sprite = await game.loadSprite('background/space_bg.png');

    // Position at world center
    position = Vector2.zero();
  }
}

/// Alternative: Parallax scrolling background for more dynamic effect
class ParallaxSpaceBackground extends ParallaxComponent<WaveFallGame> {
  ParallaxSpaceBackground() : super();

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Create parallax layers with different scroll speeds
    parallax = await game.loadParallax(
      [ParallaxImageData('background/space_bg.png')],
      baseVelocity: Vector2(0, 0), // Static for top-down shooter
      velocityMultiplierDelta: Vector2(0, 0),
      repeat: ImageRepeat.repeat,
    );
  }
}
