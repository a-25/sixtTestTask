// Did not used any local storaging because car positions will change frequently.
// All the data is stored just in memory
class CarRepository {
    private let networkService: CarListable
    // Plain car list
    private(set) var cars: [Car]?
    
    init(networkService: CarListable) {
        self.networkService = networkService
    }
    
    private func update(_ carList: [Car]) {
        cars = carList
//        cars = carList.reduce(into: [:], { partialResult, car in
//            partialResult[car.id] = car
//        })
    }
}

extension CarRepository: CarDatasourceable {
    func loadCars(shouldIgnoreCache: Bool,
                  _ completion: @escaping (Result<Void, Error>) -> Void) {
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
