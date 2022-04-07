import UIKit
import SnapKit

private enum CarTabIndex: Int {
    case list = 0
    case map = 1
    
    static let defaultIndex = CarTabIndex.list
}

class CarSelectViewController: UIViewController {
    private let segmentedControl = UISegmentedControl(items: ["List", "Map"])
    private let contentView = UIView(frame: .zero)

    private var listController: UIViewController
    private var mapController: UIViewController
//    private let carDatasource: CarDatasourceable
    private var selectedController: UIViewController?
    
    init(
        listController: UIViewController,
        mapController: UIViewController/*,
        carDatasource: CarDatasourceable*/
    ) {
        self.listController = listController
        self.mapController = mapController
//        self.carDatasource = carDatasource
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Select a car"
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(segmentedControl)
        segmentedControl.snp.makeConstraints {
            $0.top.equalTo(view.snpSafeArea.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(44)
        }
        
        view.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.snpSafeArea.bottom)
        }
        
        segmentedControl.addTarget(self, action: #selector(switchTabs(_:)), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = CarTabIndex.defaultIndex.rawValue
        displayCurrentTab(CarTabIndex.defaultIndex)
    }
    
    private func displayCurrentTab(_ index: CarTabIndex){
        let controller = controller(for: index)
        addChild(controller)
        controller.didMove(toParent: self)
        
        controller.view.frame = contentView.bounds
        contentView.addSubview(controller.view)
        controller.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        selectedController = controller
    }
    
    private func controller(for index: CarTabIndex) -> UIViewController {
        switch index {
        case .list:
            return listController
        case .map:
            return mapController
        }
    }
    
    @objc private func switchTabs(_ sender: UISegmentedControl) {
        selectedController?.view.removeFromSuperview()
        selectedController?.removeFromParent()
        displayCurrentTab(CarTabIndex(rawValue: sender.selectedSegmentIndex) ?? CarTabIndex.defaultIndex)
    }
}
