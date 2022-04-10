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
//{
//    +"id": "WMWSW31030T222518",
//    "modelIdentifier": "mini",
//    +"modelName": "MINI",
//    +"name": "Vanessa",
//    +"make": "BMW",
//    "group": "MINI",
//    +"color": "midnight_black",
//    "series": "MINI",
//    +"fuelType": "D",
//    +"fuelLevel": 0.7,
//    +"transmission": "M",
//    +"licensePlate": "M-VO0259",
//    +"innerCleanliness": "REGULAR",
//}
