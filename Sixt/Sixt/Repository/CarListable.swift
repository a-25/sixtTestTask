protocol CarListable {
    func loadCarList(_ completion: @escaping (Result<[Car], Error>) -> Void)
}
