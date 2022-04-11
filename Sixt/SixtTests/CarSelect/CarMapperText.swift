import XCTest
@testable import Sixt

class CarMapperTest: XCTestCase {
    private var mapper: CarMapper!

    override func setUpWithError() throws {
        mapper = CarMapper()
    }

    func testMap() throws {
        let carModels = [
            CarNetwork(id: "id1",
                       name: "name1",
                       carImageUrl: nil,
                       latitude: 55.009988,
                       longitude: 12.07324,
                       transmission: "M",
                       fuelType: "D",
                       fuelLevel: 0.64,
                       licensePlate: "licensePlate1",
                       innerCleanliness: "REGULAR",
                       color: "absolute_black_metal",
                       make: "make1",
                       modelName: "modelName1"),
            CarNetwork(id: "id2",
                       name: "name2",
                       carImageUrl: "https://cdn.sixt.io/codingtask/images/mini.png",
                       latitude: 55.009788,
                       longitude: 12.07824,
                       transmission: "A",
                       fuelType: "P",
                       fuelLevel: 0.24,
                       licensePlate: "licensePlate2",
                       innerCleanliness: "CLEAN",
                       color: "absolute_black_metal",
                       make: "make2",
                       modelName: "modelName2"),
            CarNetwork(id: "id3",
                       name: "name3",
                       carImageUrl: "https://cdn.sixt.io/codingtask/images/bmw_1er.png", latitude: 55.04988,
                       longitude: 11.01393,
                       transmission: "A",
                       fuelType: "D",
                       fuelLevel: 0.1,
                       licensePlate: "licensePlate3",
                       innerCleanliness: "VERY_CLEAN",
                       color: "iced_chocolate",
                       make: "make3",
                       modelName: "modelName3"),
            CarNetwork(id: "id4",
                       name: "name4",
                       carImageUrl: "https://cdn.sixt.io/codingtask/images/bmw_1er.png",
                       latitude: 55.04988,
                       longitude: 11.01393,
                       transmission: "A",
                       fuelType: "D",
                       fuelLevel: 0.1,
                       licensePlate: "licensePlate4",
                       innerCleanliness: "SomeInnerCleanliness",
                       color: "iced_chocolate",
                       make: "make4",
                       modelName: "modelName4"),
            CarNetwork(id: "id5",
                       name: "name5",
                       carImageUrl: "https://cdn.sixt.io/codingtask/images/bmw_1er.png",
                       latitude: 55.04988,
                       longitude: 11.01393,
                       transmission: "NewTransmission",
                       fuelType: "D",
                       fuelLevel: 0.1,
                       licensePlate: "licensePlate5",
                       innerCleanliness: "SomeInnerCleanliness",
                       color: "iced_chocolate",
                       make: "make5",
                       modelName: "modelName5")
        ]
        XCTAssertEqual(carModels.map { mapper.map($0) }, TestData.carList)
    }
}
