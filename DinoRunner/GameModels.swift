import SwiftUI

// MARK: - Game State
enum GameState {
    case idle
    case running
    case gameOver
}

struct Bullet: Identifiable {
    let id = UUID()
    var x: CGFloat
    var y: CGFloat
    let speed: CGFloat = 600
}

struct EnergyItem: Identifiable {
    let id = UUID()
    var x: CGFloat
    var y: CGFloat
    let width: CGFloat = 30
    let height: CGFloat = 30
}

// MARK: - Obstacle Model
struct Obstacle: Identifiable {
    let id = UUID()
    var x: CGFloat
    let y: CGFloat
    let width: CGFloat
    let height: CGFloat
    let type: ObstacleType

    var frame: CGRect {
        CGRect(x: x, y: y, width: width, height: height)
    }
}

enum ObstacleType {
    case cactusSmall
    case cactusLarge
    case cactusDouble
    case bird
}

// MARK: - Cloud Model
struct Cloud: Identifiable {
    let id = UUID()
    var x: CGFloat
    var y: CGFloat
    let width: CGFloat = 80
    let height: CGFloat = 30
    let speed: CGFloat
}

// MARK: - Ground Segment
struct GroundSegment: Identifiable {
    let id = UUID()
    var x: CGFloat
    let y: CGFloat
    let width: CGFloat
    let height: CGFloat = 2
}

// MARK: - Game Constants
struct GameConstants {
    static let groundY: CGFloat = 100         // 地面距底部高度 (增加高度以貼合視覺)
    static let dinoWidth: CGFloat = 50
    static let dinoHeight: CGFloat = 54
    static let dinoX: CGFloat = 80            // 恐龍固定 X 位置
    static let gravity: CGFloat = -1800       // 重力加速度 (points/s²)
    static let jumpVelocity: CGFloat = 620    // 跳躍初速度
    static let initialSpeed: CGFloat = 280    // 初始移動速度 (points/s)
    static let speedIncrement: CGFloat = 8    // 每 500 分增加速度
    static let maxSpeed: CGFloat = 700
    static let hitboxShrink: CGFloat = 6
    static let maxEnergy: CGFloat = 100
    static let energyPerItem: CGFloat = 25
    static let energyCostPerShot: CGFloat = 20
}
