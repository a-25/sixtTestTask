// Did not used any local storaging because car positions will change frequently.
// All the data is stored just in memory
class CarRepository {
    private let networkService: CarListable
    // Plain car list
    private var cars = [String: Car]()
    
    init(networkService: CarListable) {
        self.networkService = networkService
    }
    
    private func update(_ carList: [Car]) {
        cars = carList.reduce(into: [:], { partialResult, car in
            partialResult[car.id] = car
        })
    }
}

extension CarRepository: CarDatasourceable {
    func fetchCarList(_ completion: @escaping (Result<[Car], Error>) -> Void) {
        networkService.loadCarList { [weak self] result in
            switch result {
            case let .success(carList):
                self?.update(carList)
                completion(.success((carList)))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
