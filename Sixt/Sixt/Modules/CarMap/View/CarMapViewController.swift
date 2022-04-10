import UIKit
import MapKit
import SnapKit
import Foundation
import ProgressHUD

class CarMapViewController: UIViewController {
    private let carDatasource: CarDatasourceable
    private let errorMessageService: CarErrorable
    private let mapHelper: MapHelper
    private var lastErrorMessage: String?
    private static let annotationIdentifier = "CarAnnotation"
    
    init(
        carDatasource: CarDatasourceable,
        errorMessageService: CarErrorable,
        mapHelper: MapHelper
    ) {
        self.carDatasource = carDatasource
        self.errorMessageService = errorMessageService
        self.mapHelper = mapHelper
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
        mapHelper.mapView.delegate = self
        mapHelper.mapView.showsUserLocation = true
        view.addSubview(mapHelper.mapView)
        mapHelper.mapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        // Place the cars
        refreshCars()
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
            self.mapHelper.reloadMap(with: self.carDatasource.cars)
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
        
        let vc = CarDetailsViewController() { [weak self] in
            vc.dismiss()
        }
        vc.modalPresentationStyle = .custom
        present(vc, animated: true)
    }
}
