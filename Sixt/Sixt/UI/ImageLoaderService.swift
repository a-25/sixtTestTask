import UIKit
import Kingfisher

class ImageLoaderService {
    // Here could be used some library that generates image and localize paths: R.Swift, SwiftGen, etc.
    // Assume that in real project it will be present or I will propose to use it.
    // Here just hardcode the image path.
    static let defaultImage = UIImage(named: "default")
    
    func load(url: URL,
              imageView: UIImageView,
              placeholder: UIImage?,
              resizeTo: CGSize?) {
        guard let resizeTo = resizeTo else {
            imageView.kf.setImage(with: url,
                                  placeholder: placeholder,
                                  options: [.cacheOriginalImage])
            return
        }
        let scale = UIScreen.main.scale
        let referenceSize = CGSize(width: resizeTo.width * scale,
                                   height: resizeTo.height * scale)
        let resizeProcessor = ResizingImageProcessor(referenceSize: referenceSize,
                                                     mode: .aspectFit)
        imageView.kf.setImage(with: url,
                              placeholder: placeholder,
                              options: [
                                .backgroundDecode,
                                .processor(resizeProcessor),
                                .scaleFactor(UIScreen.main.scale),
                                .cacheOriginalImage
                              ])
    }
}
