import CoreLocation

class CarSort {
    /// Maximum distance in kilometers that influences the rating. If the distance between the user and cars are more than 100 km, the difference between cars is ignored
    private static let maximumDistanceKmRating = Int(100)
    
    func sorted(_ carList: [Car],
                by sort: CartSortOperation,
                currentLocation: CLLocationCoordinate2D?
    ) -> [Car] {
        switch sort {
        case .sortRating:
            return sortedByRating(carList, currentLocation: currentLocation)
        case .sortDistance:
            return sortedByDistance(carList, currentLocation: currentLocation)
        }
    }
    
    func sortedByRating(_ carList: [Car], currentLocation: CLLocationCoordinate2D?) -> [Car] {
        return carList.sorted(by: { overallRating(for: $0, currentLocation: currentLocation) > overallRating(for: $1, currentLocation: currentLocation) })
    }
    
    func sortedByDistance(_ carList: [Car], currentLocation: CLLocationCoordinate2D?) -> [Car] {
        return carList.sorted(by: { distanceRating(for: $0, currentLocation: currentLocation) > distanceRating(for: $1, currentLocation: currentLocation) })
    }
    
    private func overallRating(for car: Car, currentLocation: CLLocationCoordinate2D?) -> Int {
        var rating = 0
        rating += Int(car.fuelLevel * 100) * 10
        rating += distanceRating(for: car, currentLocation: currentLocation)
        switch car.innerCleanliness {
        case .regular:
            rating += 10
        case .clean:
            rating += 30
        case .veryClean:
            rating += 70
        case .none:
            break
        }
        return rating
    }
    
    private func distanceRating(for car: Car, currentLocation: CLLocationCoordinate2D?) -> Int {
        var rating = 0
        if let currentLocation = currentLocation {
            let distance = CLLocation(latitude: car.latitude, longitude: car.longitude).distance(from: CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude))
            rating += min(Int(distance / 1_000), Self.maximumDistanceKmRating) * 50
        }
        return rating
    }
}
