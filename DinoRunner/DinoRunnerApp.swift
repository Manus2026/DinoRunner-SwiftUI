import SwiftUI
import GoogleMobileAds

@main
struct DinoRunnerApp: App {
    init() {
        // 在最新版 SDK 中，start 方法的 completionHandler 是可選的，但需要明確指定類型或傳入 nil
        MobileAds.shared.start(completionHandler: nil)
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
        
        let bannerView = BannerView(adSize: AdSizeBanner)
        bannerView.adUnitID = "ca-app-pub-2331479066428545/7604889398"
        bannerView.rootViewController = viewController
        
        viewController.view.addSubview(bannerView)
        
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bannerView.centerXAnchor.constraint(equalTo: viewController.view.centerXAnchor),
            bannerView.bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor)
        ])
        
        let request = Request()
        bannerView.load(request)
        
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
