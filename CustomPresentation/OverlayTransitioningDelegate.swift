//
//  OverlayTransitioningDelegate.swift
//  Custom Presentation
//
//  Created by Dylan Edwards on 7/11/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

public enum Position {
    case top, bottom, left, right, center
}

/// Dictionary Keys
public enum TransitionOption {
    case alphaIn            /// Bool
    case alphaOut           /// Bool
    case delayIn            /// Double
    case delayOut           /// Double
    case dimmingBGColor     /// UIColor
    case dimmingBGAlpha     /// CGFloat
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
    
    private var options: [TransitionOption : Any]?
    
    /** OverlayPresentationController **/
    private var preferredContentSize: CGSize!
    private var dimmingBGColor              = UIColor(white: 0.0, alpha: 0.5)
    private var dimmingBGAlpha: CGFloat     = 0.5
    private var tapToDismiss                = false
    private var dismissalCompletion: (() -> Void)?
    
    /** TransitionInAnimator **/
    private var durationIn: Double          = 0.5
    private var delayIn: Double             = 0.0
    private var fromPosition: Position      = .bottom
    private var useScaleIn                  = false
    private var fadeInAlpha                 = false
    private var springDampening: CGFloat    = 1.0
    private var springVelocity: CGFloat     = 0.0
    
    /** TransitionOutAnimator **/
    private var durationOut: Double         = 0.5
    private var delayOut: Double            = 0.0
    private var outToPosition: Position     = .bottom
    private var useScaleOut: Bool           = false
    private var fadeOutAlpha: Bool          = false
    
    public func configureTransitionWithContentSize(_ contentSize: CGSize, options opts: [TransitionOption : Any]? = nil, dismissalCompletion outComplete: (() -> Void)? = nil) {

        preferredContentSize    = contentSize
        dismissalCompletion     = outComplete
        options = opts
        
        checkForOptions()
    }

    private func checkForOptions() {
        guard let options = options else { return }
        
        /** OverlayPresentationController **/
        
        if let bgDimming = options[.dimmingBGColor] as? UIColor {
            dimmingBGColor = bgDimming
        }
        if let bgAlpha = options[.dimmingBGAlpha] as? CGFloat {
            dimmingBGAlpha = bgAlpha
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
    
    public func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController) -> UIPresentationController? {
        
        return OverlayPresentationController(
            presentedViewController: presented,
            presentingViewController: presenting,
            preferredContentSize: preferredContentSize,
            dimmingBGColor: dimmingBGColor,
            dimmingBGAlpha: dimmingBGAlpha,
            tapToDismiss: tapToDismiss,
            dismissalCompletion: dismissalCompletion)
    }
  
    public func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return TransitionInAnimator(
            withDuration: durationIn,
            fromPosition: fromPosition,
            useScale: useScaleIn,
            fadeInAlpha: fadeInAlpha,
            springDampening: springDampening,
            springVelocity: springVelocity)
    }
  
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return TransitionOutAnimator(
            withDuration: durationOut,
            toPosition: outToPosition,
            useScale: useScaleOut,
            fadeOutAlpha: fadeOutAlpha)
    }
}
