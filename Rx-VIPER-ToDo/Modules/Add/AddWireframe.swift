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
	_ = controller.installPresenter(presenter: addEventHandler(
		minimumDate: Date(),
		addInteractor: saveTodo(dataStore: defaultDataStore)
	))
		.bind(onNext: { [unowned parent, unowned controller] action in
			switch action {
			case .success:
				parent.dismiss(animated: true, completion: nil)
			case .failure(let error):
				displayErrorAlert(error: error, on: controller)
			}
		})
	parent.present(controller, animated: true, completion: nil)
}

let transitioningDelegate = AddTransitioningDelegate()
