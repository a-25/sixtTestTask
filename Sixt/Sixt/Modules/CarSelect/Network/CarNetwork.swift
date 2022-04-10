struct CarNetwork: Codable {
    let id: String
    let name: String
    let carImageUrl: String?
    let latitude: Double
    let longitude: Double
    let transmission: String
    let fuelType: String
    let fuelLevel: Double
    let licensePlate: String
    let innerCleanliness: String
    let color: String
    let make: String
    let modelName: String
}
