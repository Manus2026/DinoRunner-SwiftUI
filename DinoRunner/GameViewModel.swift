import SwiftUI
import Combine

@MainActor
class GameViewModel: ObservableObject {

    // MARK: - Published State
    @Published var gameState: GameState = .idle
    @Published var dinoYOffset: CGFloat = 0
    @Published var dinoVelocityY: CGFloat = 0
    @Published var obstacles: [Obstacle] = []
    @Published var clouds: [Cloud] = []
    @Published var bullets: [Bullet] = []
    @Published var energyItems: [EnergyItem] = []
    @Published var energy: CGFloat = 0
    @Published var score: Int = 0
    @Published var highScore: Int = 0
    @Published var currentSpeed: CGFloat = GameConstants.initialSpeed
    @Published var isOnGround: Bool = true
    @Published var isDucking: Bool = false
    @Published var isJumping: Bool = false
    @Published var jumpStartTime: Date? = nil
    @Published var dinoAnimFrame: Int = 0
    @Published var groundOffset: CGFloat = 0
    @Published var scoreFlash: Bool = false

    private(set) var screenWidth: CGFloat = 390
    private(set) var screenHeight: CGFloat = 844

    private var displayLink: CADisplayLink?
    private var lastTimestamp: CFTimeInterval = 0
    private var obstacleTimer: CGFloat = 0
    private var nextObstacleInterval: CGFloat = 1.5
    private var cloudTimer: CGFloat = 0
    private var energyTimer: CGFloat = 0
    private var scoreTimer: CGFloat = 0
    private var animTimer: CGFloat = 0

    func setup(screenWidth: CGFloat, screenHeight: CGFloat) {
        self.screenWidth = screenWidth
        self.screenHeight = screenHeight
        highScore = UserDefaults.standard.integer(forKey: "DinoHighScore")
        spawnInitialClouds()
    }

    func dinoScreenCenterY() -> CGFloat {
        let groundLineY = screenHeight - GameConstants.groundY
        let dinoH = isDucking ? 28.0 : GameConstants.dinoHeight
        return groundLineY - dinoH / 2 - dinoYOffset
    }

    func dinoScreenCenterX() -> CGFloat {
        return GameConstants.dinoX + (isDucking ? 32 : GameConstants.dinoWidth / 2)
    }

    func startGame() {
        score = 0
        energy = 50
        dinoYOffset = 0
        dinoVelocityY = 0
        obstacles = []
        bullets = []
        energyItems = []
        currentSpeed = GameConstants.initialSpeed
        obstacleTimer = 0
        nextObstacleInterval = 1.5
        cloudTimer = 0
        energyTimer = 0
        scoreTimer = 0
        animTimer = 0
        groundOffset = 0
        isOnGround = true
        isDucking = false
        dinoAnimFrame = 0
        scoreFlash = false
        gameState = .running
        startDisplayLink()
    }

    func handlePress(active: Bool) {
        switch gameState {
        case .idle, .gameOver: 
            if active { startGame() }
        case .running:
            if active {
                startJump()
            } else {
                endJump()
            }
        }
    }

    private func startJump() {
        guard isOnGround && !isDucking else { return }
        isJumping = true
        jumpStartTime = Date()
        // 初始向上速度 (較小的小跳速度)
        dinoVelocityY = GameConstants.jumpVelocity * 0.7
        isOnGround = false
    }

    private func endJump() {
        isJumping = false
        jumpStartTime = nil
    }

    private func updateDinoPhysics(dt: CGFloat) {
        if !isOnGround {
            // 如果玩家還在按著螢幕，且跳躍時間未超過 0.25 秒，持續增加向上衝力
            if isJumping, let startTime = jumpStartTime {
                let duration = Date().timeIntervalSince(startTime)
                if duration < 0.25 {
                    dinoVelocityY += 800 * dt // 額外的上升推力
                } else {
                    isJumping = false
                }
            }
            
            dinoVelocityY += GameConstants.gravity * dt
            dinoYOffset += dinoVelocityY * dt
            if dinoYOffset <= 0 {
                dinoYOffset = 0
                dinoVelocityY = 0
                isOnGround = true
                isJumping = false
            }
        }
    }

    func duck(active: Bool) {
        guard gameState == .running else { return }
        isDucking = active && isOnGround
    }

    func shoot() {
        guard gameState == .running, energy >= GameConstants.energyCostPerShot else { return }
        energy -= GameConstants.energyCostPerShot
        let bulletY = screenHeight - GameConstants.groundY - dinoYOffset - (isDucking ? 15 : 35)
        bullets.append(Bullet(x: GameConstants.dinoX + 50, y: bulletY))
    }

    private func endGame() {
        gameState = .gameOver
        stopDisplayLink()
        if score > highScore {
            highScore = score
            UserDefaults.standard.set(highScore, forKey: "DinoHighScore")
        }
    }

