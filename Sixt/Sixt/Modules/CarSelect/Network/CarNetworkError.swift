import Alamofire
enum CarNetworkError: Error {
    case carListUnknown
    case networkError(error: AFError)
}
