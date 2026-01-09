import 'package:flutter/material.dart';
import 'package:flutter_games/game/helper/spacing.dart';
import 'package:flutter_games/game/ui/widgets/how_to_play_overlay.dart';
import 'package:flutter_games/game/ui/widgets/menu_button_for_home_view.dart';
import 'package:flutter_games/game/ui/widgets/setting_overlay.dart';
import 'package:flutter_games/wave_fall_game/game_view.dart';

class HomeMenuScreen extends StatelessWidget {
  const HomeMenuScreen({super.key});

  void _showHowToPlay(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'How to Play',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return const HowToPlayOverlay();
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1,
          child: ScaleTransition(scale: anim1, child: child),
        );
      },
    );
  }

  void _showSettings(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Settings',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return const SettingsOverlay();
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1,
          child: ScaleTransition(scale: anim1, child: child),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0F0C29), Color(0xFF302B63), Color(0xFF24243E)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              verticalSpace(80),
              // Game Title with Neon Effect
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: 1),
                duration: const Duration(seconds: 1),
                builder: (context, value, child) {
                  return Opacity(opacity: value, child: child);
                },
                child: Column(
                  children: [
                    Text(
                      'WAVEFALL',
                      style: TextStyle(
                        color: Colors.cyanAccent,
                        fontSize: 64,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 10,
                        shadows: [
                          Shadow(
                            color: Colors.cyanAccent.withValues(alpha: 0.8),
                            blurRadius: 20,
                          ),
                          Shadow(
                            color: Colors.blueAccent.withValues(alpha: 0.8),
                            blurRadius: 40,
                          ),
                        ],
                      ),
                    ),
                    verticalSpace(8),
                    const Text(
                      'SURVIVE THE WAVES',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 6,
                      ),
                    ),
                  ],
                ),
              ),
              verticalSpace(100),
              // Menu Options
              MenuButton(
                title: 'START GAME',
                icon: Icons.play_arrow_rounded,
                color: Colors.cyanAccent,
                isPrimary: true,
                onTap: () {
                  Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (_) => const GameView()));
                },
              ),
              verticalSpace(20),
              MenuButton(
                title: 'HOW TO PLAY',
                icon: Icons.help_outline_rounded,
                color: Colors.purpleAccent,
                onTap: () => _showHowToPlay(context),
              ),
              verticalSpace(20),
              MenuButton(
                title: 'SETTINGS',
                icon: Icons.settings_rounded,
                color: Colors.orangeAccent,
                onTap: () => _showSettings(context),
              ),
              verticalSpace(100),
              // Version Info
              const Text(
                'v1.0.0-PROTOTYPE',
                style: TextStyle(
                  color: Colors.white24,
                  fontSize: 10,
                  letterSpacing: 2,
                ),
              ),
              verticalSpace(10),
            ],
          ),
        ),
      ),
    );
  }
}
