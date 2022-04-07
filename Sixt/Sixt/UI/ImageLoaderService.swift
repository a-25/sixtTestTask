import UIKit
import Kingfisher

class ImageLoaderService {
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
