import MapKit
import CoreLocation

class MapHelper {
    let mapView: MKMapView
    private let locationService: LocationService
    private static let maxDegrees = CLLocationDegrees(360)
    private static let minimumZoomArc = CLLocationDegrees(0.003)
    private static let maximumSizeCars = Double(100_000) /// meters
    private static let centerRadius = CLLocationDistance(10_000)
    
    init(mapView: MKMapView, locationService: LocationService) {
        self.mapView = mapView
        self.locationService = locationService
    }
    
    func centerMap(_ point: CLLocationCoordinate2D) {
        mapView.setCenter(point, animated: true)
    }
    
    private func zoomDefault() {
        if #available(iOS 13.0, *) {
            mapView.setCameraZoomRange(MKMapView.CameraZoomRange(minCenterCoordinateDistance: Self.centerRadius * 8.0, maxCenterCoordinateDistance: Self.centerRadius * 8.0), animated: true)
        } else {
            let coordinateRegion = MKCoordinateRegion(center: mapView.centerCoordinate,
                                                      latitudinalMeters: Self.centerRadius * 2.0,
                                                      longitudinalMeters: Self.centerRadius * 2.0)
            mapView.setRegion(coordinateRegion, animated: true)
        }
    }
    
    func reloadMap(with cars: [Car]?) {
        mapView.removeAnnotations(mapView.annotations)
        if let cars = cars,
           !cars.isEmpty {
            mapView.addAnnotations(cars.map { CarAnnotation(car: $0) })
        }
        zoomToFit(with: cars)
    }
    
    private func zoomToFit(with cars: [Car]?) {
        guard let cars = cars,
              !cars.isEmpty else {
            // Center on user location
            zoomDefault()
            if let userLocation = locationService.cachedLocation?.coordinate {
                centerMap(userLocation)
            }
            return
        }
        
        let mapRect = MKPolygon(coordinates: cars.map { $0.coordinate }, count: cars.count).boundingMapRect
        var region = MKCoordinateRegion(mapView.mapRectThatFits(normalized(rect: mapRect)))

        if region.span.latitudeDelta > Self.maxDegrees {
            region.span.latitudeDelta  = Self.maxDegrees
        }
        if region.span.longitudeDelta > Self.maxDegrees {
            region.span.longitudeDelta = Self.maxDegrees
        }

        //don't zoom in really close on small samples
        if region.span.latitudeDelta  < Self.minimumZoomArc {
            region.span.latitudeDelta  = Self.minimumZoomArc
        }
        if region.span.longitudeDelta < Self.minimumZoomArc {
            region.span.longitudeDelta = Self.minimumZoomArc
        }
        //if only 1 point, we want max zoom-in instead of max zoom-out
        if cars.count == 1 {
            region.span.latitudeDelta = Self.minimumZoomArc
            region.span.longitudeDelta = Self.minimumZoomArc
        }
        mapView.setRegion(region, animated: true)
    }
    
    private func normalized(rect: MKMapRect) -> MKMapRect {
        let widthRatio = rect.origin.distance(to: MKMapPoint(x: rect.origin.x + rect.size.width, y: rect.origin.y)) / Self.maximumSizeCars
        let heightRatio = rect.origin.distance(to: MKMapPoint(x: rect.origin.x, y: rect.origin.y + rect.size.height)) / Self.maximumSizeCars
        guard widthRatio > 1 || heightRatio > 1 else {
            return rect
        }
        
        let multiplier = max(widthRatio, heightRatio)
        return MKMapRect(origin: rect.origin, size: MKMapSize(width: rect.size.width / multiplier, height: rect.size.height / multiplier))
    }
}
