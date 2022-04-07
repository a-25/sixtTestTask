import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let screenWindow = UIWindow(frame: UIScreen.main.bounds)
        let theAppCoordinator = AppCoordinator()
        theAppCoordinator.start()
        appCoordinator = theAppCoordinator
        screenWindow.rootViewController = theAppCoordinator.rootController
        window = screenWindow
        screenWindow.makeKeyAndVisible()
        return true
    }
}

