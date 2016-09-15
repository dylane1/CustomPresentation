//
//  OverlayTransitioningDelegate.swift
//  Custom Presentation
//
//  Created by Dylan Edwards on 7/11/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

enum Position {
    case top, bottom, left, right, center
}

/// Dictionary Keys
enum TransitionOption {
    case alphaIn            /// Bool
    case alphaOut           /// Bool
    case delayIn            /// Double
    case delayOut           /// Double
    case dimmingBGColor     /// UIColor
    case durationIn         /// Double
    case durationOut        /// Double
    case inFromPosition     /// Position
    case outToPosition      /// Position
    case scaleIn            /// Bool
    case scaleOut           /// Bool
    case springDampening    /// CGFloat
    case springVelocity     /// CGFloat
    case tapToDismiss       /// Bool
}


final public class OverlayTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    fileprivate var options: [TransitionOption : Any]?
    
    /** OverlayPresentationController **/
    fileprivate var preferredContentSize: CGSize!
    fileprivate var dimmingBGColor              = UIColor(white: 0.0, alpha: 0.5)
    fileprivate var tapToDismiss                = false
    fileprivate var dismissalCompletion: (() -> Void)?
    
    /** TransitionInAnimator **/
    fileprivate var durationIn: Double          = 0.5
    fileprivate var delayIn: Double             = 0.0
    fileprivate var fromPosition: Position      = .bottom
    fileprivate var useScaleIn                  = false
    fileprivate var fadeInAlpha                 = false
    fileprivate var springDampening: CGFloat    = 1.0
    fileprivate var springVelocity: CGFloat     = 0.0
    
    /** TransitionOutAnimator **/
    fileprivate var durationOut: Double         = 0.5
    fileprivate var delayOut: Double            = 0.0
    fileprivate var outToPosition: Position     = .bottom
    fileprivate var useScaleOut: Bool           = false
    fileprivate var fadeOutAlpha: Bool          = false
    
    internal func configureTransitionWithContentSize(_ contentSize: CGSize, options opts: [TransitionOption : Any]? = nil, dismissalCompletion outComplete: (() -> Void)? = nil) {

        preferredContentSize    = contentSize
        dismissalCompletion     = outComplete
        options = opts
        
        checkForOptions()
    }

    fileprivate func checkForOptions() {
        guard let options = options else { return }
        
        /** OverlayPresentationController **/
        
        if let bgDimming = options[.dimmingBGColor] as? UIColor {
            dimmingBGColor = bgDimming
        }
        if let tapDissmiss = options[.tapToDismiss] as? Bool {
            tapToDismiss = tapDissmiss
        }
        
        /** TransitionInAnimator **/
        
        if let timeIn = options[.durationIn] as? Double {
            durationIn = timeIn
        }
        if let pauseIn = options[.delayIn] as? Double {
            delayIn = pauseIn
        }
        if let inFrom = options[.inFromPosition] as? Position {
            fromPosition = inFrom
        }
        if let scaleIn = options[.scaleIn] as? Bool {
            useScaleIn = scaleIn
        }
        if let alphaIn = options[.alphaIn] as? Bool {
            fadeInAlpha = alphaIn
        }
        if let dampening = options[.springDampening] as? CGFloat {
            springDampening = dampening
        }
        if let velocity = options[.springVelocity] as? CGFloat {
            springVelocity = velocity
        }
        
        /** TransitionOutAnimator **/
        
        if let timeOut = options[.durationOut] as? Double {
            durationIn = timeOut
        }
        if let pauseOut = options[.delayOut] as? Double {
            delayOut = pauseOut
        }
        if let outTo = options[.outToPosition] as? Position {
            outToPosition = outTo
        }
        if let scaleOut = options[.scaleOut] as? Bool {
            useScaleOut = scaleOut
        }
        if let alphaOut = options[.alphaOut] as? Bool {
            fadeOutAlpha = alphaOut
        }
    }
    
<<<<<<< HEAD
    public func presentationControllerForPresentedViewController(
        presented: UIViewController,
        presentingViewController presenting: UIViewController,
        sourceViewController source: UIViewController) -> UIPresentationController? {
=======
    func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController) -> UIPresentationController? {
>>>>>>> release/v1.02.0
        
        return OverlayPresentationController(
            presentedViewController: presented,
            presentingViewController: presenting!,
            preferredContentSize: preferredContentSize,
            dimmingBGColor: dimmingBGColor,
            tapToDismiss: tapToDismiss,
            dismissalCompletion: dismissalCompletion)
    }
  
<<<<<<< HEAD
    public func animationControllerForPresentedController(
        presented: UIViewController,
        presentingController presenting: UIViewController,
        sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
=======
    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
>>>>>>> release/v1.02.0
        
        return TransitionInAnimator(
            withDuration: durationIn,
            fromPosition: fromPosition,
            useScale: useScaleIn,
            fadeInAlpha: fadeInAlpha,
            springDampening: springDampening,
            springVelocity: springVelocity)
    }
  
<<<<<<< HEAD
    public func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
=======
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
>>>>>>> release/v1.02.0
        
        return TransitionOutAnimator(
            withDuration: durationOut,
            toPosition: outToPosition,
            useScale: useScaleOut,
            fadeOutAlpha: fadeOutAlpha)
    }
}
