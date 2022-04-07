class CarMapper {
    func map(_ car: CarNetwork) -> Car {
        return Car(id: "",
                   name: car.name,
                   latitude: car.latitude,
                   longitude: car.longitude)
    }
}
