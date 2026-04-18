import SwiftUI
import GameKit

struct GameView: View {
    @StateObject private var vm = GameViewModel()
    @Environment(\.colorScheme) var colorScheme
    @State private var showGameCenter = false

    var bgColor: Color {
        if vm.score >= 10000 {
            return Color(red: 0.2, green: 0.0, blue: 0.3) // 霓虹紫 (10,000+)
        } else if vm.score >= 5000 {
            return Color(red: 0.05, green: 0.05, blue: 0.15) // 午夜藍 (5,000+)
        } else if vm.score >= 1000 {
            return Color(red: 0.3, green: 0.1, blue: 0.1) // 黃昏紅 (1,000+)
        }
        return Color(red: 0.1, green: 0.1, blue: 0.12) // 預設深色
    }
    var fgColor: Color { .white }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                bgColor
                    .animation(.easeInOut(duration: 2.0), value: vm.score / 1000) // 背景顏色過渡
                    .ignoresSafeArea()
                
                // 星星效果 (僅在 5000 分以上顯示)
                if vm.score >= 5000 {
                    ForEach(0..<20, id: \.self) { i in
                        Circle()
                            .fill(Color.white.opacity(Double.random(in: 0.3...0.8)))
                            .frame(width: 2, height: 2)
                            .position(x: CGFloat((i * 137) % Int(geo.size.width)), y: CGFloat((i * 251) % 300))
                    }
                }

                // Sun
                Image("sun")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                    .position(x: 60, y: 160)
                
                // 測試按鈕 (點擊增加 1,000 分)
                if vm.gameState == .running {
                    Button(action: { vm.score += 1000 }) {
                        Text("DEBUG: +1000")
                            .font(.system(size: 10, weight: .bold, design: .monospaced))
                            .padding(6)
                            .background(Color.red.opacity(0.3))
                            .cornerRadius(4)
                    }
                    .position(x: 60, y: 120)
                }

                // Clouds
                ForEach(vm.clouds) { cloud in
                    Image(systemName: "cloud.fill")
                        .foregroundColor(fgColor.opacity(0.2))
                        .font(.system(size: 40))
                        .position(x: cloud.x, y: cloud.y)
                }

                // Ground
                Rectangle()
                    .fill(fgColor.opacity(0.1))
                    .frame(height: 2)
                    .position(x: geo.size.width/2, y: geo.size.height - GameConstants.groundY)

                // Energy Items
                ForEach(vm.energyItems) { item in
                    Image("energy_orb_clean")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .position(x: item.x, y: item.y)
                }

                // Bullets
                ForEach(vm.bullets) { bullet in
                    Capsule()
                        .fill(Color.cyan)
                        .frame(width: 15, height: 6)
                        .position(x: bullet.x, y: bullet.y)
                        .shadow(color: .cyan, radius: 3)
                }

                // Obstacles
                ForEach(vm.obstacles) { obs in
                    let imgName = obs.type == .bird ? "bird_frame_0_\(vm.dinoAnimFrame)" : "cactus_type_0_1"
                    Image(imgName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: obs.width, height: obs.height)
                        .scaleEffect(x: obs.type == .bird ? -1 : 1, y: 1) // 修正翼龍方向
                        .shadow(color: vm.score >= 10000 ? .cyan : .clear, radius: 10) // 霓虹發光
                        .position(x: obs.x + obs.width/2, y: geo.size.height - GameConstants.groundY - obs.y - obs.height/2)
                }

