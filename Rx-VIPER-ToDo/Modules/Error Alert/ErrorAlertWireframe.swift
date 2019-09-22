//
//  ErrorAlertWireframe.swift
//  Rx-VIPER-ToDo
//
//  Created by Daniel Tartaglia on 9/21/19.
//  Copyright © 2019 Daniel Tartaglia. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

func displayErrorAlert(error: Error, on parent: UIViewController) {
	let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
	alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
	parent.present(alert, animated: true, completion: nil)
}
