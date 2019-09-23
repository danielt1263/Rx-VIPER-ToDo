//
//  AddViewController.swift
//  Rx-VIPER-ToDo
//
//  Created by Daniel Tartaglia on 9/13/19.
//  Copyright © 2019 Daniel Tartaglia. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class AddViewController: UIViewController, HasPresenter {

	struct Input {
		let title: Observable<String>
		let date: Observable<Date>
		let save: Observable<Void>
		let cancel: Observable<Void>
	}

	struct Output {
		let minimumDate: Date
		let saveEnabled: Observable<Bool>
	}
	
	@IBOutlet weak var topConstraint: NSLayoutConstraint!
	@IBOutlet weak var blurView: UIVisualEffectView!
	@IBOutlet weak var dialogView: UIView!
	@IBOutlet weak var cancelButtonItem: UIBarButtonItem!
	@IBOutlet weak var saveButtonItem: UIBarButtonItem!
	@IBOutlet weak var nameField: UITextField!
	@IBOutlet weak var datePicker: UIDatePicker!

	var buildOutput: (Input) -> Output = { _ in fatalError() }

	private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

		let input = Input(
			title: nameField.rx.text.orEmpty.asObservable(),
			date: datePicker.rx.date.asObservable(),
			save: saveButtonItem.rx.tap.asObservable(),
			cancel: cancelButtonItem.rx.tap.asObservable()
		)
		let output = buildOutput(input)
		datePicker.minimumDate = output.minimumDate
		output.saveEnabled
			.bind(to: saveButtonItem.rx.isEnabled)
			.disposed(by: disposeBag)

		rx.methodInvoked(#selector(viewDidAppear(_:)))
			.bind(onNext: { [nameField] _ in
				nameField?.becomeFirstResponder()
			})
			.disposed(by: disposeBag)
    }
}
