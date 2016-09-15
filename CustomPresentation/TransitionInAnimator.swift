//
//  TransitionInAnimator.swift
//  Custom Presentation
//
//  Created by Dylan Edwards on 7/11/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

final class TransitionInAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    /** 
     Making default behavior in from bottom, with no bounce
     **/
    
    /// Required
    fileprivate var duration: Double!
    
    /// Optional
    fileprivate var delay: Double           = 0.0
    fileprivate var fromPosition: Position  = .bottom
    fileprivate var useScale                = false
    fileprivate var fadeInAlpha             = false
    fileprivate var springDampening: CGFloat!
    fileprivate var springVelocity: CGFloat!
    
    //MARK: - Initialization
    
    fileprivate override init() {
        super.init()
    }
    
    required convenience init(
        withDuration time: Double,
        delay del: Double                   = 0.0,
        fromPosition position: Position     = .bottom,
        useScale scale: Bool                = false,
        cornerRadius corners: CGFloat       = 0.0,
        shadowColor shadow: UIColor?        = nil,
        fadeInAlpha alpha: Bool             = false,
        springDampening dampening: CGFloat  = 1.0,
        springVelocity velocity: CGFloat    = 0.0) {
        
        self.init()
        
        duration        = time
        delay           = del
        fromPosition    = position
        useScale        = scale
        fadeInAlpha     = alpha
        springDampening = dampening
        springVelocity  = velocity
    }
    
    //MARK: - 
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TimeInterval(duration)
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let presentedViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)! as UIViewController
        guard let presentedView = presentedViewController.view else { return }
        let containerView = transitionContext.containerView
        
        let animationDuration = self .transitionDuration(using: transitionContext)
        
        let center = presentedView.center
        let destinationCenter = center
        
        if fromPosition != .center {
            switch fromPosition {
            case .top:
                presentedView.center = CGPoint(x: center.x, y: -presentedView.bounds.size.height)
            case .bottom:
                presentedView.center = CGPoint(x: center.x, y: +presentedView.bounds.size.height)
            case .left:
                presentedView.center = CGPoint(x: center.y, y: -presentedView.bounds.size.width)
            case .right:
                presentedView.center = CGPoint(x: center.y, y: +presentedView.bounds.size.width)
            default: /** Center */
                break
            }
        }
        
        if useScale {
            presentedView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }

        if fadeInAlpha {
            presentedView.alpha = 0.0
        }
        
        containerView.addSubview(presentedView)
        
        UIView.animate(
            withDuration: animationDuration,
            delay: delay,
            usingSpringWithDamping: springDampening,
            initialSpringVelocity: springVelocity,
            options: [],
            animations: { () -> Void in
                presentedView.transform = CGAffineTransform.identity
                presentedView.alpha     = 1.0
                presentedView.center    = destinationCenter
            }, completion: { (finished) -> Void in
                transitionContext.completeTransition(finished)
        })
    }
}
