protocol CarReloadable {
    var lastErrorMessage: String? { get }
    func refreshCars(
        shouldIgnoreCache: Bool,
        _ completion: @escaping (Bool) -> Void
    )
}
