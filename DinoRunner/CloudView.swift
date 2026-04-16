import SwiftUI

// MARK: - Cloud View
struct CloudView: View {
    let cloud: Cloud
    let color: Color

    var body: some View {
        CloudShape()
            .fill(color.opacity(0.5))
            .frame(width: cloud.width, height: cloud.height)
            .position(x: cloud.x + cloud.width / 2, y: cloud.y)
    }
}

// MARK: - Cloud Shape
struct CloudShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height

        // Base rectangle
        path.addRoundedRect(
            in: CGRect(x: 0, y: h * 0.4, width: w, height: h * 0.6),
            cornerSize: CGSize(width: h * 0.3, height: h * 0.3)
        )

        // Left bump
        path.addEllipse(in: CGRect(x: w * 0.05, y: h * 0.15, width: w * 0.3, height: h * 0.55))

        // Center bump (tallest)
        path.addEllipse(in: CGRect(x: w * 0.28, y: 0, width: w * 0.38, height: h * 0.7))

        // Right bump
        path.addEllipse(in: CGRect(x: w * 0.58, y: h * 0.2, width: w * 0.32, height: h * 0.5))

        return path
    }
}
