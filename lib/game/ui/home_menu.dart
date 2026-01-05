import 'package:flutter/material.dart';
import 'package:flutter_games/main.dart';

class HomeMenu extends StatelessWidget {
  const HomeMenu({super.key});

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
              const Spacer(flex: 2),
              // Game Title
              const Text(
                'WAVE FALL',
                style: TextStyle(
                  color: Colors.cyan,
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 8,
                  shadows: [Shadow(color: Colors.cyan, blurRadius: 20)],
                ),
              ),
              const Text(
                'TOP-DOWN SURVIVOR',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  letterSpacing: 4,
                ),
              ),
              const Spacer(flex: 3),
              // Menu Options
              _buildHomeContainer(
                context,
                title: 'START GAME',
                icon: Icons.play_arrow_rounded,
                color: Colors.cyan,
                onTap: () {
                  Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (_) => const GameView()));
                },
              ),
              const SizedBox(height: 20),
              _buildHomeContainer(
                context,
                title: 'LOAD GAME',
                icon: Icons.save_rounded,
                color: Colors.purpleAccent,
                onTap: () {
                },
              ),
              const SizedBox(height: 20),
              _buildHomeContainer(
                context,
                title: 'LEVELS',
                icon: Icons.layers_rounded,
                color: Colors.orangeAccent,
                onTap: () {
                  
                },
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHomeContainer(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 300,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.5), width: 2),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.1),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              Positioned(
                right: -20,
                top: -20,
                child: Icon(
                  icon,
                  size: 100,
                  color: color.withValues(alpha: 0.1),
                ),
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, color: color, size: 28),
                    const SizedBox(width: 16),
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
