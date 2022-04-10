import UIKit

class CarDetailsAnimator: NSObject {
    private var animatedTransitioning: UIPercentDrivenInteractiveTransition?
    let panGesture = UIPanGestureRecognizer()
    weak var view: UIView?
    var onClose: (() -> Void)?
    
    override init() {
        super.init()
        panGesture.addTarget(self, action: #selector(didPan(_:)))
//        panGesture.delegate = self
    }
    
    @objc private func didPan(_ sender: UIPanGestureRecognizer) {
        guard let view = view else {
            return
        }
        let progress = (sender.translation(in: view).y / view.bounds.height)
        
        switch sender.state {
        case .began:
            sender.setTranslation(.init(x: 0, y: 0), in: view)
            
        case .changed:
            if progress > 0 && animatedTransitioning == nil {
                animatedTransitioning = UIPercentDrivenInteractiveTransition()
                onClose?()
                return
            }
            
            animatedTransitioning?.update(progress)
            
        case .ended:
            if progress > 0.5 || sender.velocity(in: view).y > 500 {
                animatedTransitioning?.finish()
            } else {
                animatedTransitioning?.cancel()
            }
            animatedTransitioning = nil
            
        case .possible, .cancelled, .failed:
            break
        @unknown default:
            animatedTransitioning?.finish()
            animatedTransitioning = nil
        }
    }
}

//extension CarDetailsAnimator: UIGestureRecognizerDelegate {
//    public func gestureRecognizer(
//        _ gestureRecognizer: UIGestureRecognizer,
//        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
//    ) -> Bool {
//        return true
//    }
//}

extension CarDetailsAnimator: UIViewControllerTransitioningDelegate {
    public func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        return CarDetailsPresentationAnimator()
    }
    
    public func animationController(
        forDismissed dismissed: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        guard dismissed == self else { return nil }
        return CarDetailsDismissalAnimator()
    }
    
    public func interactionControllerForDismissal(
        using animator: UIViewControllerAnimatedTransitioning
    ) -> UIViewControllerInteractiveTransitioning? {
        return animatedTransitioning
    }
}
