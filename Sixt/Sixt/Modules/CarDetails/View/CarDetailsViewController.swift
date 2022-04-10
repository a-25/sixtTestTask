import UIKit

class CarDetailsViewController: UIViewController {
    private let rentButton = UIButton()
    private let nameLabel = UILabel()
    private let transmissionLabel = UILabel()
    private let fuelTypeLabel = UILabel()
    private let carImage = UIImageView()
    private let fuelLevel = UIProgressView()
    private let cleaningLevel = UILabel()
    private let closeButton = UIButton()
    private let animator = CarDetailsAnimator()
    private let imageLoader: ImageLoaderService
    private let onClose: ((UIViewController) -> Void)?
    private static let imageWidth = CGFloat(200)
    private let car: Car
    
    init(
        imageLoader: ImageLoaderService,
        car: Car,
        onClose: ((UIViewController) -> Void)?
    ) {
        self.imageLoader = imageLoader
        self.onClose = onClose
        self.car = car
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setup(car: car)
        
        animator.view = self.view
        animator.onClose = { [weak self] in
            guard let self = self else {
                return
            }
            self.onClose?(self)
        }
        transitioningDelegate = animator
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        carImage.contentMode = .scaleAspectFit
        carImage.image = ImageLoaderService.defaultImage
        view.addSubview(carImage)
        carImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.height.equalTo(Self.imageWidth).priority(.high)
            $0.width.equalTo(Self.imageWidth)
            $0.top.equalTo(view.snpSafeArea.top).offset(20)
        }
        
        nameLabel.font = .systemFont(ofSize: 24)
        nameLabel.numberOfLines = 2
        nameLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        nameLabel.textAlignment = .left
        view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(carImage.snp.bottom).offset(20)
        }
        
        transmissionLabel.font = .systemFont(ofSize: 14)
        transmissionLabel.textAlignment = .left
        view.addSubview(transmissionLabel)
        transmissionLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalTo(nameLabel)
        }
        
        fuelTypeLabel.font = .systemFont(ofSize: 14)
        fuelTypeLabel.textAlignment = .left
        view.addSubview(fuelTypeLabel)
        fuelTypeLabel.snp.makeConstraints {
            $0.top.equalTo(transmissionLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalTo(nameLabel)
        }

        fuelLevel.progressTintColor = .blue
        view.addSubview(fuelLevel)
        fuelLevel.snp.makeConstraints {
            $0.top.equalTo(fuelTypeLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalTo(nameLabel)
        }
        
        cleaningLevel.font = .systemFont(ofSize: 14)
        cleaningLevel.textAlignment = .left
        view.addSubview(cleaningLevel)
        cleaningLevel.snp.makeConstraints {
            $0.top.equalTo(fuelLevel.snp.bottom).offset(8)
            $0.leading.equalTo(nameLabel)
        }
        
        rentButton.titleLabel?.font = .systemFont(ofSize: 24)
        rentButton.backgroundColor = .gray
        rentButton.setTitleColor(.black, for: .normal)
        rentButton.setTitle("Rent a car", for: .normal)
        rentButton.addTarget(self, action: #selector(onRentButtonTapped), for: .touchUpInside)
        view.addSubview(rentButton)
        rentButton.snp.makeConstraints {
            $0.top.equalTo(cleaningLevel.snp.bottom).offset(20)
            $0.leading.trailing.bottom.equalToSuperview().inset(20)
            $0.height.equalTo(64)
//            $0.bottom.lessThanOrEqualTo(view.snpSafeArea.bottom).inset(20)
        }
        
        closeButton.setImage(UIImage(named: "cross"), for: .normal)
        closeButton.addTarget(self, action: #selector(onCloseButtonTapped), for: .touchUpInside)
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints {
            $0.top.equalTo(view.snpSafeArea.top).offset(20)
            $0.trailing.equalToSuperview().inset(20)
            $0.width.equalTo(36)
            $0.height.equalTo(31)
        }
        
        view.addGestureRecognizer(animator.panGesture)
    }
    
    @objc private func onRentButtonTapped() {
        let alert = UIAlertController(title: "Rent a car", message: "This function is unavailable in the test task. Hire me to complete it!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func onCloseButtonTapped() {
        onClose?(self)
    }
    
    private func setup(car: Car) {
        nameLabel.text = "\(car.make), \(car.modelName)"
        fuelLevel.setProgress(Float(car.fuelLevel), animated: false)
        let cleaningState: String
        switch car.innerCleanliness {
        case .regular:
            cleaningState = "+"
        case .clean:
            cleaningState = "++"
        case .veryClean:
            cleaningState = "+++"
        case .none:
            cleaningState = "?"
        }
        cleaningLevel.text = "Clean: \(cleaningState)"
        let transmissionDesc: String
        switch car.transmission {
        case let .exact(transmission):
            transmissionDesc = transmission.rawValue
        case let .custom(transmission):
            transmissionDesc = transmission
        }
        transmissionLabel.text = "Transmission: \(transmissionDesc)"
        if let fuelType = car.fuelType {
            fuelTypeLabel.text = "Fuel type: \(fuelType.rawValue)"
        }
        if let imageUrl = car.carImageUrl,
           let url = URL(string: imageUrl) {
            imageLoader.load(url: url,
                             imageView: carImage,
                             placeholder: ImageLoaderService.defaultImage,
                             resizeTo: CGSize(width: Self.imageWidth, height: Self.imageWidth))
        } else {
            carImage.image = ImageLoaderService.defaultImage
        }
    }
}
