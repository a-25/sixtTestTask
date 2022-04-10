import UIKit
class CarDetailsModuleConfigurator {
    func createCarDetailsController(car: Car) -> CarDetailsViewController {
        let detailsController = CarDetailsViewController(
            imageLoader: DI.imageLoader,
            car: car
        ) { controller in
            controller.dismiss(animated: true)
        }
        detailsController.modalPresentationStyle = .overCurrentContext
        detailsController.modalTransitionStyle = .coverVertical
        
        return detailsController
    }
}
