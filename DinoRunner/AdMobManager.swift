import GoogleMobileAds
import SwiftUI

class AdMobManager: NSObject, GADBannerViewDelegate {
    static let shared = AdMobManager()
    
    var bannerView: GADBannerView?
    
    override init() {
        super.init()
    }
    
    func initializeAdMob() {
        GADMobileAds.sharedInstance().start(completionHandler: nil)
    }
    
    func loadBannerAd(in viewController: UIViewController) {
        let bannerView = GADBannerView(adSize: GADAdSizeBanner)
        bannerView.adUnitID = "ca-app-pub-2331479066428545/7604889398"
        bannerView.rootViewController = viewController
        bannerView.delegate = self
        
        let request = GADRequest()
        bannerView.load(request)
        
        self.bannerView = bannerView
    }
    
    func getBannerView() -> GADBannerView? {
        return bannerView
    }
    
    // MARK: - GADBannerViewDelegate
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("AdMob: Banner ad received")
    }
    
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        print("AdMob: Failed to receive banner ad - \(error.localizedDescription)")
    }
}
