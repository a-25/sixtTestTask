import UIKit
import SnapKit

class CarListSortView: UIView {
    private let buttonsList = UIStackView()
    private let ratingSortButton = UIButton()
    private let distanceSortButton = UIButton()
    private let handler: (CartSortOperation) -> Void
    
    init(activeOperation: CartSortOperation?,
         handler: @escaping (CartSortOperation) -> Void) {
        self.handler = handler
        super.init(frame: .zero)
        setupUI(activeOperation)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(_ activeOperation: CartSortOperation?) {
        buttonsList.axis = .horizontal
        buttonsList.distribution = .fillEqually
        buttonsList.spacing = 10
        addSubview(buttonsList)
        buttonsList.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        configureButton(ratingSortButton,
                        title: "Sort by rating",
                        action: #selector(onRatingSort))
        configureButton(distanceSortButton,
                        title: "Sort by distance",
                        action: #selector(onDistanceSort))
        
        let button: UIButton?
        switch activeOperation {
        case .sortRating:
            button = ratingSortButton
        case .sortDistance:
            button = distanceSortButton
        case .none:
            button = nil
        }
        makeActive(button)
    }
    
    private func configureButton(_ button: UIButton, title: String, action: Selector) {
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 10)
        button.addTarget(self, action: action, for: .touchUpInside)
        buttonsList.addArrangedSubview(button)
    }
    
    private func makeActive(_ button: UIButton?) {
        let allButtons = [
            ratingSortButton,
            distanceSortButton
        ]
        allButtons.forEach { $0.backgroundColor = .lightGray }
        button?.backgroundColor = .darkGray
    }
    
    @objc private func onRatingSort() {
        handler(.sortRating)
    }
    
    @objc private func onDistanceSort() {
        handler(.sortDistance)
    }
}

