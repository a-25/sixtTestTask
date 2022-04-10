import UIKit
class CarSelectModuleConfigurator {
    func createCarSelectController(
        for navigationController: UINavigationController
    ) -> CarSelectViewController {
        let listConfigurator = CarListModuleConfigurator()
        let mapConfigurator = CarMapModuleConfigurator()
        let onCarSelected: (UIViewController, Car) -> Void = { controller, car in
            let detailsController = CarDetailsModuleConfigurator().createCarDetailsController()
            controller.present(detailsController, animated: true)
        }
        return CarSelectViewController(
            listController: listConfigurator.createCarListController(onCarSelected: onCarSelected),
            mapController: mapConfigurator.createCarMapController(onCarSelected: onCarSelected)
        )
    }
}
