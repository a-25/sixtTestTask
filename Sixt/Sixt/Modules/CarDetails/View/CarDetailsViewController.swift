import UIKit
import SnapKit

class CarDetailsViewController: UIViewController {
    private let contentView = UIView()
    private let rentButton = UIButton()
    private let nameLabel = UILabel()
    private let transmissionLabel = UILabel()
    private let fuelTypeLabel = UILabel()
    private let carImage = UIImageView()
    private let fuelLevel = UIProgressView()
    private let cleaningLevel = UILabel()
    private let colorView = UIView()
    private let closeButton = UIButton()
    private let animator = CarDetailsAnimator()
    private let imageLoader: ImageLoaderService
    private let onClose: ((UIViewController) -> Void)?
    private static let imageWidth = CGFloat(200)
    private static let colorViewWidth = CGFloat(30)
    private var viewHeight: Constraint?
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
        view.backgroundColor = .clear
          
        contentView.backgroundColor = .white
        view.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.bottom.equalTo(view.snpSafeArea.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        carImage.contentMode = .scaleAspectFit
        carImage.image = ImageLoaderService.defaultImage
        contentView.addSubview(carImage)
        carImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.height.equalTo(Self.imageWidth)
            $0.width.equalTo(Self.imageWidth)
            $0.top.equalToSuperview().offset(20)
        }
        
        nameLabel.font = .systemFont(ofSize: 24)
        nameLabel.numberOfLines = 2
        nameLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        nameLabel.textAlignment = .left
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalTo(carImage.snp.bottom).offset(20)
        }
        
        colorView.layer.cornerRadius = Self.colorViewWidth / 2
        colorView.layer.borderColor = UIColor.black.cgColor
        colorView.layer.borderWidth = CGFloat(1)
        contentView.addSubview(colorView)
        colorView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.leading.greaterThanOrEqualTo(nameLabel.snp.trailing).offset(20)
            $0.top.equalTo(nameLabel)
            $0.height.width.equalTo(Self.colorViewWidth)
        }
        
        transmissionLabel.font = .systemFont(ofSize: 14)
        transmissionLabel.textAlignment = .left
        contentView.addSubview(transmissionLabel)
        transmissionLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalTo(nameLabel)
        }
        
        fuelTypeLabel.font = .systemFont(ofSize: 14)
        fuelTypeLabel.textAlignment = .left
        contentView.addSubview(fuelTypeLabel)
        fuelTypeLabel.snp.makeConstraints {
            $0.top.equalTo(transmissionLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalTo(nameLabel)
        }

        fuelLevel.progressTintColor = .blue
        contentView.addSubview(fuelLevel)
        fuelLevel.snp.makeConstraints {
            $0.top.equalTo(fuelTypeLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalTo(nameLabel)
        }
        
        cleaningLevel.font = .systemFont(ofSize: 14)
        cleaningLevel.textAlignment = .left
        contentView.addSubview(cleaningLevel)
        cleaningLevel.snp.makeConstraints {
            $0.top.equalTo(fuelLevel.snp.bottom).offset(8)
            $0.leading.equalTo(nameLabel)
        }
        
        rentButton.titleLabel?.font = .systemFont(ofSize: 24)
        rentButton.backgroundColor = .gray
        rentButton.setTitleColor(.black, for: .normal)
        rentButton.setTitle("Rent a car", for: .normal)
        rentButton.addTarget(self, action: #selector(onRentButtonTapped), for: .touchUpInside)
        contentView.addSubview(rentButton)
        rentButton.snp.makeConstraints {
            $0.top.equalTo(cleaningLevel.snp.bottom).offset(20)
            $0.leading.trailing.bottom.equalToSuperview().inset(20)
            $0.height.equalTo(64)
            $0.bottom.equalToSuperview().inset(40)
        }
        
        closeButton.setImage(UIImage(named: "cross"), for: .normal)
        closeButton.addTarget(self, action: #selector(onCloseButtonTapped), for: .touchUpInside)
        contentView.addSubview(closeButton)
        closeButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
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
        colorView.backgroundColor = color(for: car.color)
    }
    
    private func color(for carColor: CarColor?) -> UIColor {
        switch carColor {
        case .none:
            return .clear
        case .some(.icedChocolate):
            return .brown
        case .some(.midnightBlack):
            return .black
        case .some(.hotChocolate):
            return .brown
        case .some(.midnightBlackMetal):
            return .darkGray
        case .some(.lightWhite):
            return .white
        case .some(.alpinweiss):
            return .white
        case .some(.saphirschwarz):
            return .black
        case .some(.schwarz):
            return .black
        case .some(.absoluteBlackMetal):
            return .darkGray
        }
    }
}
