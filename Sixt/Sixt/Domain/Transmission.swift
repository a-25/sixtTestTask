enum Transmission: String {
    case m = "M"
    case t = "T"
}

extension Transmission: Codable {}

enum TransmissionType {
    case exact(Transmission)
    case custom(String)
}
