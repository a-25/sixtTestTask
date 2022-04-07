class ErrorMessageService {
    private static let noInternetMessage = "Please, check the internet connection."
}

extension ErrorMessageService: CarErrorable {
    func getCarMessage(for error: Error) -> String? {
        var errorMessage: String?
        switch error {
        case CarNetworkError.carListUnknown:
            errorMessage = Self.noInternetMessage
        case CarNetworkError.networkError:
            // Here we could write technical debug messages about wrong json parsing and so on.
            errorMessage = "Maybe a parsing error or a network timeout"
        default:
            break
        }
        return errorMessage
    }
}
