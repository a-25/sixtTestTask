import Foundation
import UIKit

// Of course, in a real project we will possibly have some library or more advanced mechanism.
// But for this implementation it is the most simple way.
class DI {
    private static let networkService: NetworkService = {
        return NetworkService(baseUrl: "https://cdn.sixt.io",
                              carMapper: CarMapper())
    }()
    
    private static let sortService: CarSortable = {
        return CarSort()
    }()
    
    private static let carRepository: CarRepository = {
        return CarRepository(networkService: networkService, sortService: sortService)
    }()
    
    static let carDatasource: CarDatasourceable = {
        return carRepository
    }()
    
    private static let errorMessageServiceInstance: ErrorMessageService = {
        return ErrorMessageService()
    }()
    
    static let carErrorMessageService: CarErrorable = {
        return errorMessageServiceInstance
    }()
    
    static let imageLoader: ImageLoaderService = {
        return ImageLoaderService()
    }()
    
    static let locationService: LocationService = {
        return LocationService()
    }()
    
    static let carReloadHelper: CarReloadable = {
        return CarReloadHelper(carDatasource: carDatasource,
                               locationService: locationService,
                               errorMessageService: carErrorMessageService)
    }()
}
