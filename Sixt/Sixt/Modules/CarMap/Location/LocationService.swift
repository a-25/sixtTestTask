import CoreLocation

class LocationService: NSObject {
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.delegate = self
    }
    
    var cachedLocation: CLLocation? {
        return locationManager.location
    }
    
    var authorizationStatus: CLAuthorizationStatus {
        return CLLocationManager.authorizationStatus()
    }
    
    func requestLocation(completion: ((Result<Void, LocationError>) -> Void)?) {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
            completion?(.success(()))
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            completion?(.success(()))
        case .denied:
            completion?(.failure(LocationError(status: CLLocationManager.authorizationStatus(), error: CLError(.denied))))
        case .restricted:
            completion?(.failure(LocationError(status: CLLocationManager.authorizationStatus(), error: CLError(.denied))))
        @unknown default:
            completion?(.failure(LocationError(status: CLLocationManager.authorizationStatus(), error: CLError(.denied))))
        }
    }
}

extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) { }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) { }
}
