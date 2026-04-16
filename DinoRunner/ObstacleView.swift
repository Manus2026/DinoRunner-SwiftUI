import SwiftUI

// MARK: - Small Cactus Shape
struct CactusSmallShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height

        // Main trunk
        path.addRoundedRect(
            in: CGRect(x: w * 0.35, y: h * 0.12, width: w * 0.30, height: h * 0.88),
            cornerSize: CGSize(width: 3, height: 3)
        )

        // Left arm horizontal
        path.addRoundedRect(
            in: CGRect(x: 0, y: h * 0.38, width: w * 0.38, height: h * 0.16),
            cornerSize: CGSize(width: 2, height: 2)
        )
        // Left arm vertical (upward)
        path.addRoundedRect(
            in: CGRect(x: 0, y: h * 0.14, width: w * 0.20, height: h * 0.26),
            cornerSize: CGSize(width: 2, height: 2)
        )

        // Right arm horizontal
        path.addRoundedRect(
            in: CGRect(x: w * 0.62, y: h * 0.48, width: w * 0.38, height: h * 0.16),
            cornerSize: CGSize(width: 2, height: 2)
        )
        // Right arm vertical (upward)
        path.addRoundedRect(
            in: CGRect(x: w * 0.80, y: h * 0.24, width: w * 0.20, height: h * 0.26),
            cornerSize: CGSize(width: 2, height: 2)
        )

        // Top spike
        path.move(to: CGPoint(x: w * 0.50, y: 0))
        path.addLine(to: CGPoint(x: w * 0.36, y: h * 0.15))
        path.addLine(to: CGPoint(x: w * 0.64, y: h * 0.15))
        path.closeSubpath()

        return path
    }
}

// MARK: - Large Cactus Shape
struct CactusLargeShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height

        // Main trunk
        path.addRoundedRect(
            in: CGRect(x: w * 0.30, y: h * 0.08, width: w * 0.40, height: h * 0.92),
            cornerSize: CGSize(width: 4, height: 4)
        )

        // Left arm horizontal
        path.addRoundedRect(
            in: CGRect(x: 0, y: h * 0.30, width: w * 0.33, height: h * 0.16),
            cornerSize: CGSize(width: 3, height: 3)
        )
        // Left arm vertical
        path.addRoundedRect(
            in: CGRect(x: 0, y: h * 0.08, width: w * 0.22, height: h * 0.26),
            cornerSize: CGSize(width: 3, height: 3)
        )

        // Right arm horizontal
        path.addRoundedRect(
            in: CGRect(x: w * 0.67, y: h * 0.40, width: w * 0.33, height: h * 0.16),
            cornerSize: CGSize(width: 3, height: 3)
        )
        // Right arm vertical
        path.addRoundedRect(
            in: CGRect(x: w * 0.78, y: h * 0.18, width: w * 0.22, height: h * 0.26),
            cornerSize: CGSize(width: 3, height: 3)
        )

        // Top spike
        path.move(to: CGPoint(x: w * 0.50, y: 0))
        path.addLine(to: CGPoint(x: w * 0.33, y: h * 0.10))
        path.addLine(to: CGPoint(x: w * 0.67, y: h * 0.10))
        path.closeSubpath()

        return path
    }
}

