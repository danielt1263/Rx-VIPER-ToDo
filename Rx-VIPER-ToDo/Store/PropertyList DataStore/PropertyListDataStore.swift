//
//  PropertyListDataStore.swift
//  Rx-VIPER-ToDo
//
//  Created by Daniel Tartaglia on 9/17/19.
//  Copyright © 2019 Daniel Tartaglia. All rights reserved.
//

import Foundation
import RxSwift

struct TestError: Error { }

class PropertyListDataStore: DataStore {
	func createTodo(_ todo: Todo) -> Observable<Void> {
		do {
			let data = try PropertyListEncoder().encode(todos + [todo])
			try data.write(to: saveFile)
			return .just(())
		}
		catch {
			return .error(error)
		}
	}

	func readUpcomingToDos(from: Date, to: Date) -> Observable<[Todo]> {
		let calendar = Calendar.current
		return .just(
			todos.filter {
				calendar.startOfDay(for: from) <= $0.date && $0.date < calendar.startOfDay(for: to)
			}
		)
	}

	private let saveFile = applicationDocumentsDirectory.appendingPathComponent("save.plist")

	private var todos: [Todo] {
		do {
			let data = try Data(contentsOf: saveFile)
			return try PropertyListDecoder().decode([Todo].self, from: data)
		}
		catch {
			return []
		}
	}
}

private var applicationDocumentsDirectory: URL = {
	let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
	return urls.last!
}()
