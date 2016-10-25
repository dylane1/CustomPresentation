//
//  OverlayPresentationController.swift
//  Custom Presentation
//
//  Created by Dylan Edwards on 7/11/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//


import UIKit

final public class OverlayPresentationController: UIPresentationController {
    
    fileprivate var dimmingView: UIView!
    fileprivate var dimmingBGColor: UIColor!
    fileprivate var contentSize: CGSize!
    fileprivate var tapToDismiss = false
    
    /**
     Need dismissalCompletion if the tap background to dismiss option is
     used.
    */
    fileprivate var dismissalCompletion: (() -> Void)?
    
    //MARK: - View Lifecycle
    
    fileprivate override init( presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
    required convenience public init(
        presentedViewController: UIViewController,
        presentingViewController: UIViewController?,
        preferredContentSize: CGSize,
        dimmingBGColor bgColor: UIColor = UIColor.black,
        tapToDismiss tap: Bool = false,
        dismissalCompletion completion: (() -> Void)? = nil) {
        
        self.init(presentedViewController: presentedViewController, presenting: presentingViewController)

        contentSize         = preferredContentSize
        dimmingBGColor      = bgColor
        dismissalCompletion = completion
        tapToDismiss        = tap
    }
    
    //MARK: - Configuration
    
    func setupDimmingView() {
        dimmingView = UIView()
        
        dimmingView.backgroundColor = dimmingBGColor
        dimmingView.alpha           = 0.0
        dimmingView.frame           = containerView!.bounds

        if tapToDismiss {
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(OverlayPresentationController.dimmingViewTapped(_:)))
            dimmingView.addGestureRecognizer(tapRecognizer)
        }
    }
    
    func dimmingViewTapped(_ tapRecognizer: UITapGestureRecognizer) {
        presentingViewController.dismiss(animated: true, completion: nil)
    }
    
    override public func presentationTransitionWillBegin() {
        setupDimmingView()
        
        presentedViewController.preferredContentSize = contentSize
        containerView!.insertSubview(dimmingView, at: 0)
        
        presentedViewController.transitionCoordinator?.animate( alongsideTransition: { [weak self] context in
            self!.dimmingView.alpha = 0.5
        }, completion: nil)
        
    }
    
    override public func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] context in
            self!.dimmingView.alpha = 0.0
        }, completion: { [weak self] context in
            self!.dimmingView.removeFromSuperview()
            self!.dismissalCompletion?()
        })
    }
    
    override public var frameOfPresentedViewInContainerView : CGRect {
        if presentedViewController.preferredContentSize.width > 0 {
            let x = containerView!.center.x - presentedViewController.preferredContentSize.width / 2
            let y = containerView!.center.y - presentedViewController.preferredContentSize.height / 2
            return CGRect(x: x, y: y, width: presentedViewController.preferredContentSize.width, height: presentedViewController.preferredContentSize.height)
        } else {
            return containerView!.bounds.insetBy(dx: 0, dy: 0)
        }
    }
    
    override public func containerViewWillLayoutSubviews() {
        dimmingView.frame = containerView!.bounds
        presentedView!.frame = frameOfPresentedViewInContainerView
    }
}
