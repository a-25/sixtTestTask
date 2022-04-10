import UIKit
import MapKit
import SnapKit
import Foundation

class CarMapViewController: UIViewController {
    private let myLocationButton = UIButton()
    private let carDatasource: CarDatasourceable
    private let carReloadHelper: CarReloadable
    private let locationService: LocationService
    private let mapHelper: MapHelper
    private static let annotationIdentifier = "CarAnnotation"
    var onCarSelected: ((Car) -> Void)?
    private let onLocationSettingsRequested: (() -> Void)?
    private var wasLocationRequested = false
    
    init(
        carDatasource: CarDatasourceable,
        carReloadHelper: CarReloadable,
        locationService: LocationService,
        mapHelper: MapHelper,
        onLocationSettingsRequested: (() -> Void)?
    ) {
        self.carDatasource = carDatasource
        self.carReloadHelper = carReloadHelper
        self.locationService = locationService
        self.mapHelper = mapHelper
        self.onLocationSettingsRequested = onLocationSettingsRequested
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard !wasLocationRequested else {
            return
        }
        wasLocationRequested = true
        locationService.requestLocation(completion: nil)
    }
    
    private func setupUI() {
        mapHelper.mapView.delegate = self
        mapHelper.mapView.showsUserLocation = true
        view.addSubview(mapHelper.mapView)
        mapHelper.mapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        myLocationButton.setImage(UIImage(named: "myLocation"), for: .normal)
        myLocationButton.addTarget(self, action: #selector(onMyLocationTap), for: .touchUpInside)
        view.addSubview(myLocationButton)
        myLocationButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.snpSafeArea.bottom).inset(20)
        }
        
        // Place the cars
        refreshCars()
    }
    
    private func refreshCars(shouldIgnoreCache: Bool = false) {
        carReloadHelper.refreshCars(shouldIgnoreCache: shouldIgnoreCache) { [weak self] isSuccess in
            guard let self = self,
                  isSuccess else {
                return
            }
            self.mapHelper.reloadMap(with: self.carDatasource.cars)
        }
    }
    
    @objc private func onMyLocationTap() {
        if let currentLocation = locationService.cachedLocation {
            mapHelper.centerMap(currentLocation.coordinate)
        } else {
            switch locationService.authorizationStatus {
            case .authorizedAlways, .authorizedWhenInUse, .notDetermined:
                break
            case .denied, .restricted:
                let alert = UIAlertController(title: "Location tracking disabled", message: "To use this feature, please, enable the location tracking", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK, I will", style: .default, handler: { [weak self] _ in
                    self?.onLocationSettingsRequested?()
                }))
                alert.addAction(UIAlertAction(title: "No, I won't", style: .cancel, handler: nil))
                present(alert, animated: true, completion: nil)
            @unknown default:
                break
            }
        }
    }
}

extension CarMapViewController: MKMapViewDelegate {
    func mapView(
        _ mapView: MKMapView,
        viewFor annotation: MKAnnotation
    ) -> MKAnnotationView? {
        guard let annotation = annotation as? Car else {
            return nil
        }
        if #available(iOS 11.0, *) {
            var view: MKMarkerAnnotationView
            // 4
            if let dequeuedView = mapView.dequeueReusableAnnotationView(
                withIdentifier: Self.annotationIdentifier) as? MKMarkerAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                // 5
                view = MKMarkerAnnotationView(
                    annotation: annotation,
                    reuseIdentifier: Self.annotationIdentifier)
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
        
        onCarSelected?(car)
    }
}
