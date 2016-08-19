//
//  OverlayTransitioningDelegate.swift
//  Custom Presentation
//
//  Created by Dylan Edwards on 7/11/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

enum Position {
    case Top, Bottom, Left, Right, Center
}

/// Dictionary Keys
enum TransitionOption {
    case AlphaIn            /// Bool
    case AlphaOut           /// Bool
    case DelayIn            /// Double
    case DelayOut           /// Double
    case DimmingBGColor     /// UIColor
    case DurationIn         /// Double
    case DurationOut        /// Double
    case InFromPosition     /// Position
    case OutToPosition      /// Position
    case ScaleIn            /// Bool
    case ScaleOut           /// Bool
    case SpringDampening    /// CGFloat
    case SpringVelocity     /// CGFloat
    case TapToDismiss       /// Bool
}


final class OverlayTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    private var options: [TransitionOption : Any]?
    
    /** OverlayPresentationController **/
    private var preferredContentSize: CGSize!
    private var dimmingBGColor              = UIColor(white: 0.0, alpha: 0.5)
    private var tapToDismiss                = false
    private var dismissalCompletion: (() -> Void)?
    
    /** TransitionInAnimator **/
    private var durationIn: Double          = 0.5
    private var delayIn: Double             = 0.0
    private var fromPosition: Position      = .Bottom
    private var useScaleIn                  = false
    private var fadeInAlpha                 = false
    private var springDampening: CGFloat    = 1.0
    private var springVelocity: CGFloat     = 0.0
    
    /** TransitionOutAnimator **/
    private var durationOut: Double         = 0.5
    private var delayOut: Double            = 0.0
    private var outToPosition: Position     = .Bottom
    private var useScaleOut: Bool           = false
    private var fadeOutAlpha: Bool          = false
    
    internal func configureTransitionWithContentSize(contentSize: CGSize, options opts: [TransitionOption : Any]? = nil, dismissalCompletion outComplete: (() -> Void)? = nil) {

        preferredContentSize    = contentSize
        dismissalCompletion     = outComplete
        options = opts
        
        checkForOptions()
    }

    private func checkForOptions() {
        guard let options = options else { return }
        
        /** OverlayPresentationController **/
        
        if let bgDimming = options[.DimmingBGColor] as? UIColor {
            dimmingBGColor = bgDimming
        }
        if let tapDissmiss = options[.TapToDismiss] as? Bool {
            tapToDismiss = tapDissmiss
        }
        
        /** TransitionInAnimator **/
        
        if let timeIn = options[.DurationIn] as? Double {
            durationIn = timeIn
        }
        if let pauseIn = options[.DelayIn] as? Double {
            delayIn = pauseIn
        }
        if let inFrom = options[.InFromPosition] as? Position {
            fromPosition = inFrom
        }
        if let scaleIn = options[.ScaleIn] as? Bool {
            useScaleIn = scaleIn
        }
        if let alphaIn = options[.AlphaIn] as? Bool {
            fadeInAlpha = alphaIn
        }
        if let dampening = options[.SpringDampening] as? CGFloat {
            springDampening = dampening
        }
        if let velocity = options[.SpringVelocity] as? CGFloat {
            springVelocity = velocity
        }
        
        /** TransitionOutAnimator **/
        
        if let timeOut = options[.DurationOut] as? Double {
            durationIn = timeOut
        }
        if let pauseOut = options[.DelayOut] as? Double {
            delayOut = pauseOut
        }
        if let outTo = options[.OutToPosition] as? Position {
            outToPosition = outTo
        }
        if let scaleOut = options[.ScaleOut] as? Bool {
            useScaleOut = scaleOut
        }
        if let alphaOut = options[.AlphaOut] as? Bool {
            fadeOutAlpha = alphaOut
        }
    }
    
    func presentationControllerForPresentedViewController(
        presented: UIViewController,
        presentingViewController presenting: UIViewController,
        sourceViewController source: UIViewController) -> UIPresentationController? {
        
        return OverlayPresentationController(
            presentedViewController: presented,
            presentingViewController: presenting,
            preferredContentSize: preferredContentSize,
            dimmingBGColor: dimmingBGColor,
            tapToDismiss: tapToDismiss,
            dismissalCompletion: dismissalCompletion)
    }
  
    func animationControllerForPresentedController(
        presented: UIViewController,
        presentingController presenting: UIViewController,
        sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return TransitionInAnimator(
            withDuration: durationIn,
            fromPosition: fromPosition,
            useScale: useScaleIn,
            fadeInAlpha: fadeInAlpha,
            springDampening: springDampening,
            springVelocity: springVelocity)
    }
  
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return TransitionOutAnimator(
            withDuration: durationOut,
            toPosition: outToPosition,
            useScale: useScaleOut,
            fadeOutAlpha: fadeOutAlpha)
    }
}
