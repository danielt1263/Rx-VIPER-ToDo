//
//  AddInteractor.swift
//  Rx-VIPER-ToDo
//
//  Created by Daniel Tartaglia on 9/17/19.
//  Copyright © 2019 Daniel Tartaglia. All rights reserved.
//

import Foundation
import RxSwift

typealias AddInteractor = (_ title: String, _ date: Date) -> Observable<Void>

func saveTodo(dataStore: DataStore) -> AddInteractor {
	return { title, date in
		precondition(!title.isEmpty)
		let calendar = Calendar.current
		let todo = Todo(id: Identifier<Todo>(), title: title, date: calendar.startOfDay(for: date))
		return dataStore.createTodo(todo)
	}
}
