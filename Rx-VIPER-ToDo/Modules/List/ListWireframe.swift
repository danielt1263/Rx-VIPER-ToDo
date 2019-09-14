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
	_ = controller.installPresenter(presenter: listEventHandler())
		.bind(onNext: { [unowned controller] action in
			switch action {
			case .add:
				displayAdd(on: controller)
			}
		})
}
