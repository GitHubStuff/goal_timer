import UIKit
import Flutter
import ObjectiveDropboxOfficial

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    
    if DBClientsManager.handleRedirectURL(url, completion: {a in
        if ((a?.isSuccess()) != nil) {
            print("dropbox auth success")
        } else if (a!.isCancel()) {
            print("dropbox auth cancel")
        } else if (a!.isError()) {
            print("dropbox auth error \(String(describing: a?.errorDescription))")
        }
        //return true;
    }) {
    
    }
    return true;
  }
}


