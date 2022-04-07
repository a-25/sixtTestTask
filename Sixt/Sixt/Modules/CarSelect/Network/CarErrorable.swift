protocol CarErrorable {
    func getCarMessage(for error: Error) -> String?
}
