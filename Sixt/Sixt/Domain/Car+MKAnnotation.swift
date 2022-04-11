import MapKit
import CoreLocation

class CarAnnotation: NSObject, MKAnnotation {
    let car: Car
    
    init(car: Car) {
        self.car = car
        super.init()
    }
    
    var coordinate: CLLocationCoordinate2D {
        return car.coordinate
    }
    
    var title: String? {
        return "\(car.make), \(car.modelName)"
    }
    
    var subtitle: String? {
        let transmissionDesc: String
        switch car.transmission {
        case let .exact(transmission):
            transmissionDesc = transmission.rawValue
        case let .custom(transmission):
            transmissionDesc = transmission
        }
        let fuelPostfix: String
        if let fuelType = car.fuelType {
            fuelPostfix = ", fuel type: \(fuelType.rawValue)"
        } else {
            fuelPostfix = ""
        }
        let fuelLevelPercent = Int(car.fuelLevel * 100)
        
        return "Transmission: \(transmissionDesc)\(fuelPostfix), fuel level: \(fuelLevelPercent)%"
    }
}
