import 'package:flutter/material.dart';

enum UpgradeType { health, speed, damage, fireRate }

class Upgrade {
  final String id;
  final String name;
  final String description;
  final UpgradeType type;
  final double value;
  final IconData icon;

  const Upgrade({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.value,
    required this.icon,
  });
}
