import UIKit
import SnapKit
import Kingfisher

class CarCell: UITableViewCell {
    private let nameLabel = UILabel()
    private let transmissionLabel = UILabel()
    private let fuelTypeLabel = UILabel()
    private let carImage = UIImageView()
    private let fuelLevel = UIProgressView()
    private static let imageWidth = CGFloat(64)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ model: Car,
                   imageLoader: ImageLoaderService) {
        nameLabel.text = "\(model.make), \(model.modelName)"
        fuelLevel.setProgress(Float(model.fuelLevel), animated: false)
        let transmissionDesc: String
        switch model.transmission {
        case let .exact(transmission):
            transmissionDesc = transmission.rawValue
        case let .custom(transmission):
            transmissionDesc = transmission
        }
        transmissionLabel.text = "Transmission: \(transmissionDesc)"
        if let fuelType = model.fuelType {
            fuelTypeLabel.text = "Fuel type: \(fuelType.rawValue)"
        }
        if let imageUrl = model.carImageUrl,
           let url = URL(string: imageUrl) {
            imageLoader.load(url: url,
                             imageView: carImage,
                             placeholder: ImageLoaderService.defaultImage,
                             resizeTo: CGSize(width: Self.imageWidth, height: Self.imageWidth))
        } else {
            carImage.image = ImageLoaderService.defaultImage
        }
    }
    
    private func setupUI() {
        carImage.contentMode = .scaleAspectFit
        carImage.image = ImageLoaderService.defaultImage
        contentView.addSubview(carImage)
        carImage.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.height.equalTo(Self.imageWidth).priority(.high)
            $0.width.equalTo(Self.imageWidth)
            $0.centerY.equalToSuperview()
        }
        
        nameLabel.font = .systemFont(ofSize: 14)
        nameLabel.numberOfLines = 2
        nameLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        nameLabel.textAlignment = .left
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(carImage.snp.trailing).offset(20)
            $0.trailing.equalToSuperview().inset(20)
            $0.top.equalToSuperview().offset(10)
        }
        
        transmissionLabel.font = .systemFont(ofSize: 10)
        transmissionLabel.textAlignment = .left
        contentView.addSubview(transmissionLabel)
        transmissionLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalTo(nameLabel)
        }
        
        fuelTypeLabel.font = .systemFont(ofSize: 10)
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
            $0.bottom.equalToSuperview().inset(20)
        }
    }
}
