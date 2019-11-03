//
//  ListToDoTests.swift
//  Rx-VIPER-ToDoTests
//
//  Created by Daniel Tartaglia on 11/3/19.
//  Copyright © 2019 Daniel Tartaglia. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
@testable import Rx_VIPER_ToDo

class ListToDoTests: XCTestCase {

	func test_TodosInDateOrder() {
		let scheduler = TestScheduler(initialClock: 0)
		let now = Date()
		let later = Calendar.current.date(byAdding: .day, value: 1, to: now)!
		let firstTodo = Todo(id: Identifier<Todo>(rawValue: UUID()), title: "After", date: later)
		let secondTodo = Todo(id: Identifier<Todo>(rawValue: UUID()), title: "Before", date: now)
		let dataStore = TestDataStore({ from, to in .just([secondTodo, firstTodo]) })
		let result = scheduler.start {
			return getTodos(dataStore: dataStore)(now)
		}

		XCTAssertEqual(result.events, [.next(200, [UpcomingItem(dateRelation: .today, dueDate: now, title: "Before"), UpcomingItem(dateRelation: .tomorrow, dueDate: later, title: "After")]), .completed(200)])
	}

	func test_TodoDisplayGrouped() {
		let scheduler = TestScheduler(initialClock: 0)
		var components = DateComponents()
		components.year = 2019
		components.month = 11
		components.day = 3
		let now = Calendar.current.date(from: components)!
		let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: now)!
		let later = Calendar.current.date(byAdding: .day, value: 2, to: now)!
		let nextWeek = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: now)!
		let todayItem = UpcomingItem(dateRelation: .today, dueDate: now, title: "Before")
		let tomorrowItem = UpcomingItem(dateRelation: .tomorrow, dueDate: tomorrow, title: "After")
		let thisWeekItem = UpcomingItem(dateRelation: .laterThisWeek, dueDate: later, title: "After, After")
		let nextWeekItem = UpcomingItem(dateRelation: .nextWeek, dueDate: nextWeek, title: "Next Week")
		let interactor: ListInteractor = { _ in .just([
			todayItem, tomorrowItem, thisWeekItem, nextWeekItem
		]) }
		let listInput = ListViewController.Input(add: .never(), refresh: .just(now))
		let result = scheduler.start {
			listEventHandler(updated: .never(), interactor: interactor)(listInput).0.displaySections
		}

		XCTAssertEqual(result.events, [.next(200, [
			UpcomingDisplaySection(model: Section(name: "TODAY", imageName: "check"), items: [UpcomingDisplayItem(title: "Before", dueDay: "")]),
		UpcomingDisplaySection(model: Section(name: "TOMORROW", imageName: "alarm"), items: [UpcomingDisplayItem(title: "After", dueDay: "Monday")]),
		UpcomingDisplaySection(model: Section(name: "THIS WEEK", imageName: "circle"), items: [UpcomingDisplayItem(title: "After, After", dueDay: "Tuesday")]),
		UpcomingDisplaySection(model: Section(name: "NEXT WEEK", imageName: "calendar"), items: [UpcomingDisplayItem(title: "Next Week", dueDay: "Sunday")])
		])])
	}
}

private class TestDataStore: DataStore {
	init(_ read: @escaping (_ from: Date, _ to: Date) -> Observable<[Todo]>) {
		_read = read
	}

	func createTodo(_ todo: Todo) -> Observable<Void> { return .never() }

	func readUpcomingToDos(from: Date, to: Date) -> Observable<[Todo]> { return _read(from, to) }

	private let _read: (_ from: Date, _ to: Date) -> Observable<[Todo]>
}
