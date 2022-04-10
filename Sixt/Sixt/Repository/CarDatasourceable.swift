import CoreLocation
protocol CarDatasourceable {
    var cars: [Car]? { get }
    var sort: CartSortOperation { get set }
    func loadCars(shouldIgnoreCache: Bool,
                  currentLocation: CLLocationCoordinate2D?,
                  _ completion: @escaping (Result<Void, Error>) -> Void)
    func car(for index: Int) -> Car?
    func carCount() -> Int
}
