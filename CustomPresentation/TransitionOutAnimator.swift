//
//  TransitionOutAnimator.swift
//  Custom Presentation
//
//  Created by Dylan Edwards on 7/11/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

final class TransitionOutAnimator : NSObject, UIViewControllerAnimatedTransitioning {
    
    fileprivate var duration: Double!
    fileprivate var delay: Double           = 0.0
    fileprivate var toPosition: Position    = .bottom
    fileprivate var useScale: Bool          = false
    fileprivate var fadeOutAlpha: Bool      = false
    
    //MARK: - Initialization
    
    fileprivate override init() {
        super.init()
    }
    
    required convenience init(
        withDuration time: Double,
        delay del: Double               = 0.0,
        toPosition position: Position   = .bottom,
        useScale scale: Bool            = false,
        fadeOutAlpha alpha: Bool        = false) {
        
        self.init()
        
        duration        = time
        delay           = del
        toPosition      = position
        useScale        = scale
        fadeOutAlpha    = alpha
    }
    
    //MARK: - 
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TimeInterval(duration)
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let presentedViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        
        let presentedView = presentedViewController.view
        let containerView = transitionContext.containerView
        
        let center = presentedView?.center
        var destinationCenter = center
        
        if toPosition != .center {
            switch toPosition {
            case .top:
                destinationCenter = CGPoint(x: (center?.x)!, y: (-containerView.bounds.size.height - (presentedView?.bounds.size.height)!))
            case .bottom:
                destinationCenter = CGPoint(x: (center?.x)!, y: (containerView.bounds.size.height + (presentedView?.bounds.size.height)!))
            case .left:
                destinationCenter = CGPoint(x: (center?.y)!, y: (-containerView.bounds.size.width - (presentedView?.bounds.size.width)!))
            case .right:
                destinationCenter = CGPoint(x: (center?.y)!, y: (containerView.bounds.size.width + (presentedView?.bounds.size.width)!))
            default: /** Center */
                break
            }
        }

        let animationDuration = self .transitionDuration(using: transitionContext)
        
        UIView.animate(
            withDuration: animationDuration,
            delay: delay,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 0.0,
            options: [],
            animations: { () -> Void in
            
            presentedView?.center = destinationCenter!
            
            if self.useScale {
                presentedView?.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            }
            if self.fadeOutAlpha {
                presentedView?.alpha = 0.0
            }
            
        }) { (finished) -> Void in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
