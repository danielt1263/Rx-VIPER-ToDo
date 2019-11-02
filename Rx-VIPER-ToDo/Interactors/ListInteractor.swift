//
//  ListInteractor.swift
//  Rx-VIPER-ToDo
//
//  Created by Daniel Tartaglia on 11/2/19.
//  Copyright © 2019 Daniel Tartaglia. All rights reserved.
//

import Foundation
import RxSwift

typealias ListInteractor = (_ today: Date) -> Observable<[UpcomingItem]>

func getTodos(dataStore: DataStore) -> ListInteractor {
	return { today in
		let calendar = Calendar.current
		let from = calendar.startOfDay(for: today)
		let to = calendar.date(byAdding: .day, value: 14, to: from)!
		return dataStore.readUpcomingToDos(from: from, to: to)
			.map { $0.map { UpcomingItem(today: today, todo: $0) } }
			.map { $0.filter { $0.dateRelation != .outOfRange } }
			.map { $0.sorted(by: { $0.dueDate < $1.dueDate }) }
	}
}

extension UpcomingItem {
	init(today: Date, todo: Todo) {
		dateRelation = NearTermDateRelation(today: today, target: todo.date)
		dueDate = todo.date
		title = todo.title
	}
}

extension NearTermDateRelation {
	init(today: Date, target: Date) {
		let calendar = Calendar.current
		let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)!
		let nextWeek = calendar.date(byAdding: .weekOfYear, value: 1, to: today)!
		if calendar.isDate(today, inSameDayAs: target) {
			self = .today
		}
		else if calendar.isDate(tomorrow, inSameDayAs: target) {
			self = .tomorrow
		}
		else if calendar.isDate(today, equalTo: target, toGranularity: .weekOfYear) {
			self = .laterThisWeek
		}
		else if calendar.isDate(nextWeek, equalTo: target, toGranularity: .weekOfYear) {
			self = .nextWeek
		}
		else {
			self = .outOfRange
		}
	}
}
