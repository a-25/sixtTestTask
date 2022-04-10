import CoreLocation

// Did not used any local storaging because car positions will change frequently.
// All the data is stored just in memory
class CarRepository {
    private let networkService: CarListable
    private let sortService: CarSort
    private(set) var cars: [Car]?
    private var currentLocation: CLLocationCoordinate2D?
    var sort: CartSortOperation {
        didSet {
            if let cars = cars {
                update(cars)
            }
        }
    }
    
    init(networkService: CarListable, sortService: CarSort) {
        self.networkService = networkService
        self.sortService = sortService
        self.sort = .sortRating
    }
    
    private func update(_ carList: [Car]) {
        cars = sortService.sorted(carList,
                                  by: sort,
                                  currentLocation: currentLocation)
    }
}

extension CarRepository: CarDatasourceable {
    func loadCars(shouldIgnoreCache: Bool,
                  currentLocation: CLLocationCoordinate2D?,
                  _ completion: @escaping (Result<Void, Error>) -> Void) {
        self.currentLocation = currentLocation
        // If not - the user has an option to pull-to-refresh it.
        guard shouldIgnoreCache || cars == nil else {
            completion(.success(()))
            return
        }
        
        networkService.loadCarList { [weak self] result in
            switch result {
            case let .success(carList):
                self?.update(carList)
                completion(.success(()))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    func car(for index: Int) -> Car? {
        guard let cars = cars,
            cars.count > index else {
            return nil
        }
        return cars[index]
    }
    
    func carCount() -> Int {
        return cars?.count ?? 0
    }
}
