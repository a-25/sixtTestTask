import Foundation
import CoreLocation

struct Car {
    let id: String
    let name: String
    let latitude: Double
    let longitude: Double
    let carImageUrl: String?
    let transmission: TransmissionType
    let fuelType: FuelType?
    let fuelLevel: Double
    let licensePlate: String
    let innerCleanliness: InnerCleanliness?
    let color: CarColor?
    let make: String
    let modelName: String
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    init(
        id: String,
        name: String,
        latitude: Double,
        longitude: Double,
        carImageUrl: String?,
        transmission: TransmissionType,
        fuelType: FuelType?,
        fuelLevel: Double,
        licensePlate: String,
        innerCleanliness: InnerCleanliness?,
        color: CarColor?,
        make: String,
        modelName: String
    ) {
        self.id = id
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.carImageUrl = carImageUrl
        self.transmission = transmission
        self.fuelType = fuelType
        self.fuelLevel = fuelLevel
        self.licensePlate = licensePlate
        self.innerCleanliness = innerCleanliness
        self.color = color
        self.make = make
        self.modelName = modelName
    }
}

extension Car: Equatable {}
