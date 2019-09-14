//
//  AddTransitioning.swift
//  Rx-VIPER-ToDo
//
//  Created by Daniel Tartaglia on 9/13/19.
//  Copyright © 2019 Daniel Tartaglia. All rights reserved.
//

import UIKit

final class AddTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
	func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		return AddAnimatedTransition()
	}

	func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		return AddAnimatedTransition()
	}
}

final class AddAnimatedTransition: NSObject, UIViewControllerAnimatedTransitioning {
	func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
		return 0.72
	}

	func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
		let initialConstant: CGFloat
		let finalConstant: CGFloat
		let blurAlpha: CGFloat
		let controller: AddViewController
		if let toVC = transitionContext.viewController(forKey: .to) as? AddViewController {
			initialConstant = -toVC.dialogView.frame.height - UIApplication.shared.keyWindow!.safeAreaInsets.top
			finalConstant = 0
			blurAlpha = 0.7
			controller = toVC
			transitionContext.containerView.addSubview(toVC.view)
		}
		else if let fromVC = transitionContext.viewController(forKey: .from) as? AddViewController {
			initialConstant = 0
			finalConstant = -fromVC.dialogView.frame.height - UIApplication.shared.keyWindow!.safeAreaInsets.top - 8
			blurAlpha = 0
			controller = fromVC
		}
		else {
			fatalError("This transition is designed for the AddViewController.")
		}

		controller.topConstraint.constant = initialConstant

		controller.view.layoutIfNeeded()
		UIView.animate(
			withDuration: transitionDuration(using: transitionContext),
			delay: 0,
			usingSpringWithDamping: 0.64,
			initialSpringVelocity: 0.22,
			options: [.curveEaseIn, .allowAnimatedContent],
			animations: {
				controller.blurView.alpha = blurAlpha
				controller.topConstraint.constant = finalConstant
				controller.view.layoutIfNeeded()
			},
			completion: { _ in
				transitionContext.completeTransition(true)
			}
		)
	}
}
