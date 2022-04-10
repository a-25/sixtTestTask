import MapKit
import UIKit
class CarMapModuleConfigurator {
    func createCarMapController(onCarSelected: @escaping (UIViewController, Car) -> Void) -> CarMapViewController {
        let mapController =  CarMapViewController(carDatasource: DI.carDatasource,
                                                  errorMessageService: DI.carErrorMessageService,
                                                  mapHelper: MapHelper(mapView: MKMapView()))
        mapController.onCarSelected = { [weak mapController] car in
            guard let mapController = mapController else {
                return
            }
            onCarSelected(mapController, car)
        }
        return mapController
    }
}
