import XCTest
@testable import Sixt
import CoreLocation

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

class CarMKAnnotationTest: XCTestCase {
    func testCoordinate() {
        let coords = TestData.carList.map{ $0.coordinate }
        let resultCoords: [CLLocationCoordinate2D] = [
            CLLocationCoordinate2D(latitude: 55.009988, longitude: 12.07324),
            CLLocationCoordinate2D(latitude: 55.009788, longitude: 12.07824),
            CLLocationCoordinate2D(latitude: 55.04988, longitude: 11.01393),
            CLLocationCoordinate2D(latitude: 55.04988, longitude: 11.01393),
        ]
        XCTAssertEqual(coords, resultCoords)
    }
    
    func testTitle() {
        let titles = TestData.carList.map{ $0.title }
        let resultTitles = [
            "make1, modelName1",
            "make2, modelName2",
            "make3, modelName3",
            "make4, modelName4",
        ]
        XCTAssertEqual(titles, resultTitles)
    }
    
    func testSubtitle() {
        let subtitles = TestData.carList.map{ $0.subtitle }
        let resultSubtitles = [
            "Transmission: M, fuel type: D, fuel level: 64%",
            "Transmission: A, fuel type: P, fuel level: 24%",
            "Transmission: A, fuel type: D, fuel level: 10%",
            "Transmission: A, fuel type: D, fuel level: 10%"
        ]
        XCTAssertEqual(subtitles, resultSubtitles)
    }
}
