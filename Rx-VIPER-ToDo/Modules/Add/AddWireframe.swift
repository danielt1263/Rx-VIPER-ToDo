//
//  AddWireframe.swift
//  Rx-VIPER-ToDo
//
//  Created by Daniel Tartaglia on 9/12/19.
//  Copyright © 2019 Daniel Tartaglia. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

func displayAdd(on parent: UIViewController) {
	let storyboard = UIStoryboard(name: "Main", bundle: nil)
	let controller = storyboard.instantiateViewController(withIdentifier: "Add") as! AddViewController
	controller.modalPresentationStyle = .custom
	controller.transitioningDelegate = transitioningDelegate
	controller.installPresenter(presenter: addEventHandler(minimumDate: Date()))
	parent.present(controller, animated: true, completion: nil)
}

let transitioningDelegate = AddTransitioningDelegate()
