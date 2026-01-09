import 'package:flutter/material.dart';
import 'package:flutter_games/game/game_enums.dart';
import 'package:flutter_games/game/helper/spacing.dart';
import 'package:flutter_games/game/wavefall_game_enhanced.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PauseMenu extends StatelessWidget {
  final WaveFallGameEnhanced game;

  const PauseMenu({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        color: Colors.black.withValues(alpha: 0.7),
        child: Center(
          child: Container(
            width: 320.w,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E2C),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.cyan.withValues(alpha: 0.5),
                width: 1.5.w,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: Colors.cyan.withValues(alpha: 0.2),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'PAUSED',
                  style: TextStyle(
                    color: Colors.cyan,
                    fontSize: 32.sp,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3,
                    shadows: [Shadow(color: Colors.cyan, blurRadius: 10)],
                  ),
                ),
                verticalSpace(40),
                _buildMenuButton(
                  label: 'RESUME',
                  icon: Icons.play_arrow_rounded,
                  onPressed: () => game.changeState(GameState.playing),
                  primaryColor: Colors.cyan,
                ),
                verticalSpace(16),
                _buildMenuButton(
                  label: 'RESTART',
                  icon: Icons.refresh_rounded,
                  onPressed: () {
                    // Reset and Resume
                    game.resetGame();
                  },
                  primaryColor: Colors.white,
                ),
                verticalSpace(16),
                _buildMenuButton(
                  label: 'EXIT',
                  icon: Icons.exit_to_app_rounded,
                  onPressed: () {
                    // Usually pops the route to go back to main menu screen
                    // Assuming the game is pushed on navigation stack
                    Navigator.of(context).pop();
                  },
                  primaryColor: Colors.redAccent,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
    required Color primaryColor,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style:
            ElevatedButton.styleFrom(
              backgroundColor: Colors.white.withValues(alpha: 0.05),
              foregroundColor: primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: primaryColor.withValues(alpha: 0.3)),
              ),
              elevation: 0,
            ).copyWith(
              overlayColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.hovered)) {
                  return primaryColor.withValues(alpha: 0.1);
                }
                if (states.contains(WidgetState.pressed)) {
                  return primaryColor.withValues(alpha: 0.2);
                }
                return null;
              }),
            ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24.sp),
            horizontalSpace(kHorizontalSpaceLarge),
            Text(
              label,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
