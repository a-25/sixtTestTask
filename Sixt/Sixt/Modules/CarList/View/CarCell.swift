import UIKit
import SnapKit
import Kingfisher

class CarCell: UITableViewCell {
    private let nameLabel = UILabel()
    private let productImage = UIImageView()
    private static let imageWidth = CGFloat(64)
    // Here could be used some library that generates image and localize paths: R.Swift, SwiftGen, etc.
    // Assume that in real project it will be present or I will propose to use it.
    // Here just hardcode the image path.
    private static let defaultImage = UIImage(named: "default")
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ model: Car,
                   imageLoader: ImageLoaderService) {
//        nameLabel.text = model.name
//        nameLabel.textColor = .black
//        if let imageUrl = model.imageUrl,
//           let url = URL(string: imageUrl) {
//            imageLoader.load(url: url,
//                             imageView: productImage,
//                             placeholder: Self.defaultImage,
//                             resizeTo: CGSize(width: Self.imageWidth, height: Self.imageWidth))
//        } else {
//            productImage.image = Self.defaultImage
//        }
    }
    
    private func setupUI() {
        productImage.contentMode = .scaleAspectFit
        productImage.image = Self.defaultImage
        contentView.addSubview(productImage)
        productImage.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview().inset(20)
            $0.height.equalTo(Self.imageWidth).priority(.high)
            $0.width.equalTo(Self.imageWidth)
        }
        
        nameLabel.font = .systemFont(ofSize: 14)
        nameLabel.numberOfLines = 2
        nameLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        nameLabel.textAlignment = .left
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(productImage.snp.trailing).offset(20)
            $0.centerY.equalToSuperview()
        }
    }
}
