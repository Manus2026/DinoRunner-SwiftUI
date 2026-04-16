import SwiftUI

// MARK: - Ground View
struct GroundView: View {
    let screenWidth: CGFloat
    let screenHeight: CGFloat
    let offset: CGFloat
    let color: Color

    var body: some View {
        Canvas { context, size in
            let groundY = size.height - GameConstants.groundY

            // Main ground line
            var linePath = Path()
            linePath.move(to: CGPoint(x: 0, y: groundY))
            linePath.addLine(to: CGPoint(x: size.width, y: groundY))
            context.stroke(linePath, with: .color(color), lineWidth: 2)

            // Ground texture dots/dashes
            let dotSpacing: CGFloat = 20
            let totalWidth = size.width + dotSpacing
            let startX = offset.truncatingRemainder(dividingBy: dotSpacing) - dotSpacing

            var x = startX
            var toggle = false
            while x < totalWidth {
                let dotWidth: CGFloat = toggle ? 8 : 4
                let dotHeight: CGFloat = toggle ? 2 : 1.5
                let dotY = groundY + CGFloat.random(in: 3...8)

                var dotPath = Path()
                dotPath.addRoundedRect(
                    in: CGRect(x: x, y: dotY, width: dotWidth, height: dotHeight),
                    cornerSize: CGSize(width: 1, height: 1)
                )
                context.fill(dotPath, with: .color(color.opacity(0.6)))

                x += dotSpacing + (toggle ? 12 : 8)
                toggle.toggle()
            }
        }
        .frame(width: screenWidth, height: screenHeight)
        .allowsHitTesting(false)
    }
}
