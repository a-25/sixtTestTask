@testable import Sixt
class TestData {
    static let carList: [Car] = [
        Car(id: "id1",
            name: "name1",
            latitude: 55.009988,
            longitude: 12.07324,
            carImageUrl: nil,
            transmission: .exact(.m),
            fuelType: .diesel,
            fuelLevel: 0.64,
            licensePlate: "licensePlate1",
            innerCleanliness: .regular,
            color: .absoluteBlackMetal,
            make: "make1",
            modelName: "modelName1"),
        Car(id: "id2",
            name: "name2",
            latitude: 55.009788,
            longitude: 12.07824,
            carImageUrl: "https://cdn.sixt.io/codingtask/images/mini.png",
            transmission: .exact(.a),
            fuelType: .petrol,
            fuelLevel: 0.24,
            licensePlate: "licensePlate2",
            innerCleanliness: .clean,
            color: .absoluteBlackMetal,
            make: "make2",
            modelName: "modelName2"),
        Car(id: "id3",
            name: "name3",
            latitude: 55.04988,
            longitude: 11.01393,
            carImageUrl: "https://cdn.sixt.io/codingtask/images/bmw_1er.png",
            transmission: .exact(.a),
            fuelType: .diesel,
            fuelLevel: 0.1,
            licensePlate: "licensePlate3",
            innerCleanliness: .veryClean,
            color: .icedChocolate,
            make: "make3",
            modelName: "modelName3"),
        Car(id: "id4",
            name: "name4",
            latitude: 55.04988,
            longitude: 11.01393,
            carImageUrl: "https://cdn.sixt.io/codingtask/images/bmw_1er.png",
            transmission: .exact(.a),
            fuelType: .diesel,
            fuelLevel: 0.1,
            licensePlate: "licensePlate4",
            innerCleanliness: nil,
            color: .icedChocolate,
            make: "make4",
            modelName: "modelName4"),
    ]
}
