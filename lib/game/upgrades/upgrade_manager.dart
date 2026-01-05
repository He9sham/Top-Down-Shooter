import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_games/game/upgrades/upgrade.dart';

class UpgradeManager {
  static const List<Upgrade> _allUpgrades = [
    Upgrade(
      id: 'health_1',
      name: 'Max Health',
      description: 'Increases max health by 20%',
      type: UpgradeType.health,
      value: 0.2, // +20%
      icon: Icons.favorite,
    ),
    Upgrade(
      id: 'speed_1',
      name: 'Movement Speed',
      description: 'Increases speed by 10%',
      type: UpgradeType.speed,
      value: 0.1, // +10%
      icon: Icons.bolt,
    ),
    Upgrade(
      id: 'damage_1',
      name: 'Bullet Damage',
      description: 'Increases bullet damage by 20%',
      type: UpgradeType.damage,
      value: 0.2, // +20%
      icon: Icons.dangerous,
    ),
    Upgrade(
      id: 'fire_rate_1',
      name: 'Fire Rate',
      description: 'Increases fire rate by 25%',
      type: UpgradeType.fireRate,
      value: 0.25, // +25% frequency (or -25% interval)
      icon: Icons.timer_off,
    ),
  ];

  List<Upgrade> getRandomUpgrades(int count) {
    final random = Random();
    final List<Upgrade> options = List.from(_allUpgrades);
    options.shuffle(random);
    return options.take(count).toList();
  }

  void applyUpgrade(dynamic player, Upgrade upgrade) {
    switch (upgrade.type) {
      case UpgradeType.health:
        player.upgradeHealth(upgrade.value);
        break;
      case UpgradeType.speed:
        player.upgradeSpeed(upgrade.value);
        break;
      case UpgradeType.damage:
        player.upgradeDamage(upgrade.value);
        break;
      case UpgradeType.fireRate:
        player.upgradeFireRate(upgrade.value);
        break;
    }
  }
}
