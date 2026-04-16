import SwiftUI

// MARK: - Complete Dino with Eye
struct DinoWithEye: View {
    let animFrame: Int
    let isDucking: Bool
    let isDead: Bool

    private var bodyColor: Color {
        isDead
            ? Color(red: 0.55, green: 0.55, blue: 0.55)
            : Color(red: 0.30, green: 0.30, blue: 0.30)
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            if isDucking {
                DuckingDinoShape(animFrame: animFrame)
                    .fill(bodyColor)
                    .frame(width: 64, height: 30)

                // Eye when ducking
                Circle()
                    .fill(Color.white)
                    .frame(width: 7, height: 7)
                    .offset(x: 47, y: 3)

                if !isDead {
                    Circle()
                        .fill(bodyColor)
                        .frame(width: 4, height: 4)
                        .offset(x: 49, y: 5)
                } else {
                    Text("✕")
                        .font(.system(size: 6, weight: .black))
                        .foregroundColor(bodyColor)
                        .offset(x: 47, y: 3)
                }
            } else {
                RunningDinoShape(animFrame: animFrame, isDead: isDead)
                    .fill(bodyColor)
                    .frame(width: GameConstants.dinoWidth, height: GameConstants.dinoHeight)

                // Eye (white sclera)
                Circle()
                    .fill(Color.white)
                    .frame(width: 8, height: 8)
                    .offset(x: 35, y: 4)

                if isDead {
                    // X eyes
                    Text("✕")
                        .font(.system(size: 7, weight: .black))
                        .foregroundColor(bodyColor)
                        .offset(x: 34, y: 3)
                } else {
                    // Pupil
                    Circle()
                        .fill(bodyColor)
                        .frame(width: 5, height: 5)
                        .offset(x: 37, y: 6)
                }
            }
        }
    }
}

// MARK: - Running Dino Shape
struct RunningDinoShape: Shape {
    var animFrame: Int
    var isDead: Bool

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width   // 50
        let h = rect.height  // 54

        // ---- Body ----
        path.addRoundedRect(
            in: CGRect(x: w * 0.12, y: h * 0.10, width: w * 0.72, height: h * 0.52),
            cornerSize: CGSize(width: 5, height: 5)
        )

        // ---- Head ----
        path.addRoundedRect(
            in: CGRect(x: w * 0.40, y: 0, width: w * 0.60, height: h * 0.36),
            cornerSize: CGSize(width: 5, height: 5)
        )

        // ---- Neck connector ----
        path.addRect(CGRect(x: w * 0.40, y: h * 0.08, width: w * 0.24, height: h * 0.18))

        // ---- Tail ----
        path.move(to: CGPoint(x: w * 0.14, y: h * 0.28))
        path.addLine(to: CGPoint(x: 0, y: h * 0.20))
        path.addLine(to: CGPoint(x: 0, y: h * 0.36))
        path.addLine(to: CGPoint(x: w * 0.14, y: h * 0.48))
        path.closeSubpath()

        // ---- Arm ----
        path.addRoundedRect(
            in: CGRect(x: w * 0.52, y: h * 0.40, width: w * 0.18, height: h * 0.16),
            cornerSize: CGSize(width: 2, height: 2)
        )

        // ---- Legs (animated) ----
        if isDead {
            // Both legs straight down
            path.addRoundedRect(
                in: CGRect(x: w * 0.20, y: h * 0.62, width: w * 0.18, height: h * 0.38),
                cornerSize: CGSize(width: 3, height: 3)
            )
            path.addRoundedRect(
                in: CGRect(x: w * 0.44, y: h * 0.62, width: w * 0.18, height: h * 0.38),
                cornerSize: CGSize(width: 3, height: 3)
            )
        } else if animFrame == 0 {
            // Left leg forward
            path.addRoundedRect(
                in: CGRect(x: w * 0.18, y: h * 0.60, width: w * 0.18, height: h * 0.40),
                cornerSize: CGSize(width: 3, height: 3)
            )
            // Right leg back (shorter)
            path.addRoundedRect(
                in: CGRect(x: w * 0.44, y: h * 0.66, width: w * 0.18, height: h * 0.28),
                cornerSize: CGSize(width: 3, height: 3)
            )
            // Feet
            path.addRect(CGRect(x: w * 0.14, y: h * 0.92, width: w * 0.26, height: h * 0.08))
            path.addRect(CGRect(x: w * 0.42, y: h * 0.88, width: w * 0.22, height: h * 0.06))
        } else {
            // Right leg forward
            path.addRoundedRect(
                in: CGRect(x: w * 0.18, y: h * 0.66, width: w * 0.18, height: h * 0.28),
                cornerSize: CGSize(width: 3, height: 3)
            )
            path.addRoundedRect(
                in: CGRect(x: w * 0.44, y: h * 0.60, width: w * 0.18, height: h * 0.40),
                cornerSize: CGSize(width: 3, height: 3)
            )
            // Feet
            path.addRect(CGRect(x: w * 0.14, y: h * 0.88, width: w * 0.22, height: h * 0.06))
            path.addRect(CGRect(x: w * 0.42, y: h * 0.92, width: w * 0.26, height: h * 0.08))
        }

        return path
    }
}

// MARK: - Ducking Dino Shape
struct DuckingDinoShape: Shape {
    var animFrame: Int

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width   // 64
        let h = rect.height  // 30

        // Low body
        path.addRoundedRect(
            in: CGRect(x: 0, y: h * 0.08, width: w * 0.60, height: h * 0.60),
            cornerSize: CGSize(width: 4, height: 4)
        )

        // Low head
        path.addRoundedRect(
            in: CGRect(x: w * 0.48, y: 0, width: w * 0.52, height: h * 0.62),
            cornerSize: CGSize(width: 4, height: 4)
        )

        // Tail
        path.move(to: CGPoint(x: 0, y: h * 0.24))
        path.addLine(to: CGPoint(x: -w * 0.08, y: h * 0.14))
        path.addLine(to: CGPoint(x: -w * 0.08, y: h * 0.42))
        path.addLine(to: CGPoint(x: 0, y: h * 0.55))
        path.closeSubpath()

        // Legs
        if animFrame == 0 {
            path.addRoundedRect(
                in: CGRect(x: w * 0.08, y: h * 0.65, width: w * 0.18, height: h * 0.35),
                cornerSize: CGSize(width: 3, height: 3)
            )
            path.addRoundedRect(
                in: CGRect(x: w * 0.30, y: h * 0.72, width: w * 0.18, height: h * 0.28),
                cornerSize: CGSize(width: 3, height: 3)
            )
        } else {
            path.addRoundedRect(
                in: CGRect(x: w * 0.08, y: h * 0.72, width: w * 0.18, height: h * 0.28),
                cornerSize: CGSize(width: 3, height: 3)
            )
            path.addRoundedRect(
                in: CGRect(x: w * 0.30, y: h * 0.65, width: w * 0.18, height: h * 0.35),
                cornerSize: CGSize(width: 3, height: 3)
            )
        }

        return path
    }
}
