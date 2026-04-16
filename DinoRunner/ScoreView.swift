import SwiftUI

// ScoreView is now integrated directly in GameView as a computed property.
// This file is kept for potential future use or extensions.

// MARK: - Score Number Formatter (Utility)
extension Int {
    var paddedScore: String {
        String(format: "%05d", self)
    }
}
