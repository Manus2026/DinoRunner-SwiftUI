import SwiftUI

struct StartView: View {
    @State private var isActive = false

    var body: some View {
        if isActive {
            ContentView()
        } else {
            ZStack {
                Color.black.ignoresSafeArea() // 或者使用與遊戲背景色相符的顏色
                VStack(spacing: 20) {
                    Image("AppIcon") // 假設 AppIcon 可以直接這樣引用，如果不行需要調整
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150, height: 150)
                        .cornerRadius(25)
                    Text("DINO ADVENTURE")
                        .font(.system(size: 32, weight: .black, design: .monospaced))
                        .foregroundColor(.white)
                    Text("LOADING...")
                        .font(.system(size: 18, weight: .bold, design: .monospaced))
                        .foregroundColor(.cyan)
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // 延遲2秒後進入主畫面
                    self.isActive = true
                }
            }
        }
    }
}

#Preview {
    StartView()
}
