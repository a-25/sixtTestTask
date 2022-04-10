@testable import Sixt
import CoreLocation

class CarSortMock: CarSortable {
    private let defaultCarList: [Car]
    private let sortedCars: [CartSortOperation: [Car]]?
    
    init(
        defaultCarList: [Car],
        sortedCars: [CartSortOperation: [Car]]? = nil
    ) {
        self.defaultCarList = defaultCarList
        self.sortedCars = sortedCars
    }
    
    func sorted(
        _ carList: [Car],
        by sort: CartSortOperation,
        currentLocation: CLLocationCoordinate2D?
    ) -> [Car] {
        return sortedCars?[sort] ?? defaultCarList
    }
}
