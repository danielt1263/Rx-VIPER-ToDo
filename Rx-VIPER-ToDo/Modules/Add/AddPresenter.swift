//
//  AddPresenter.swift
//  Rx-VIPER-ToDo
//
//  Created by Daniel Tartaglia on 9/14/19.
//  Copyright © 2019 Daniel Tartaglia. All rights reserved.
//

import Foundation
import RxSwift

enum AddAction {
	case success
	case cancel
	case failure(Error)
}

func addEventHandler(minimumDate: Date, addInteractor: @escaping AddInteractor) -> (AddViewController.Input) -> (AddViewController.Output, Observable<AddAction>) {
	return { input in
		let proposedTodo = Observable.combineLatest(input.title, input.date) { (title: $0, date: $1) }
		let saveEnabled = proposedTodo
			.map { !$0.0.isEmpty }
			.distinctUntilChanged()
		let savedTodo = input.save
			.withLatestFrom(proposedTodo)
			.flatMapLatest { addInteractor($0.title, $0.date) }
			.share()

		return (
			AddViewController.Output(
				minimumDate: minimumDate,
				saveEnabled: saveEnabled
			),
			Observable.merge(
				savedTodo.compactMap { $0.element }.map { AddAction.success },
				savedTodo.compactMap { $0.error }.map { AddAction.failure($0) },
				input.cancel.map { AddAction.cancel }
			)
		)
	}
}
