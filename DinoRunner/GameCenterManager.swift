import GameKit
import SwiftUI

class GameCenterManager: NSObject, GKGameCenterControllerDelegate {
    static let shared = GameCenterManager()
    
    let leaderboardID = "com.dinorunner.scores"
    
    override init() {
        super.init()
    }
    
    func authenticatePlayer() {
        GKLocalPlayer.local.authenticateHandler = { viewController, error in
            if let viewController = viewController {
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let rootViewController = windowScene.windows.first?.rootViewController {
                    rootViewController.present(viewController, animated: true)
                }
            }
            
            if let error = error {
                print("Game Center authentication error: \(error.localizedDescription)")
            }
        }
    }
    
    func submitScore(_ score: Int) {
        guard GKLocalPlayer.local.isAuthenticated else {
            print("Player not authenticated for Game Center")
            return
        }

        GKLeaderboard.submitScore(
            score,
            context: 0,
            player: GKLocalPlayer.local,
            leaderboardIDs: [leaderboardID]
        ) { error in
            if let error = error {
                print("Error submitting score to Game Center: \(error.localizedDescription)")
            } else {
                print("Score \(score) submitted to Game Center successfully")
            }
        }
    }
    
    func showLeaderboard(from viewController: UIViewController) {
        guard GKLocalPlayer.local.isAuthenticated else {
            print("Player not authenticated")
            return
        }
        
        let gcViewController = GKGameCenterViewController(leaderboardID: leaderboardID, playerScope: .global, timeScope: .allTime)
        gcViewController.gameCenterDelegate = self
        viewController.present(gcViewController, animated: true)
    }
    
    // MARK: - GKGameCenterControllerDelegate
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true)
    }
}
