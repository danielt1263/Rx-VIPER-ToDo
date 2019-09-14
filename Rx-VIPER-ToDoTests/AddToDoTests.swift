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
		let input = AddViewController.Input(
			title: title.asObservable(),
			date: date.asObservable()
		)
		let result = scheduler.start {
			return addEventHandler(minimumDate: now)(input).0.saveEnabled
		}

		XCTAssertEqual(result.events, [.next(200, false), .next(210, true), .completed(300)])
	}
}
