# 🦕 DinoRunner — SwiftUI Chrome Dino Game

A SwiftUI recreation of the classic Chrome offline dinosaur game, built for iOS 17+.

---

## Features

- **Tap to jump** over cacti and obstacles
- **Swipe down** to duck under flying pterodactyls
- **Progressive difficulty** — speed increases every 100 points
- **3 cactus types**: small, large, double
- **Pterodactyl** enemy at 3 different heights (appears at higher speeds)
- **Score & High Score** tracking (persisted via UserDefaults)
- **Score flash** animation every 100 points milestone
- **Light & Dark Mode** support
- **Smooth 60fps** animation via CADisplayLink
- **Game Over screen** with score comparison and restart

---

## How to Open

1. Unzip `DinoRunner.zip`
2. Open `DinoRunner.xcodeproj` in **Xcode 15+**
3. Select a simulator (iPhone 14 or later recommended) or your device
4. Press **⌘R** to build and run

> **Requirements**: Xcode 15+, iOS 17+, macOS Ventura or later

---

## Controls

| Action | Gesture |
|--------|---------|
| Start / Restart | Tap anywhere |
| Jump | Tap |
| Duck | Swipe down (hold) |

---

## Project Structure

```
DinoRunner/
├── DinoRunner.xcodeproj/
│   └── project.pbxproj
└── DinoRunner/
    ├── DinoRunnerApp.swift     # App entry point
    ├── ContentView.swift       # Root view
    ├── GameModels.swift        # Data models & constants
    ├── GameViewModel.swift     # Game logic, physics, collision
    ├── GameView.swift          # Main game scene & overlays
    ├── DinoView.swift          # Dinosaur character shapes
    ├── ObstacleView.swift      # Cactus & bird shapes
    ├── GroundView.swift        # Scrolling ground
    ├── CloudView.swift         # Background clouds
    └── ScoreView.swift         # Score utilities
```

---

## Architecture

The game uses a clean MVVM architecture:

- **`GameViewModel`** drives all game logic using `CADisplayLink` for 60fps updates, handling physics, obstacle spawning, collision detection, and score progression.
- **`GameView`** is a pure SwiftUI view that renders the game state reactively.
- All shapes (dino, cacti, birds, clouds) are drawn using SwiftUI `Shape` / `Path` — no external assets required.

---

Made with ❤️ using SwiftUI
