//
//  DBRequest.swift
//  Rx-VIPER-ToDo
//
//  Created by Daniel Tartaglia on 9/15/19.
//  Copyright © 2019 Daniel Tartaglia. All rights reserved.
//

import Foundation
import RxSwift

protocol DataStore {
	func createTodo(_ todo: Todo) -> Observable<Void>
	func readUpcomingToDos(from: Date, to: Date) -> Observable<[Todo]>
}
