//
//  ListPresenter.swift
//  Rx-VIPER-ToDo
//
//  Created by Daniel Tartaglia on 9/12/19.
//  Copyright © 2019 Daniel Tartaglia. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

func displayList(on navigation: UINavigationController) {
	let controller = navigation.topViewController as! ListViewController
	let updated = PublishRelay<Date>()
	_ = controller.installPresenter(presenter: listEventHandler(updated: updated.asObservable(), interactor: getTodos(dataStore: defaultDataStore)))
		.bind(onNext: { [unowned controller] action in
			switch action {
				case .add:
					_ = displayAdd(on: controller)
						.map { Date() }
						.bind(to: updated)
				case .error(let error):
					displayErrorAlert(error: error, on: controller)
			}
		})
}

enum ListAction {
	case add
	case error(Error)
}
