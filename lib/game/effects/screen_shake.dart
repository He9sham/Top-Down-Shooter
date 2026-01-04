import 'dart:math';

import 'package:flame/components.dart';

/// Screen shake effect for camera
class ScreenShakeEffect extends Component {
  ScreenShakeEffect({
    required this.camera,
    this.intensity = 10.0,
    this.duration = 0.3,
  });

  final CameraComponent camera;
  final double intensity;
  final double duration;

  double _elapsed = 0.0;
  Vector2? _originalPosition;
  final Random _random = Random();

  @override
  void onMount() {
    super.onMount();
    _originalPosition = camera.viewfinder.position.clone();
  }

  @override
  void update(double dt) {
    super.update(dt);
    _elapsed += dt;

    if (_elapsed >= duration) {
      // Reset camera position and remove effect
      if (_originalPosition != null) {
        camera.viewfinder.position = _originalPosition!;
      }
      removeFromParent();
      return;
    }

    // Calculate shake intensity (decreases over time)
    final progress = _elapsed / duration;
    final currentIntensity = intensity * (1 - progress);

    // Apply random offset
    final offsetX = (_random.nextDouble() * 2 - 1) * currentIntensity;
    final offsetY = (_random.nextDouble() * 2 - 1) * currentIntensity;

    if (_originalPosition != null) {
      camera.viewfinder.position =
          _originalPosition! + Vector2(offsetX, offsetY);
    }
  }
}
