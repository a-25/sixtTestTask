protocol CarDatasourceable {
    var cars: [Car]? { get }
    func loadCars(shouldIgnoreCache: Bool,
                  _ completion: @escaping (Result<Void, Error>) -> Void)
    func car(for index: Int) -> Car?
    func carCount() -> Int
}
