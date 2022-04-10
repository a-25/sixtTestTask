import UIKit

class CarDetailsDismissalAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    public func transitionDuration(
        using transitionContext: UIViewControllerContextTransitioning?
    ) -> TimeInterval {
        return 0.4
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let dismissedView = transitionContext.view(forKey: .from) else {
            transitionContext.completeTransition(false)
            return
        }
        let container = transitionContext.containerView
        container.backgroundColor = .black.withAlphaComponent(0.4)
        dismissedView.clipsToBounds = true
        container.addSubview(dismissedView)
        UIView.animateKeyframes(
            withDuration: transitionDuration(using: transitionContext),
            delay: 0,
            options: [],
            animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.01) {
                    if #available(iOS 11, *) {
                        dismissedView.layer.maskedCorners = [
                            .layerMinXMinYCorner,
                            .layerMaxXMinYCorner,
                        ]
                    }
                    dismissedView.layer.cornerRadius = 22
                }
                UIView.addKeyframe(withRelativeStartTime: 0.01, relativeDuration: 0.99) {
                    dismissedView.frame.origin.y = container.bounds.maxY
                    container.backgroundColor = .black.withAlphaComponent(0)
                }
            },
            completion: { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        )
    }
}


