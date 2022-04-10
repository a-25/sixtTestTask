import MapKit
import UIKit
class CarMapModuleConfigurator {
    func createCarMapController(onCarSelected: @escaping (UIViewController, Car) -> Void) -> CarMapViewController {
        let mapController =  CarMapViewController(carDatasource: DI.carDatasource,
                                                  carReloadHelper: DI.carReloadHelper,
                                                  locationService: DI.locationService,
                                                  mapHelper: MapHelper(mapView: MKMapView(), locationService: DI.locationService)) {
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        }
        mapController.onCarSelected = { [weak mapController] car in
            guard let mapController = mapController else {
                return
            }
            onCarSelected(mapController, car)
        }
        return mapController
    }
}
