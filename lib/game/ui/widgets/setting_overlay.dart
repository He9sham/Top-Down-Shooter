import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_games/game/helper/spacing.dart';

class SettingsOverlay extends StatefulWidget {
  const SettingsOverlay({super.key});

  @override
  State<SettingsOverlay> createState() => _SettingsOverlayState();
}

class _SettingsOverlayState extends State<SettingsOverlay> {
  bool _soundEffects = true;
  bool _music = true;
  bool _vibration = true;

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
            border: Border.all(color: Colors.orangeAccent, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.orangeAccent.withValues(alpha: 0.3),
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
                          'SETTINGS',
                          style: TextStyle(
                            color: Colors.orangeAccent,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 4,
                          ),
                        ),
                        const Divider(color: Colors.orangeAccent, height: 40),
                        _buildSettingToggle(
                          Icons.volume_up_rounded,
                          'SOUND EFFECTS',
                          _soundEffects,
                          (v) => setState(() => _soundEffects = v),
                        ),
                        verticalSpace(16),
                        _buildSettingToggle(
                          Icons.music_note_rounded,
                          'MUSIC',
                          _music,
                          (v) => setState(() => _music = v),
                        ),
                        verticalSpace(16),
                        _buildSettingToggle(
                          Icons.vibration_rounded,
                          'VIBRATION',
                          _vibration,
                          (v) => setState(() => _vibration = v),
                        ),
                        verticalSpace(40),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orangeAccent,
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
                          child: const Text('BACK'),
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

  Widget _buildSettingToggle(
    IconData icon,
    String label,
    bool currentValue,
    ValueChanged<bool> onChanged,
  ) {
    return Row(
      children: [
        Icon(icon, color: Colors.cyanAccent, size: 24),
        horizontalSpace(16),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
        Switch(
          value: currentValue,
          onChanged: onChanged,
          activeThumbColor: Colors.orangeAccent,
          activeTrackColor: Colors.orangeAccent.withValues(alpha: 0.3),
        ),
      ],
    );
  }
}
