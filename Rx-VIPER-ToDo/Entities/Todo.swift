//
//  Todo.swift
//  Rx-VIPER-ToDo
//
//  Created by Daniel Tartaglia on 9/15/19.
//  Copyright © 2019 Daniel Tartaglia. All rights reserved.
//

import Foundation

struct Todo: Codable {
	let id: Identifier<Todo>
	let title: String
	let date: Date
}
