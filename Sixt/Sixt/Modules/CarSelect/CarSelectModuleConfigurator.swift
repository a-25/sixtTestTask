import UIKit
class CarSelectModuleConfigurator {
    func createCarSelectController(
        for navigationController: UINavigationController/*,
        onCategorySelected: @escaping (Car) -> Void*/
    ) -> CarSelectViewController {
        return CarSelectViewController(listController: UIViewController(),
                                       mapController: UIViewController())
    }
}
