import UIKit
import ProgressHUD

class CarReloadHelper {
    private let carDatasource: CarDatasourceable
    private let locationService: LocationService
    private let errorMessageService: CarErrorable
    private(set) var lastErrorMessage: String?
    
    init(
        carDatasource: CarDatasourceable,
        locationService: LocationService,
        errorMessageService: CarErrorable
    ) {
        self.carDatasource = carDatasource
        self.locationService = locationService
        self.errorMessageService = errorMessageService
    }
}
 
extension CarReloadHelper: CarReloadable {
    func refreshCars(
        shouldIgnoreCache: Bool,
        _ completion: @escaping (Bool) -> Void
    ) {
        ProgressHUD.show()
        
        carDatasource.loadCars(
            shouldIgnoreCache: shouldIgnoreCache,
            currentLocation: locationService.cachedLocation?.coordinate
        ) { [weak self] result in
            defer { ProgressHUD.dismiss() }
            guard let self = self else {
                completion(false)
                return
            }
            switch result {
            case .success:
                self.lastErrorMessage = self.carDatasource.carCount() > 0 ? nil : "There are no cars here"
            case let .failure(error):
                self.lastErrorMessage = self.errorMessageService.getCarMessage(for: error)
            }
            completion(true)
        }
    }
}
