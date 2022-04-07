import MapKit
class CarMapModuleConfigurator {
    func createCarMapController() -> CarMapViewController {
        return CarMapViewController(carDatasource: DI.carDatasource,
                                    errorMessageService: DI.carErrorMessageService,
                                    mapHelper: MapHelper(mapView: MKMapView()))
    }
}
