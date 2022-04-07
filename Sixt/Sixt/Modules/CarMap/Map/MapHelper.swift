import MapKit
import CoreLocation

class MapHelper {
    let mapView: MKMapView
    private static let maxDegrees = CLLocationDegrees(360)
    private static let minimumZoomArc = CLLocationDegrees(0.003)
    
    init(mapView: MKMapView) {
        self.mapView = mapView
    }
    
    func centerMap(_ point: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(
            center: point,
            latitudinalMeters: 50000,
            longitudinalMeters: 60000)
        if #available(iOS 13.0, *) {
            mapView.setCameraBoundary(
                MKMapView.CameraBoundary(coordinateRegion: region),
                animated: true)
            let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 200000)
            mapView.setCameraZoomRange(zoomRange, animated: true)
        } else {
            // Fallback on earlier versions
        }
    }
    
    func reloadMap(with cars: [Car]?) {
        mapView.removeAnnotations(mapView.annotations)
        if let cars = cars,
           !cars.isEmpty {
            mapView.addAnnotations(cars)
        }
        zoomToFit(with: cars)
    }
    
    private func zoomToFit(with cars: [Car]?) {
        guard let cars = cars,
              !cars.isEmpty else {
            // Center on user location
            centerMap(mapView.userLocation.coordinate)
            return
        }
        
        let mapRect = MKPolygon(coordinates: cars.map { $0.coordinate }, count: cars.count).boundingMapRect
        var region = MKCoordinateRegion(mapView.mapRectThatFits(mapRect))

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
}