// MARK: - Double Cactus Shape
struct CactusDoubleShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height

        // ---- Left small cactus ----
        // Trunk
        path.addRoundedRect(
            in: CGRect(x: w * 0.04, y: h * 0.28, width: w * 0.20, height: h * 0.72),
            cornerSize: CGSize(width: 3, height: 3)
        )
        // Left arm
        path.addRoundedRect(
            in: CGRect(x: 0, y: h * 0.42, width: w * 0.06, height: h * 0.12),
            cornerSize: CGSize(width: 2, height: 2)
        )
        path.addRoundedRect(
            in: CGRect(x: 0, y: h * 0.28, width: w * 0.06, height: h * 0.18),
            cornerSize: CGSize(width: 2, height: 2)
        )
        // Spike
        path.move(to: CGPoint(x: w * 0.14, y: h * 0.10))
        path.addLine(to: CGPoint(x: w * 0.05, y: h * 0.30))
        path.addLine(to: CGPoint(x: w * 0.23, y: h * 0.30))
        path.closeSubpath()

        // ---- Right large cactus ----
        // Trunk
        path.addRoundedRect(
            in: CGRect(x: w * 0.56, y: h * 0.10, width: w * 0.30, height: h * 0.90),
            cornerSize: CGSize(width: 4, height: 4)
        )
        // Right arm
        path.addRoundedRect(
            in: CGRect(x: w * 0.86, y: h * 0.32, width: w * 0.14, height: h * 0.14),
            cornerSize: CGSize(width: 2, height: 2)
        )
        path.addRoundedRect(
            in: CGRect(x: w * 0.88, y: h * 0.12, width: w * 0.12, height: h * 0.24),
            cornerSize: CGSize(width: 2, height: 2)
        )
        // Left arm of right cactus
        path.addRoundedRect(
            in: CGRect(x: w * 0.38, y: h * 0.38, width: w * 0.20, height: h * 0.14),
            cornerSize: CGSize(width: 2, height: 2)
        )
        path.addRoundedRect(
            in: CGRect(x: w * 0.38, y: h * 0.18, width: w * 0.12, height: h * 0.24),
            cornerSize: CGSize(width: 2, height: 2)
        )
        // Spike
        path.move(to: CGPoint(x: w * 0.71, y: 0))
        path.addLine(to: CGPoint(x: w * 0.58, y: h * 0.12))
        path.addLine(to: CGPoint(x: w * 0.84, y: h * 0.12))
        path.closeSubpath()

        return path
    }
}

// MARK: - Bird (Pterodactyl) Shape
struct BirdShape: Shape {
    var frame: Int

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height

        // Body
        path.addEllipse(in: CGRect(x: w * 0.22, y: h * 0.28, width: w * 0.52, height: h * 0.44))

        // Head
        path.addEllipse(in: CGRect(x: w * 0.62, y: h * 0.12, width: w * 0.26, height: h * 0.34))

        // Beak
        path.move(to: CGPoint(x: w * 0.86, y: h * 0.24))
        path.addLine(to: CGPoint(x: w * 1.0, y: h * 0.30))
        path.addLine(to: CGPoint(x: w * 0.86, y: h * 0.38))
        path.closeSubpath()

        // Tail
        path.move(to: CGPoint(x: w * 0.24, y: h * 0.38))
        path.addLine(to: CGPoint(x: 0, y: h * 0.28))
        path.addLine(to: CGPoint(x: 0, y: h * 0.50))
        path.addLine(to: CGPoint(x: w * 0.24, y: h * 0.55))
        path.closeSubpath()

        // Wings (animated up/down)
        if frame == 0 {
            // Wings up
            path.move(to: CGPoint(x: w * 0.30, y: h * 0.30))
            path.addCurve(
                to: CGPoint(x: w * 0.68, y: h * 0.30),
                control1: CGPoint(x: w * 0.38, y: -h * 0.05),
                control2: CGPoint(x: w * 0.60, y: -h * 0.05)
            )
            path.addLine(to: CGPoint(x: w * 0.68, y: h * 0.42))
            path.addLine(to: CGPoint(x: w * 0.30, y: h * 0.42))
            path.closeSubpath()
        } else {
            // Wings down
            path.move(to: CGPoint(x: w * 0.30, y: h * 0.42))
            path.addCurve(
                to: CGPoint(x: w * 0.68, y: h * 0.42),
                control1: CGPoint(x: w * 0.38, y: h * 1.05),
                control2: CGPoint(x: w * 0.60, y: h * 1.05)
            )
            path.addLine(to: CGPoint(x: w * 0.68, y: h * 0.30))
            path.addLine(to: CGPoint(x: w * 0.30, y: h * 0.30))
            path.closeSubpath()
        }

        return path
    }
}
