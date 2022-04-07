import UIKit
class CarSelectModuleConfigurator {
    func createCarSelectController(
        for navigationController: UINavigationController
    ) -> CarSelectViewController {
        let listConfigurator = CarListModuleConfigurator()
        let mapConfigurator = CarMapModuleConfigurator()
        return CarSelectViewController(listController: listConfigurator.createCarListController(),
                                       mapController: mapConfigurator.createCarMapController())
    }
}
