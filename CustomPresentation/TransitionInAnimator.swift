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
    private var duration: Double!
    
    /// Optional
    private var delay: Double           = 0.0
    private var fromPosition: Position  = .Bottom
    private var useScale                = false
    private var fadeInAlpha             = false
    private var springDampening: CGFloat!
    private var springVelocity: CGFloat!
    
    //MARK: - Initialization
    
    private override init() {
        super.init()
    }
    
    required convenience init(
        withDuration time: Double,
        delay del: Double                   = 0.0,
        fromPosition position: Position     = .Bottom,
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
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return NSTimeInterval(duration)
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let presentedViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)! as UIViewController
        let presentedView = presentedViewController.view
        let containerView = transitionContext.containerView()
        
        let animationDuration = self .transitionDuration(transitionContext)
        
        let center = presentedView.center
        let destinationCenter = center
        
        if fromPosition != .Center {
            switch fromPosition {
            case .Top:
                presentedView.center = CGPointMake(center.x, -presentedView.bounds.size.height)
            case .Bottom:
                presentedView.center = CGPointMake(center.x, +presentedView.bounds.size.height)
            case .Left:
                presentedView.center = CGPointMake(center.y, -presentedView.bounds.size.width)
            case .Right:
                presentedView.center = CGPointMake(center.y, +presentedView.bounds.size.width)
            default: /** Center */
                break
            }
        }
        
        if useScale {
            presentedView.transform = CGAffineTransformMakeScale(0.1, 0.1)
        }

        if fadeInAlpha {
            presentedView.alpha = 0.0
        }
        
        containerView!.addSubview(presentedView)
        
        UIView.animateWithDuration(
            animationDuration,
            delay: delay,
            usingSpringWithDamping: springDampening,
            initialSpringVelocity: springVelocity,
            options: [],
            animations: { () -> Void in
                presentedView.transform = CGAffineTransformIdentity
                presentedView.alpha     = 1.0
                presentedView.center    = destinationCenter
            }, completion: { (finished) -> Void in
                transitionContext.completeTransition(finished)
        })
    }
}
