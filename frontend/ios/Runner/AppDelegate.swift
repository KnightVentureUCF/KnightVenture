import UIKit
import Flutter
import GoogleMaps
import flutter_config

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    // TODO: 
    // Figure out how to import this from env file
    // Center map over UCF
    // Enable navigation
    // Enable custom locations
    // Create firebase with locations
    // Create API to get locations
    GMSServices.provideAPIKey(flutter_config.FlutterConfigPlugin.env(for: "GOOGLE_MAPS_KEY"))

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
