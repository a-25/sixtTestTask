import UIKit

class CarDetailsPresentationAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    public func transitionDuration(
        using transitionContext: UIViewControllerContextTransitioning?
    ) -> TimeInterval {
        return 0.4
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let presentedView = transitionContext.view(forKey: .to) else {
            transitionContext.completeTransition(false)
            return
        }
        let container = transitionContext.containerView
        container.backgroundColor = .black.withAlphaComponent(0.0)
        
        presentedView.frame.origin.y = container.bounds.maxY
        presentedView.clipsToBounds = true
        if #available(iOS 11, *) {
            presentedView.layer.maskedCorners = [
                .layerMinXMinYCorner,
                .layerMaxXMinYCorner,
            ]
        }
        presentedView.layer.cornerRadius = 22
        container.addSubview(presentedView)
        let animationOptions = UIView.AnimationOptions.curveEaseOut
        let options = UIView.KeyframeAnimationOptions(rawValue: animationOptions.rawValue)
        UIView.animateKeyframes(
            withDuration: transitionDuration(using: transitionContext),
            delay: 0,
            options: [options],
            animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.9) {
                    presentedView.frame.origin.y = 0
                    container.backgroundColor = .black.withAlphaComponent(0.4)
                }
                UIView.addKeyframe(withRelativeStartTime: 0.9, relativeDuration: 0.1) {
                    presentedView.layer.cornerRadius = 0
                }
            },
            completion: { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        )
    }
}


