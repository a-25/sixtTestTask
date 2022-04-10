import MapKit
import CoreLocation

extension Car: MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var title: String? {
        return "\(make), \(modelName)"
    }
    
    var subtitle: String? {
        let transmissionDesc: String
        switch transmission {
        case let .exact(transmission):
            transmissionDesc = transmission.rawValue
        case let .custom(transmission):
            transmissionDesc = transmission
        }
        let fuelPostfix: String
        if let fuelType = fuelType {
            fuelPostfix = ", fuel type: \(fuelType.rawValue)"
        } else {
            fuelPostfix = ""
        }
        let fuelLevelPercent = Int(fuelLevel * 100)
        
        return "Transmission: \(transmissionDesc)\(fuelPostfix), fuel level: \(fuelLevelPercent)%"
    }
}
