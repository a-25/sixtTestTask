import CoreLocation

public struct LocationError: Error {
    public let status: CLAuthorizationStatus
    public let error: Error
}
