import UIKit
import SnapKit

class EmptyListView: UIView {
    private let emptyLabel = UILabel()
    private let message: String
    
    init(frame: CGRect, message: String) {
        self.message = message
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        emptyLabel.textColor = .black
        emptyLabel.textAlignment = .center
        emptyLabel.numberOfLines = 0
        emptyLabel.text = message
        addSubview(emptyLabel)
        emptyLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
}

