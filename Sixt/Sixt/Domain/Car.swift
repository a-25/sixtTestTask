import Foundation
class Car: NSObject {
    let id: String
    let name: String
    let latitude: Double
    let longitude: Double
    
    init(
        id: String,
        name: String,
        latitude: Double,
        longitude: Double
    ) {
        self.id = id
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        super.init()
    }
}
