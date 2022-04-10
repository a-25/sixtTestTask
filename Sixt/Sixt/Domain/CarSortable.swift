import CoreLocation
protocol CarSortable {
    func sorted(
        _ carList: [Car],
        by sort: CartSortOperation,
        currentLocation: CLLocationCoordinate2D?
    ) -> [Car]
}
