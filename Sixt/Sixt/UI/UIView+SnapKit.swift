import SnapKit
import UIKit

public extension UIView {
    var snpSafeArea: ConstraintBasicAttributesDSL {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.snp
        }
        return snp
    }
    
    var safeAreaInset: UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return self.safeAreaInsets
        }
        return UIEdgeInsets.zero
    }
}
