enum FuelType: String {
    case diesel = "D"
    case petrol = "P"
    case electic = "E"
}

extension FuelType: Codable {}

extension FuelType: Equatable {}
