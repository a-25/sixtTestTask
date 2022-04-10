import UIKit
import SnapKit

class CarDetailsView: UIView {
    private let rentButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    private func setupUI() {
        rentButton.titleLabel?.font = .systemFont(ofSize: 12)
        rentButton.setTitleColor(.black, for: .normal)
        rentButton.setTitle("Rent a car", for: .normal)
        addSubview(rentButton)
        rentButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.trailing.bottom.equalToSuperview().inset(20)
            $0.height.equalTo(44)
        }
    }
    
    func configure(with model: Car) {
        
    }
}
