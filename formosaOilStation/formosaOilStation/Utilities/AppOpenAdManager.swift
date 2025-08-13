//
//  AppOpenAdManager.swift
//  formosaOilStation
//
//  Created by 10362 on 2025/8/13.
//

import Foundation
import GoogleMobileAds

class AppOpenAdManager: NSObject {
    /// The app open ad.
    var appOpenAd: AppOpenAd?
    /// Maintains a reference to the delegate.
    weak var appOpenAdManagerDelegate: AppOpenAdManagerDelegate?
    /// Keeps track of if an app open ad is loading.
    var isLoadingAd = false
    /// Keeps track of if an app open ad is showing.
    var isShowingAd = false
    /// Keeps track of the time when an app open ad was loaded to discard expired ad.
    var loadTime: Date?
    /// For more interval details, see https://support.google.com/admob/answer/9341964
    let timeoutInterval: TimeInterval = 4 * 3_600
    
    static let shared = AppOpenAdManager()
    
    func loadAd() async {
        // Do not load ad if there is an unused ad or one is already loading.
        if isLoadingAd || isAdAvailable() {
            return
        }
        isLoadingAd = true
        
        do {
            appOpenAd = try await AppOpenAd.load(
                with: "ca-app-pub-3940256099942544/5575463023", request: Request())
            appOpenAd?.fullScreenContentDelegate = self
            loadTime = Date()
        } catch {
            print("App open ad failed to load with error: \(error.localizedDescription)")
            appOpenAd = nil
            loadTime = nil
        }
        isLoadingAd = false
    }
    
    func showAdIfAvailable() {
        // If the app open ad is already showing, do not show the ad again.
        if isShowingAd {
            return print("App open ad is already showing.")
        }
        
        // If the app open ad is not available yet but is supposed to show, load
        // a new ad.
        if !isAdAvailable() {
            print("App open ad is not ready yet.")
            // The app open ad is considered to be complete in this example.
            appOpenAdManagerDelegate?.appOpenAdManagerAdDidComplete(self)
            // Load a new ad.
            return
        }
        
        if let appOpenAd {
            appOpenAd.present(from: nil)
            isShowingAd = true
        }
    }
    private func isAdAvailable() -> Bool {
        // Check if ad exists and can be shown.
        return appOpenAd != nil && wasLoadTimeLessThanNHoursAgo(timeoutInterval: timeoutInterval)
    }
    
    private func wasLoadTimeLessThanNHoursAgo(timeoutInterval: TimeInterval) -> Bool {
        // Check if ad was loaded more than n hours ago.
        if let loadTime = loadTime {
            return Date().timeIntervalSince(loadTime) < timeoutInterval
        }
        return false
    }
}

extension AppOpenAdManager: FullScreenContentDelegate {
    // [START ad_events]
    func adDidRecordImpression(_ ad: FullScreenPresentingAd) {
        print("App open ad recorded an impression.")
    }
    
    func adDidRecordClick(_ ad: FullScreenPresentingAd) {
        print("App open ad recorded a click.")
    }
    
    func adWillDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        print("App open ad will be dismissed.")
    }
    
    func adWillPresentFullScreenContent(_ ad: FullScreenPresentingAd) {
        print("App open ad will be presented.")
    }
    
    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        print("App open ad was dismissed.")
        appOpenAd = nil
        isShowingAd = false
        appOpenAdManagerDelegate?.appOpenAdManagerAdDidComplete(self)
        Task {
            await loadAd()
        }
    }
    
    func ad(
        _ ad: FullScreenPresentingAd,
        didFailToPresentFullScreenContentWithError error: Error
    ) {
        print("App open ad failed to present with error: \(error.localizedDescription)")
        appOpenAd = nil
        isShowingAd = false
        appOpenAdManagerDelegate?.appOpenAdManagerAdDidComplete(self)
        Task {
            await loadAd()
        }
    }
    // [END ad_events]
}

protocol AppOpenAdManagerDelegate: AnyObject {
  /// Method to be invoked when an app open ad life cycle is complete (i.e. dismissed or fails to
  /// show).
  func appOpenAdManagerAdDidComplete(_ appOpenAdManager: AppOpenAdManager)
}

