//
//  AddToDoTests.swift
//  Rx-VIPER-ToDoTests
//
//  Created by Daniel Tartaglia on 9/14/19.
//  Copyright © 2019 Daniel Tartaglia. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
@testable import Rx_VIPER_ToDo

class AddToDoTests: XCTestCase {

	func test_TapAddButton() {
		let scheduler = TestScheduler(initialClock: 0)
		let addTrigger = scheduler.createColdObservable([.next(10, ()), .completed(30)])
		let input = ListViewController.Input(
			add: addTrigger.asObservable()
		)
		let result = scheduler.start {
			return listEventHandler()(input).1
		}

		XCTAssertEqual(result.events, [.next(210, .add), .completed(230)])
	}

	func test_EnterTitleAndDate() {
		let now = Date()
		guard let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: now) else { XCTFail(); return }
		let scheduler = TestScheduler(initialClock: 0)
		let title = scheduler.createColdObservable([.next(0, ""), .next(10, "Title"), .completed(100)])
		let date = scheduler.createColdObservable([.next(0, now), .next(20, tomorrow), .completed(100)])
		let dataStore = TestDataStore { _ in .never() }
		let interactor = saveTodo(dataStore: dataStore)
		let input = AddViewController.Input(
			title: title.asObservable(),
			date: date.asObservable(),
			save: .never()
		)
		let result = scheduler.start {
			return addEventHandler(minimumDate: now, addInteractor: interactor)(input).0.saveEnabled
		}

		XCTAssertEqual(result.events, [.next(200, false), .next(210, true), .completed(300)])
	}

	func test_AddInteractor_save_success() {
		let scheduler = TestScheduler(initialClock: 0)
		var todoResult: Todo?
		let dataStore = TestDataStore { todo in
			todoResult = todo
			return .just(())
		}
		let now = Date()
		let result = scheduler.start {
			saveTodo(dataStore: dataStore)("A Title", now)
				.map { $0.map { true } }
		}

		XCTAssertEqual(todoResult?.title, "A Title")
		XCTAssertEqual(todoResult?.date, Calendar.current.startOfDay(for: now))
		XCTAssertEqual(result.events, [.next(200, .next(true)), .next(200, .completed), .completed(200)])
	}

	func test_AddInteractor_save_failure() {
		let scheduler = TestScheduler(initialClock: 0)
		let dataStore = TestDataStore { todo in
			return .error(SaveError())
		}
		let now = Date()
		let result = scheduler.start {
			saveTodo(dataStore: dataStore)("A Title", now)
				.map { $0.map { true } }
		}

		XCTAssertEqual(result.events, [.next(200, .error(SaveError())), .completed(200)])
	}

	func test_TapSaveButton() {
		let now = Date()
		let scheduler = TestScheduler(initialClock: 0)
		let testStorage = TestDataStore { _ in .just(()) }
		let title = scheduler.createHotObservable([.next(201, ""), .next(210, "A Title"), .completed(300)])
		let date = scheduler.createHotObservable([.next(201, now), .completed(300)])
		let save = scheduler.createHotObservable([.next(230, ()), .completed(300)])
		let interactor = saveTodo(dataStore: testStorage)
		let input = AddViewController.Input(
			title: title.asObservable(),
			date: date.asObservable(),
			save: save.asObservable()
		)
		let result = scheduler.start {
			return addEventHandler(minimumDate: now, addInteractor: interactor)(input).1
				.map { $0.isSuccess }
		}

		XCTAssertEqual(result.events, [.next(230, true), .completed(300)])
	}
}

struct SaveError: Error, Equatable { }

private extension AddAction {
	var isSuccess: Bool {
		if case .success = self { return true }
		else { return false }
	}
}

private class TestDataStore: DataStore {
	init(_ create: @escaping (Todo) -> Observable<Void>) {
		_create = create
	}

	func createTodo(_ todo: Todo) -> Observable<Void> {
		return _create(todo)
	}

	func readUpcomingToDos(from: Date, to: Date) -> Observable<[Todo]> { return .never() }

	private let _create: (Todo) -> Observable<Void>
}
