import UIKit
class CarDetailsModuleConfigurator {
    func createCarDetailsController() -> CarDetailsViewController {
        let detailsController = CarDetailsViewController() { controller in
            controller?.dismiss(animated: true)
        }
        detailsController.modalPresentationStyle = .overCurrentContext
        detailsController.modalTransitionStyle = .coverVertical
        
        return detailsController
    }
}
