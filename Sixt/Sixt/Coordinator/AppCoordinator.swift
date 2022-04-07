import UIKit
// Of course, in a real project we will have many coordinators.
// But for two screens one is sufficient.
class AppCoordinator {
    let rootController = UINavigationController()
    
    func start() {
        let carController = CarSelectModuleConfigurator().createCarSelectController(for: rootController)
        rootController.viewControllers = [carController]
    }
}
