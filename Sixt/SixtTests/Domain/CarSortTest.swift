import XCTest
@testable import Sixt
import CoreLocation

class CarSortTest: XCTestCase {
    private var carSort: CarSort!
    
    override func setUpWithError() throws {
        carSort = CarSort()
    }
    
    func testSortedByRating() {
        let sortedIds = carSort.sorted(TestData.carList, by: .sortRating, currentLocation: nil).map{ $0.id }
        XCTAssertEqual(sortedIds, ["id1", "id2", "id3", "id4", "id5"])
    }
    
    func testSortedByDistance() {
        let sortedIds = carSort.sorted(TestData.carList, by: .sortDistance, currentLocation: nil).map{ $0.id }
        XCTAssertEqual(sortedIds, ["id1", "id2", "id3", "id4", "id5"])
    }
    
    func testSortedByDistanceLocation() {
        let myLocation = CLLocationCoordinate2D(latitude: 55.009988, longitude: 12.07324)
        let sortedIds = carSort.sorted(TestData.carList, by: .sortDistance, currentLocation: myLocation).map{ $0.id }
        XCTAssertEqual(sortedIds, ["id3", "id4", "id5", "id1", "id2"])
    }
    
    func testSortedByDistanceLocationFar() {
        let myLocation = CLLocationCoordinate2D(latitude: 56.009988, longitude: 46.073000)
        let sortedIds = carSort.sorted(TestData.carList, by: .sortDistance, currentLocation: myLocation).map{ $0.id }
        XCTAssertEqual(sortedIds, ["id1", "id2", "id3", "id4", "id5"])
    }
}
