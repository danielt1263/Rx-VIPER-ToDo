//
//  ListViewController.swift
//  Rx-VIPER-ToDo
//
//  Created by Daniel Tartaglia on 9/12/19.
//  Copyright © 2019 Daniel Tartaglia. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class ListViewController: UITableViewController, HasPresenter {

	struct Input {
		let add: Observable<Void>
	}

	struct Output { }

	@IBOutlet weak var addItem: UIBarButtonItem!
	
	var buildOutput: (Input) -> Output = { _ in fatalError() }

	override func viewDidLoad() {
		super.viewDidLoad()

		let input = Input(add: addItem.rx.tap.asObservable())
		_ = buildOutput(input)
	}
}