    private func startDisplayLink() {
        stopDisplayLink()
        let dl = CADisplayLink(target: self, selector: #selector(gameLoop(_:)))
        dl.add(to: .main, forMode: .common)
        displayLink = dl
    }

    private func stopDisplayLink() {
        displayLink?.invalidate()
        displayLink = nil
    }

    @objc private func gameLoop(_ link: CADisplayLink) {
        if lastTimestamp == 0 { lastTimestamp = link.timestamp; return }
        let dt = min(CGFloat(link.timestamp - lastTimestamp), 0.05)
        lastTimestamp = link.timestamp
        update(dt: dt)
    }

    private func update(dt: CGFloat) {
        guard gameState == .running else { return }
        updateDinoPhysics(dt: dt)
        updateObstacles(dt: dt)
        updateBullets(dt: dt)
        updateEnergyItems(dt: dt)
        updateClouds(dt: dt)
        updateScore(dt: dt)
        updateAnimation(dt: dt)
        updateGround(dt: dt)
        updateSpeed()
        checkCollisions()
    }



    private func updateObstacles(dt: CGFloat) {
        for i in obstacles.indices { obstacles[i].x -= currentSpeed * dt }
        obstacles.removeAll { $0.x + $0.width < -60 }
        obstacleTimer += dt
        if obstacleTimer >= nextObstacleInterval {
            obstacleTimer = 0
            spawnObstacle()
            nextObstacleInterval = CGFloat.random(in: 1.0...2.5)
        }
    }

    private func spawnObstacle() {
        let x = screenWidth + 30
        let type: ObstacleType = (currentSpeed > 400 && Bool.random()) ? .bird : .cactusSmall
        switch type {
        case .cactusSmall: 
            obstacles.append(Obstacle(x: x, y: 0, width: 35, height: 50, type: .cactusSmall))
        case .bird: 
            // 隨機生成兩種高度：
            // 1. 低位 (y: 20)：需要跳躍避開
            // 2. 高位 (y: 75)：需要蹲下避開
            let birdY: CGFloat = Bool.random() ? 20 : 75
            obstacles.append(Obstacle(x: x, y: birdY, width: 45, height: 35, type: .bird))
        default: break
        }
    }

    private func updateBullets(dt: CGFloat) {
        for i in bullets.indices { bullets[i].x += 600 * dt }
        bullets.removeAll { $0.x > screenWidth }
        
        // Bullet vs Obstacle collision
        for bIndex in bullets.indices.reversed() {
            let bulletRect = CGRect(x: bullets[bIndex].x, y: bullets[bIndex].y, width: 15, height: 8)
            for oIndex in obstacles.indices.reversed() {
                let groundLineY = screenHeight - GameConstants.groundY
                let obsRect = CGRect(x: obstacles[oIndex].x, y: groundLineY - obstacles[oIndex].y - obstacles[oIndex].height, width: obstacles[oIndex].width, height: obstacles[oIndex].height)
                
                if bulletRect.intersects(obsRect) {
                    bullets.remove(at: bIndex)
                    obstacles.remove(at: oIndex)
                    score += 50
                    break
                }
            }
        }
    }

    private func updateEnergyItems(dt: CGFloat) {
        for i in energyItems.indices { energyItems[i].x -= currentSpeed * dt }
        energyItems.removeAll { $0.x < -50 }
        energyTimer += dt
        if energyTimer > 4.0 {
            energyTimer = 0
            energyItems.append(EnergyItem(x: screenWidth + 50, y: screenHeight - GameConstants.groundY - CGFloat.random(in: 40...120)))
        }
    }

    private func updateClouds(dt: CGFloat) {
        for i in clouds.indices { clouds[i].x -= clouds[i].speed * dt }
        clouds.removeAll { $0.x + $0.width < -10 }
        cloudTimer += dt
        if cloudTimer > 3.0 {
            cloudTimer = 0
            clouds.append(Cloud(x: screenWidth + 10, y: CGFloat.random(in: 80...200), speed: 40))
        }
    }

    private func spawnInitialClouds() {
        for i in 0..<3 { clouds.append(Cloud(x: CGFloat(i) * 150, y: 100, speed: 40)) }
    }

    private func updateScore(dt: CGFloat) {
        scoreTimer += dt
        if scoreTimer >= 0.1 { scoreTimer = 0; score += 1 }
    }

    private func updateAnimation(dt: CGFloat) {
        animTimer += dt
        if animTimer >= 0.12 { animTimer = 0; dinoAnimFrame = dinoAnimFrame == 0 ? 1 : 0 }
    }

    private func updateGround(dt: CGFloat) {
        groundOffset -= currentSpeed * dt
        if groundOffset < -screenWidth { groundOffset += screenWidth }
    }

    private func updateSpeed() {
        currentSpeed = min(GameConstants.initialSpeed + CGFloat(score / 100) * 10, GameConstants.maxSpeed)
    }

    private func checkCollisions() {
        let s = GameConstants.hitboxShrink
        let groundLineY = screenHeight - GameConstants.groundY
        let dinoRect = CGRect(x: GameConstants.dinoX + s, y: groundLineY - dinoYOffset - (isDucking ? 28 : 54) + s, width: (isDucking ? 60 : 50) - s*2, height: (isDucking ? 28 : 54) - s*2)

        for obstacle in obstacles {
            let obsRect = CGRect(x: obstacle.x + s, y: groundLineY - obstacle.y - obstacle.height + s, width: obstacle.width - s*2, height: obstacle.height - s*2)
            if dinoRect.intersects(obsRect) { endGame(); return }
        }

        for i in energyItems.indices.reversed() {
            let itemRect = CGRect(x: energyItems[i].x, y: energyItems[i].y, width: 30, height: 30)
            if dinoRect.intersects(itemRect) {
                energy = min(GameConstants.maxEnergy, energy + GameConstants.energyPerItem)
                energyItems.remove(at: i)
            }
        }
    }
}
