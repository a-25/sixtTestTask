import UIKit

class CarDetailsViewController: UIViewController {
    private let rentButton = UIButton()
    private let animator = CarDetailsAnimator()
    private let onClose: ((UIViewController?) -> Void)?
    
    init(onClose: ((UIViewController?) -> Void)?) {
        self.onClose = onClose
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        animator.view = self.view
        animator.onClose = { [weak self] in
            self?.onClose?(self)
        }
        transitioningDelegate = animator
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        rentButton.titleLabel?.font = .systemFont(ofSize: 12)
        rentButton.setTitleColor(.black, for: .normal)
        rentButton.setTitle("Rent a car", for: .normal)
        rentButton.addTarget(self, action: #selector(onRentButtonTapped), for: .touchUpInside)
        view.addSubview(rentButton)
        rentButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.trailing.bottom.equalToSuperview().inset(20)
            $0.height.equalTo(44)
        }
        
        view.addGestureRecognizer(animator.panGesture)
    }
    
    @objc private func onRentButtonTapped() {
        let alert = UIAlertController(title: "Rent a car", message: "This function is unavailable in the test task. Hire me to complete it!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
