import XCTest
@testable import Sixt

class CartRepositoryTest: XCTestCase {
    private var carRepository: CarRepository!
    
    override func setUpWithError() throws {
        
    }

    func testLoadCars() throws {
        let networkService = NetworkServiceMock(result: .success(TestData.carList))
        let carSort = CarSortMock(defaultCarList: TestData.carList)
        carRepository = CarRepository(networkService: networkService, sortService: carSort)
        let expectation = XCTestExpectation(description: "CartRepositoryTest.testLoadCars")
        carRepository.loadCars(shouldIgnoreCache: false,
                               currentLocation: nil) { result in
            switch result {
            case .success:
                XCTAssertEqual(self.carRepository.cars, TestData.carList)
                expectation.fulfill()
            case .failure:
                break
            }
        }
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testLoadCarsError() throws {
        let networkService = NetworkServiceMock(result: .failure(CarNetworkError.carListUnknown))
        let carSort = CarSortMock(defaultCarList: TestData.carList)
        carRepository = CarRepository(networkService: networkService, sortService: carSort)
        let expectation = XCTestExpectation(description: "CartRepositoryTest.testLoadCarsError")
        carRepository.loadCars(shouldIgnoreCache: false,
                               currentLocation: nil) { result in
            switch result {
            case .success:
                break
            case .failure:
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testLoadCarsRepeatedly() throws {
        let networkService = NetworkServiceMock(result: .success(TestData.carList))
        let carSort = CarSortMock(defaultCarList: TestData.carList)
        carRepository = CarRepository(networkService: networkService, sortService: carSort)
        let expectation = XCTestExpectation(description: "CartRepositoryTest.testLoadCarsRepeatedly")
        carRepository.loadCars(shouldIgnoreCache: false,
                               currentLocation: nil) { _ in
            for _ in 0...5 {
                self.carRepository.loadCars(shouldIgnoreCache: false,
                                            currentLocation: nil) { _ in}
            }
            XCTAssertEqual(networkService.numberOfRequests, 1)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testCarCount() throws {
        let networkService = NetworkServiceMock(result: .success(TestData.carList))
        let carSort = CarSortMock(defaultCarList: TestData.carList)
        carRepository = CarRepository(networkService: networkService, sortService: carSort)
        let expectation = XCTestExpectation(description: "CartRepositoryTest.testCarCount")
        carRepository.loadCars(shouldIgnoreCache: false,
                               currentLocation: nil) { _ in
            XCTAssertEqual(self.carRepository.carCount(), 5)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testCarCountEmpty() throws {
        let networkService = NetworkServiceMock(result: .success(TestData.carList))
        let carSort = CarSortMock(defaultCarList: TestData.carList)
        carRepository = CarRepository(networkService: networkService, sortService: carSort)
        XCTAssertEqual(self.carRepository.carCount(), 0)
    }
    
    func testCarForIndex() throws {
        let networkService = NetworkServiceMock(result: .success(TestData.carList))
        let carSort = CarSortMock(defaultCarList: TestData.carList)
        carRepository = CarRepository(networkService: networkService, sortService: carSort)
        let expectation = XCTestExpectation(description: "CartRepositoryTest.testCarForIndex")
        carRepository.loadCars(shouldIgnoreCache: false,
                               currentLocation: nil) { _ in
            XCTAssertEqual(self.carRepository.car(for: 2), TestData.carList[2])
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testCarForIndexWrong() throws {
        let networkService = NetworkServiceMock(result: .success(TestData.carList))
        let carSort = CarSortMock(defaultCarList: TestData.carList)
        carRepository = CarRepository(networkService: networkService, sortService: carSort)
        let expectation = XCTestExpectation(description: "CartRepositoryTest.testCarForIndexWrong")
        carRepository.loadCars(shouldIgnoreCache: false,
                               currentLocation: nil) { _ in
            XCTAssertNil(self.carRepository.car(for: 6))
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testSortSet() throws {
        let networkService = NetworkServiceMock(result: .success(TestData.carList))
        let ratingSorted = TestData.carList
        let distanceSorted = Array(TestData.carList.reversed())
        let carSort = CarSortMock(
            defaultCarList: [],
            sortedCars: [
                CartSortOperation.sortRating: ratingSorted,
                CartSortOperation.sortDistance: distanceSorted,
            ]
        )
        carRepository = CarRepository(networkService: networkService, sortService: carSort)
        let expectation = XCTestExpectation(description: "CartRepositoryTest.testSortSet")
        carRepository.loadCars(shouldIgnoreCache: false,
                               currentLocation: nil) { result in
            switch result {
            case .success:
                XCTAssertEqual(self.carRepository.cars, ratingSorted)
                self.carRepository.sort = .sortDistance
                XCTAssertEqual(self.carRepository.cars, distanceSorted)
                expectation.fulfill()
            case .failure:
                break
            }
        }
        wait(for: [expectation], timeout: 3.0)
    }
}
