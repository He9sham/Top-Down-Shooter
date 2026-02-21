# 🎮 WAVEFALL — Top-Down Shooter (Flutter + Flame)

![Flutter Version](https://img.shields.io/badge/Flutter-3.10.4%2B-blue.svg)
![Flame Version](https://img.shields.io/badge/Flame-1.34.0-orange.svg)
![Platform](https://img.shields.io/badge/Platforms-Android%20%7C%20iOS%20%7C%20Web-lightgrey.svg)

**WAVEFALL** is a fast-paced 2D top-down shooter built entirely using **Flutter** and the **Flame Engine**.  
The objective is simple but challenging: **survive endless enemy waves**, strategically select upgrades, and push your limits to achieve the highest possible wave.

Designed with **clean architecture**, **modular design**, **mobile-first performance**, and **scalability** as core principles.

---

## 🚀 Key Features

- **🔫 Fast-Paced Gameplay:** High-intensity top-down shooter mechanics.
- **🌊 Endless Waves System:** Dynamically scaling enemy waves that increase in volume and difficulty.
- **⚡ Dynamic Upgrade System:** Choose random power-ups (health, speed, damage, fire rate) between waves to create unique character builds.
- **🎮 Intuitive Controls:** Highly responsive, mobile-friendly virtual joystick controls (optimized with dead zones and smooth transitions).
- **💥 Satisfying Combat:** Integrated collision detection, damage handling, muzzle flashes, and subtle camera shake feedback.
- **🧠 Modular Architecture:** Clean, decoupled subsystems making the codebase highly maintainable.
- **📱 Performance Optimized:** Strict adherence to Flame's best practices, avoiding per-frame rendering allocations, and utilizing Flame's effect/timer systems.

---

## 🧩 Technology Stack

| Component          | Technology / Package     | Description                                      |
| :----------------- | :----------------------- | :----------------------------------------------- |
| **Engine**         | `flame`                  | Core game loop, rendering, and entity management |
| **UI Layer**       | Flutter Widgets          | Overlays, HUDs, Menus, and Pause screens         |
| **Responsiveness** | `flutter_screenutil`     | Adaptable UI sizing for diverse mobile screens   |
| **Physics**        | Flame Collisions         | Bounding Box based collision detection           |
| **Iconography**    | `flutter_launcher_icons` | App icon generation                              |

---

## 🏗️ Architecture & Philosophy

WaveFall is engineered using a **System-Oriented Architecture** built on top of Flame's Component System (FCS):

- **Logic & UI Separation:** Game logic is fully decoupled from Flutter's widget layer. UI elements (like menus and HUDs) sit as overlays.
- **Scalable Subsystems:** Behaviors like Wave Management, Enemy Spawning, and Upgrade handling are isolated into dedicated managers.
- **High Cohesion / Low Coupling:** Components communicate through typed interfaces rather than direct tight coupling.

This structure makes it incredibly easy to introduce new enemy variants, distinct weapon types, or complex UI overlays without breaking existing mechanics.

---

## 📁 Project Structure

```text
lib/
├── game/
│   ├── config/              # Game constants and global configuration
│   ├── enemies/             # Enemy behaviors, AI logic, and rendering
│   ├── player/              # Player movement, stats, and constraints
│   ├── weapons/             # Bullet physics, logic, and firing mechanics
│   ├── systems/             # Managers (Wave management, Spawning, etc.)
│   ├── upgrades/            # Upgrade logic and state configuration
│   ├── effects/             # Camera shake, particle effects, animations
│   ├── ui/                  # Flame HUDs and Flutter UI Overlays (Menus)
│   ├── utils/               # Math helpers and common utilities
│   ├── components/          # Reusable Flame components
│   └── wavefall_game.dart   # Main FlameGame root class and orchestration
└── main.dart                # Flutter application entry point
```

---

## ⚙️ Getting Started

### Prerequisites

- Flutter SDK `^3.10.4` or higher.
- An Android/iOS simulator or physical device.

### Installation

1.  **Clone the repository:**

    ```bash
    git clone https://github.com/He9sham/Top-Down-Shooter.git
    cd flutter_games
    ```

2.  **Fetch dependencies:**

    ```bash
    flutter pub get
    ```

3.  **Run the game:**
    ```bash
    flutter run
    ```
    _(For optimal performance testing on mobile devices, use release mode: `flutter run --release`)_

---

## 🤝 Contributing

Contributions, issues, and feature requests are welcome!  
Feel free to check [issues page](https://github.com/He9sham/Top-Down-Shooter/issues) if you want to contribute.

---

## 📝 License

This project is open-source and available under the terms of the MIT License.
