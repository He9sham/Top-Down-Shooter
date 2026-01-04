import 'package:flutter/material.dart';
import 'package:flutter_games/game/upgrades/upgrade.dart';
import 'package:flutter_games/game/wavefall_game.dart';

class UpgradeMenu extends StatelessWidget {
  final WaveFallGame game;

  const UpgradeMenu({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final upgrades = game.currentUpgradeOptions;

    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        ),
        width: MediaQuery.of(context).size.width * 0.9,
        height: 400,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'LEVEL UP!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Choose an upgrade',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: upgrades.map((upgrade) {
                  return _buildUpgradeCard(context, upgrade);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpgradeCard(BuildContext context, Upgrade upgrade) {
    return GestureDetector(
      onTap: () => game.selectUpgrade(upgrade),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          width: 150,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(upgrade.icon, size: 50, color: Colors.amberAccent),
              const SizedBox(height: 15),
              Text(
                upgrade.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.amberAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                upgrade.description,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Enhanced overlay for WaveFallGameEnhanced
class UpgradeMenuOverlay extends StatelessWidget {
  final dynamic game; // Can be WaveFallGame or WaveFallGameEnhanced

  const UpgradeMenuOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final upgrades = game.currentUpgradeOptions as List<Upgrade>;

    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        ),
        width: MediaQuery.of(context).size.width * 0.9,
        height: 400,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'LEVEL UP!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Choose an upgrade',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: upgrades.map((upgrade) {
                  return _buildUpgradeCard(context, upgrade);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpgradeCard(BuildContext context, Upgrade upgrade) {
    return GestureDetector(
      onTap: () => game.selectUpgrade(upgrade),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          width: 150,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(upgrade.icon, size: 50, color: Colors.amberAccent),
              const SizedBox(height: 15),
              Text(
                upgrade.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.amberAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                upgrade.description,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
