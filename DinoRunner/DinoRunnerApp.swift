import SwiftUI
import GoogleMobileAds

@main
struct DinoRunnerApp: App {
    init() {
        GADMobileAds.sharedInstance().start(completionHandler: nil)
    }
    
    var body: some Scene {
        WindowGroup {
            VStack(spacing: 0) {
                ContentView()
                    .preferredColorScheme(nil)
                
                BannerAdView()
                    .frame(height: 50)
                    .background(Color.black.opacity(0.05))
            }
        }
    }
}

struct BannerAdView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        let bannerView = GADBannerView(adSize: GADAdSizeBanner)
        
        // 使用使用者提供的廣告單元 ID
        bannerView.adUnitID = "ca-app-pub-2331479066428545/7604889398"
        bannerView.rootViewController = viewController
        viewController.view.addSubview(bannerView)
        
        let request = GADRequest()
        bannerView.load(request)
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
