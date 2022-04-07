import UIKit
import SnapKit
import Foundation
import ProgressHUD

class CarListViewController: UIViewController {
    private let carDatasource: CarDatasourceable
    private let tableView = UITableView()
    private static let cellIdentifier = "CarCell"
    private let errorMessageService: CarErrorable
    private let imageLoader: ImageLoaderService
    private var lastErrorMessage: String?
    
    init(
        carDatasource: CarDatasourceable,
        errorMessageService: CarErrorable,
        imageLoader: ImageLoaderService
    ) {
        self.carDatasource = carDatasource
        self.errorMessageService = errorMessageService
        self.imageLoader = imageLoader
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
        title = "Product list"
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
        
        carDatasource.loadCars(shouldIgnoreCache: shouldIgnoreCache) { [weak self] result in
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
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return lastErrorMessage != nil ? 64 : 0
    }
}

extension CarListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}
