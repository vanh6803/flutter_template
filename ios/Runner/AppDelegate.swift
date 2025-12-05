import Flutter
import UIKit
import ads_tracking_plugin
import google_mobile_ads

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

      let layoutAdLarge = LayoutAdLarge()
      let layoutBottomCTA = LayoutBottomCTA()

      FLTGoogleMobileAdsPlugin.registerNativeAdFactory(
          self,
          factoryId: "layoutMediumCtaFullBottom",
          nativeAdFactory: layoutBottomCTA
      )

      FLTGoogleMobileAdsPlugin.registerNativeAdFactory(
          self,
          factoryId: "layoutAdLarge",
          nativeAdFactory: layoutAdLarge
      )

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
