import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_games/game/helper/spacing.dart';

class HowToPlayOverlay extends StatelessWidget {
  const HowToPlayOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A2E).withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.purpleAccent, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.purpleAccent.withValues(alpha: 0.3),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Material(
            type: MaterialType.transparency,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'HOW TO PLAY',
                          style: TextStyle(
                            color: Colors.purpleAccent,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 4,
                          ),
                        ),
                        const Divider(color: Colors.purpleAccent, height: 40),
                        _buildInfoRow(
                          Icons.gamepad_rounded,
                          'Use Joystick to move player',
                        ),
                        const SizedBox(height: 16),
                        _buildInfoRow(
                          Icons.auto_fix_high_rounded,
                          'Shoot automatically at nearest enemy',
                        ),
                        const SizedBox(height: 16),
                        _buildInfoRow(
                          Icons.flash_on_rounded,
                          'Collect power-ups to survive longer',
                        ),
                        const SizedBox(height: 16),
                        _buildInfoRow(
                          Icons.waves_rounded,
                          'Defeat waves of increasing difficulty',
                        ),
                        verticalSpace(40),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purpleAccent,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 15,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: const Text('GOT IT'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.cyanAccent, size: 24),
        horizontalSpace(16),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ],
    );
  }
}
