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
    // Get Initial Map Working
    // Figure out how to import this from env file
    GMSServices.provideAPIKey("AIzaSyBUlNW4NphAsVsZTtOeRoFSE9-MdN1jXWA")

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
