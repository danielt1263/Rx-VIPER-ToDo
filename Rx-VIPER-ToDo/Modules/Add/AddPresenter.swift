//
//  AddPresenter.swift
//  Rx-VIPER-ToDo
//
//  Created by Daniel Tartaglia on 9/14/19.
//  Copyright © 2019 Daniel Tartaglia. All rights reserved.
//

import Foundation
import RxSwift

enum AddAction { }

func addEventHandler(minimumDate: Date) -> (AddViewController.Input) -> (AddViewController.Output, Observable<AddAction>) {
	return { input in

		let saveEnabled = Observable.combineLatest(input.title, input.date)
			.map { !$0.0.isEmpty }
			.distinctUntilChanged()

		return (
			AddViewController.Output(
				minimumDate: minimumDate,
				saveEnabled: saveEnabled
			),
			.never()
		)
	}
}

