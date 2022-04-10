import UIKit
class CarListModuleConfigurator {
    func createCarListController(onCarSelected: @escaping (UIViewController, Car) -> Void) -> CarListViewController {
        let listController = CarListViewController(carDatasource: DI.carDatasource,
                                                   errorMessageService: DI.carErrorMessageService,
                                                   imageLoader: DI.imageLoader,
                                                   locationService: DI.locationService)
        listController.onCarSelected = { [weak listController] car in
            guard let listController = listController else {
                return
            }
            onCarSelected(listController, car)
        }
        return listController
    }
}
