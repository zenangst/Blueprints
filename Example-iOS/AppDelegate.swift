import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        #if DEBUG
        // Load InjectionIII bundle
        // https://itunes.apple.com/us/app/injectioniii/id1380446739?mt=12
        Bundle(path: "/Applications/InjectionIII.app/Contents/Resources/iOSInjection.bundle")?.load()
        #endif

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .groupTableViewBackground
        window?.rootViewController = RootViewController()
        window?.makeKeyAndVisible()

        return true
    }
}

extension AppDelegate {

    var rootViewController: RootViewController {
        return window!.rootViewController as! RootViewController
    }
}
