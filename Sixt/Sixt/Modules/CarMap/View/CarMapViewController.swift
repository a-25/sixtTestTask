import UIKit
import MapKit
import SnapKit
import Foundation
import ProgressHUD

class CarMapViewController: UIViewController {
    private let mapView = MKMapView()
    private let carDatasource: CarDatasourceable
    private let errorMessageService: CarErrorable
    private var lastErrorMessage: String?
    
    init(
        carDatasource: CarDatasourceable,
        errorMessageService: CarErrorable
    ) {
        self.carDatasource = carDatasource
        self.errorMessageService = errorMessageService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        mapView.delegate = self
        mapView.showsUserLocation = true
        view.addSubview(mapView)
        mapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        // Place the cars
        refreshCars()
    }
    
    private func centerMap(_ point: CLLocationCoordinate2D) {
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
    
    private func refreshCars(shouldIgnoreCache: Bool = false) {
        ProgressHUD.show()
        
        carDatasource.loadCars(shouldIgnoreCache: shouldIgnoreCache) { [weak self] result in
            defer { ProgressHUD.dismiss() }
            guard let self = self else {
                return
            }
            switch result {
            case .success:
                self.lastErrorMessage = self.carDatasource.carCount() > 0 ? nil : "There are no cars here"
            case let .failure(error):
                self.lastErrorMessage = self.errorMessageService.getCarMessage(for: error)
            }
            self.reloadMap()
        }
    }
    
    private func reloadMap() {
        mapView.removeAnnotations(mapView.annotations)
        if let cars = carDatasource.cars,
           !cars.isEmpty {
            mapView.addAnnotations(cars)
            centerMap(cars.first!.coordinate)
        }
        // Center on user location
    }
}

extension CarMapViewController: MKMapViewDelegate {
    // 1
    func mapView(
        _ mapView: MKMapView,
        viewFor annotation: MKAnnotation
    ) -> MKAnnotationView? {
        // 2
        guard let annotation = annotation as? Car else {
            return nil
        }
        // 3
        let identifier = "car"
        if #available(iOS 11.0, *) {
            var view: MKMarkerAnnotationView
            // 4
            if let dequeuedView = mapView.dequeueReusableAnnotationView(
                withIdentifier: identifier) as? MKMarkerAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                // 5
                view = MKMarkerAnnotationView(
                    annotation: annotation,
                    reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            }
            return view
        } else {
            return nil
        }
    }
    
    func mapView(
        _ mapView: MKMapView,
        annotationView view: MKAnnotationView,
        calloutAccessoryControlTapped control: UIControl
    ) {
        guard let car = view.annotation as? Car else {
            return
        }
    }

}
