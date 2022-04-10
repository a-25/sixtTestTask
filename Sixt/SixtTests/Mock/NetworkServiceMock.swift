@testable import Sixt
import Foundation

class NetworkServiceMock: CarListable {
    private let result: Result<[Car], Error>
    private(set) var numberOfRequests = 0
    
    init(result: Result<[Car], Error>) {
        self.result = result
    }
    
    func loadCarList(_ completion: @escaping (Result<[Car], Error>) -> Void) {
        numberOfRequests += 1
        DispatchQueue.main.async {
            completion(self.result)
        }
    }
}
