import Alamofire
class NetworkService {
    private let baseUrl: String
    private let carMapper: CarMapper
    private let queue: DispatchQueue
    
    init(baseUrl: String,
         carMapper: CarMapper) {
        self.baseUrl = baseUrl
        self.carMapper = carMapper
        self.queue = DispatchQueue(label: "NetworkServiceQueue")
    }
    
    private func wrapCompletion(_ completion: @escaping () -> Void) {
        DispatchQueue.main.async {
            completion()
        }
    }
}

extension NetworkService: CarListable {
    func loadCarList(_ completion: @escaping (Result<[Car], Error>) -> Void) {
        AF.request(
            "\(baseUrl)/codingtask/cars",
            method: .get
        )
        .validate()
        .responseDecodable(of: [CarNetwork].self,
                           queue: queue) { [weak self] (response) in
            if let afError = response.error {
                self?.wrapCompletion{ completion(.failure(CarNetworkError.networkError(error: afError))) }
                return
            }
            guard let self = self,
                  let carList = response.value else {
                self?.wrapCompletion { completion(.failure(CarNetworkError.carListUnknown)) }
                return
            }
            let models = carList.map { self.carMapper.map($0) }
            self.wrapCompletion{ completion(.success(/*models*/[])) }
        }
    }
}
