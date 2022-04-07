protocol CarDatasourceable {
    func fetchCarList(_ completion: @escaping (Result<[Car], Error>) -> Void)
}
