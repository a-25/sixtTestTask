class CarMapper {
    func map(_ car: CarNetwork) -> Car {
        let carTransission: TransmissionType
        if let transmission = Transmission(rawValue: car.transmission) {
            carTransission = .exact(transmission)
        } else {
            carTransission = .custom(car.transmission)
        }
        return Car(id: car.id,
                   name: car.name,
                   latitude: car.latitude,
                   longitude: car.longitude,
                   carImageUrl: car.carImageUrl,
                   transmission: carTransission,
                   fuelType: FuelType(rawValue: car.fuelType),
                   fuelLevel: car.fuelLevel,
                   licensePlate: car.licensePlate,
                   innerCleanliness: InnerCleanliness(rawValue: car.innerCleanliness),
                   color: CarColor(rawValue: car.color),
                   make: car.make,
                   modelName: car.modelName)
    }
}