                // Dino
                let dinoImg = vm.isDucking ? "dino_frame_0_0" : "dino_frame_0_\(vm.dinoAnimFrame)"
                Image(dinoImg)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: vm.isDucking ? 64 : 50, height: vm.isDucking ? 30 : 54)
                    .shadow(color: vm.score >= 10000 ? .cyan : .clear, radius: 10) // 霓虹發光
                    .position(x: vm.dinoScreenCenterX(), y: vm.dinoScreenCenterY())

                // HUD
                VStack {
                    HStack {
                        // Energy Bar
                        VStack(alignment: .leading, spacing: 4) {
                            Text("ENERGY")
                                .font(.system(size: 10, weight: .bold, design: .monospaced))
                                .foregroundColor(fgColor.opacity(0.6))
                            ZStack(alignment: .leading) {
                                Capsule().fill(fgColor.opacity(0.1)).frame(width: 100, height: 8)
                                Capsule().fill(vm.energy > 20 ? Color.cyan : Color.red).frame(width: vm.energy, height: 8)
                            }
                        }
                        .padding(.leading, 20)
                        
                        Spacer()
                        
                        // Score
                        VStack(alignment: .trailing) {
                            Text("HI \(String(format: "%05d", vm.highScore))")
                                .font(.system(size: 12, design: .monospaced))
                                .foregroundColor(fgColor.opacity(0.4))
                            Text("\(String(format: "%05d", vm.score))")
                                .font(.system(size: 20, weight: .bold, design: .monospaced))
                                .foregroundColor(fgColor)
                        }
                        .padding(.trailing, 20)
                    }
                    .padding(.top, 50)
                    Spacer()
                }

                // Controls Overlay
                if vm.gameState == .running {
                    HStack {
                        // Left side for shooting
                        Color.clear
                            .contentShape(Rectangle())
                            .onTapGesture { vm.shoot() }
                        
                        // Right side for jumping
                        Color.clear
                            .contentShape(Rectangle())
                            .onTapGesture { vm.jump() }
                    }
                }

                if vm.gameState == .idle {
                    VStack(spacing: 20) {
                        Text("DINO ADVENTURE").font(.system(size: 32, weight: .black, design: .monospaced))
                        Text("TAP RIGHT TO JUMP\nTAP LEFT TO SHOOT").multilineTextAlignment(.center).font(.system(size: 14, design: .monospaced))
                        Text("TAP TO START").font(.system(size: 18, weight: .bold, design: .monospaced)).foregroundColor(.cyan)
                    }
                    .onTapGesture { vm.startGame() }
                }

                if vm.gameState == .gameOver {
                    VStack(spacing: 20) {
                        Text("GAME OVER").font(.system(size: 40, weight: .black, design: .monospaced)).foregroundColor(.red)
                        Text("SCORE: \(vm.score)").font(.system(size: 24, design: .monospaced))
                        
                        HStack(spacing: 15) {
                            Button(action: { vm.startGame() }) {
                                Text("RESTART").font(.system(size: 16, weight: .bold, design: .monospaced)).foregroundColor(.white).padding(.horizontal, 20).padding(.vertical, 10).background(Color.cyan).cornerRadius(8)
                            }
                            
                            Button(action: { 
                                GameCenterManager.shared.submitScore(vm.score)
                                showGameCenter = true
                            }) {
                                Text("LEADERBOARD").font(.system(size: 14, weight: .bold, design: .monospaced)).foregroundColor(.white).padding(.horizontal, 15).padding(.vertical, 10).background(Color.orange).cornerRadius(8)
                            }
                        }
                    }
                }
            }
            .onAppear { 
                vm.setup(screenWidth: geo.size.width, screenHeight: geo.size.height)
                GameCenterManager.shared.authenticatePlayer()
            }
            .gesture(
                DragGesture(minimumDistance: 20)
                    .onChanged { value in if value.translation.height > 20 { vm.duck(active: true) } }
                    .onEnded { _ in vm.duck(active: false) }
            )
        }
        .ignoresSafeArea()
        .sheet(isPresented: $showGameCenter) {
            GameCenterView()
        }
    }
}

struct GameCenterView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> GKGameCenterViewController {
        let vc = GKGameCenterViewController(leaderboardID: "com.dinorunner.scores", playerScope: .global, timeScope: .allTime)
        vc.gameCenterDelegate = context.coordinator
        return vc
    }
    
    func updateUIViewController(_ uiViewController: GKGameCenterViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, GKGameCenterControllerDelegate {
        func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
            gameCenterViewController.dismiss(animated: true)
        }
    }
}
