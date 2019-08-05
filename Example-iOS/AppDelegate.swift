import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    #if DEBUG
    // Load InjectionIII bundle
    // https://itunes.apple.com/us/app/injectioniii/id1380446739?mt=12
    Bundle(path: "/Applications/InjectionIII.app/Contents/Resources/iOSInjection.bundle")?.load()
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(injected(_:)),
      name: NSNotification.Name(rawValue: "INJECTION_BUNDLE_NOTIFICATION"),
      object: nil
    )
    #endif

    loadApplication()

    return true
  }

  func loadApplication() {
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.backgroundColor = .groupTableViewBackground
    window?.rootViewController = RootViewController()
    window?.makeKeyAndVisible()
  }

  @objc func injected(_ notification: Notification) {
    loadApplication()
  }
}

extension AppDelegate {

  var rootViewController: RootViewController {
    return window!.rootViewController as! RootViewController
  }
}
