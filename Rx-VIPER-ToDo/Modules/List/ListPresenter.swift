//
//  ListPresenter.swift
//  Rx-VIPER-ToDo
//
//  Created by Daniel Tartaglia on 9/12/19.
//  Copyright © 2019 Daniel Tartaglia. All rights reserved.
//

import Foundation
import RxSwift

enum ListAction {
	case add
}

func listEventHandler() -> (ListViewController.Input) -> (ListViewController.Output, Observable<ListAction>) {
	return { input in
		return (
			ListViewController.Output(),
			input.add.map { ListAction.add }
		)
	}
}
