import SwiftUI
import GameKit

struct GameView: View {
    @StateObject private var vm = GameViewModel()
    @Environment(\.colorScheme) var colorScheme
    @State private var showGameCenter = false

    var bgColor: Color { colorScheme == .dark ? Color(red: 0.1, green: 0.1, blue: 0.12) : Color(red: 0.95, green: 0.95, blue: 0.98) }
    var fgColor: Color { colorScheme == .dark ? .white : .black }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                bgColor.ignoresSafeArea()

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
                        .position(x: obs.x + obs.width/2, y: geo.size.height - GameConstants.groundY - obs.y - obs.height/2)
                }

                // Dino
                let dinoImg = vm.isDucking ? "dino_frame_0_0" : "dino_frame_0_\(vm.dinoAnimFrame)"
                Image(dinoImg)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: vm.isDucking ? 64 : 50, height: vm.isDucking ? 30 : 54)
                    .scaleEffect(x: 1, y: 1)
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
