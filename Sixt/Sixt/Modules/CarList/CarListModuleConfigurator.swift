import UIKit
class CarListModuleConfigurator {
    func createCarListController(onCarSelected: @escaping (UIViewController, Car) -> Void) -> CarListViewController {
        let listController = CarListViewController(carDatasource: DI.carDatasource,
                                                   carReloadHelper: DI.carReloadHelper,
                                                   imageLoader: DI.imageLoader)
        listController.onCarSelected = { [weak listController] car in
            guard let listController = listController else {
                return
            }
            onCarSelected(listController, car)
        }
        return listController
    }
}
