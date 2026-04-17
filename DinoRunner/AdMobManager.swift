import GoogleMobileAds
import SwiftUI

class AdMobManager: NSObject, BannerViewDelegate {
    static let shared = AdMobManager()
    
    var bannerView: BannerView?
    
    override init() {
        super.init()
    }
    
    func initializeAdMob() {
        // 最新版 SDK 語法：MobileAds.sharedInstance().start
        MobileAds.shared.start(completionHandler: nil)
    }
    
    func loadBannerAd(in viewController: UIViewController) {
        // 最新版 SDK 語法：GADBannerView(adSize: GADAdSizeBanner)
        let bannerView = BannerView(adSize: AdSizeBanner)
        bannerView.adUnitID = "ca-app-pub-2331479066428545/7604889398"
        bannerView.rootViewController = viewController
        bannerView.delegate = self
        
        // 最新版 SDK 語法：GADRequest()
        let request = Request()
        bannerView.load(request)
        
        self.bannerView = bannerView
    }
    
    func getBannerView() -> BannerView? {
        return bannerView
    }
    
    // MARK: - GADBannerViewDelegate
    func bannerViewDidReceiveAd(_ bannerView: BannerView) {
        print("AdMob: Banner ad received")
    }
    
    func bannerView(_ bannerView: BannerView, didFailToReceiveAdWithError error: Error) {
        print("AdMob: Failed to receive banner ad - \(error.localizedDescription)")
    }
}
