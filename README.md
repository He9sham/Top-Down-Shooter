# 🎮 WAVEFALL — Top-Down Shooter (Flutter + Flame)

**WAVEFALL** is a fast-paced 2D top-down shooter built with **Flutter** and **Flame**.  
The goal is simple: **survive endless enemy waves**, upgrade your abilities, and push your limits.

Designed with **clean architecture**, **mobile performance**, and **scalability** in mind.

---

## 🚀 Features

- 🔫 Top-Down Shooter gameplay
- 🌊 Endless wave-based enemy system
- 📈 Progressive difficulty scaling
- ⚡ Upgrade system between waves
- 🎮 Mobile-friendly joystick controls
- 💥 Collision & damage system
- 🧠 Clean, modular game architecture
- 📱 Optimized for mobile performance

---

## 🧩 Tech Stack

| Layer | Technology |
|------|-----------|
| Game Engine | Flame |
| UI | Flutter Widgets |
| State | ValueNotifier / Riverpod (optional) |
| Physics | Flame Collision System |
| Audio | Flame Audio |

---

## Architecture Philosophy

This project follows a modular, system-oriented architecture:
- Game logic isolated from UI
- Scalable systems (waves, upgrades, enemies)
- Mobile-first performance decisions

Designed for maintainability and interview discussion.


---

## 📁 Project Structure

```text
lib/
├── game/
│   ├── wavefall_game.dart
│   ├── config/
│   ├── player/
│   ├── enemies/
│   ├── weapons/
│   ├── systems/
│   ├── upgrades/
│   └── ui/
└── main.dart
