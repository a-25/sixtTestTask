import UIKit
import SnapKit
import Foundation
import ProgressHUD

class CarListViewController: UIViewController {
    private var carDatasource: CarDatasourceable
    private let tableView = UITableView()
    private static let cellIdentifier = "CarCell"
    private let errorMessageService: CarErrorable
    private let imageLoader: ImageLoaderService
    private let locationService: LocationService
    private var lastErrorMessage: String?
    var onCarSelected: ((Car) -> Void)?
    
    init(
        carDatasource: CarDatasourceable,
        errorMessageService: CarErrorable,
        imageLoader: ImageLoaderService,
        locationService: LocationService
    ) {
        self.carDatasource = carDatasource
        self.errorMessageService = errorMessageService
        self.imageLoader = imageLoader
        self.locationService = locationService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        refreshCars()
    }
    
    private func reloadTable() {
        tableView.reloadData()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        title = "Car list"
        tableView.register(CarCell.self, forCellReuseIdentifier: Self.cellIdentifier)
        addPullToRefresh()
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.snpSafeArea.top)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.snpSafeArea.bottom)
        }
    }
    
    private func addPullToRefresh() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(
            self,
            action: #selector(didRequestCarsRefresh),
            for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    @objc private func didRequestCarsRefresh() {
        refreshCars(shouldIgnoreCache: true)
        tableView.refreshControl?.endRefreshing()
    }
    
    private func refreshCars(shouldIgnoreCache: Bool = false) {
        ProgressHUD.show()
        
        carDatasource.loadCars(shouldIgnoreCache: shouldIgnoreCache,
                               currentLocation: locationService.cachedLocation?.coordinate) { [weak self] result in
            defer { ProgressHUD.dismiss() }
            guard let self = self else {
                return
            }
            switch result {
            case .success:
                self.lastErrorMessage = self.carDatasource.carCount() > 0 ? nil : "There are no cars here"
            case let .failure(error):
                self.lastErrorMessage = self.errorMessageService.getCarMessage(for: error)
            }
            self.reloadTable()
        }
    }
}

extension CarListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return carDatasource.carCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Self.cellIdentifier) as? CarCell,
              let model = carDatasource.car(for: indexPath.row) else {
                  return UITableViewCell(style: .subtitle, reuseIdentifier: Self.cellIdentifier)
              }
        
        cell.configure(model,
                       imageLoader: imageLoader)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let message = lastErrorMessage {
            return EmptyListView(frame: .zero, message: message)
        }
        guard section == 0 else {
            return nil
        }
        return CarListSortView(activeOperation: carDatasource.sort) { [weak self] operation in
            self?.carDatasource.sort = operation
            self?.reloadTable()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 64 : 0
    }
}

extension CarListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let car = carDatasource.car(for: indexPath.row) {
            onCarSelected?(car)
        }
    }
}
