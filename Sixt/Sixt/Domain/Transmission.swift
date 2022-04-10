enum Transmission: String {
    case m = "M"
    case a = "A"
}

extension Transmission: Codable {}

enum TransmissionType {
    case exact(Transmission)
    case custom(String)
}
