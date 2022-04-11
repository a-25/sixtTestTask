enum Transmission: String {
    case m = "M"
    case a = "A"
}

extension Transmission: Codable {}

extension Transmission: Equatable {}

enum TransmissionType {
    case exact(Transmission)
    case custom(String)
}

extension TransmissionType: Equatable {}
