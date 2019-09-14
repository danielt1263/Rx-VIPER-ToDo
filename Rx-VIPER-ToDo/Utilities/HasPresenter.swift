//
//  HasPresenter.swift
//  Rx-VIPER-ToDo
//
//  Created by Daniel Tartaglia on 9/12/19.
//  Copyright © 2019 Daniel Tartaglia. All rights reserved.
//

import Foundation
import RxSwift

protocol HasPresenter: class {
	associatedtype Input
	associatedtype Output
	var buildOutput: (Input) -> Output { get set }
}

extension HasPresenter {
	@discardableResult
	func installPresenter<T>(presenter: @escaping (Input) -> (Output, Observable<T>)) -> Observable<T> {
		let result = PublishSubject<T>()
		buildOutput = { input in
			let output = presenter(input)
			_ = output.1.bind(to: result)
			return output.0
		}
		return result
	}
}
