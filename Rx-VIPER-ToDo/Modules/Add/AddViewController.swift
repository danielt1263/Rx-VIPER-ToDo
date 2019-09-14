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

final class AddViewController: UIViewController {

	@IBOutlet weak var topConstraint: NSLayoutConstraint!
	@IBOutlet weak var blurView: UIVisualEffectView!
	@IBOutlet weak var dialogView: UIView!
	@IBOutlet weak var cancelButtonItem: UIBarButtonItem!
	@IBOutlet weak var saveButtonItem: UIBarButtonItem!
	@IBOutlet weak var nameField: UITextField!
	@IBOutlet weak var datePicker: UIDatePicker!
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		nameField.becomeFirstResponder()
	}
}
