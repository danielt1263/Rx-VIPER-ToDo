//
//  ListPresenter.swift
//  Rx-VIPER-ToDo
//
//  Created by Daniel Tartaglia on 9/12/19.
//  Copyright © 2019 Daniel Tartaglia. All rights reserved.
//

import Foundation
import RxSwift

func listEventHandler(updated: Observable<Date>, interactor: @escaping ListInteractor) -> (ListViewController.Input) -> (ListViewController.Output, Observable<ListAction>) {
	return { input in

		let upcomingItemsResult = Observable.merge(input.refresh, updated)
			.flatMapLatest { interactor($0).materialize() }

		let displaySections = upcomingItemsResult
			.compactMap { $0.element }
			.map { upcomingItems in
				return upcomingItems.reduce(into: [UpcomingDisplaySection]()) { result, item in
					let displayItem = UpcomingDisplayItem(item)
					if let index = result.firstIndex(where: { $0.model == Section(dateRelation: item.dateRelation) }) {
						result[index].items.append(displayItem)
					}
					else {
						result.append(UpcomingDisplaySection(model: Section(dateRelation: item.dateRelation), items: [displayItem]))
					}
				}
		}

		return (
			ListViewController.Output(
				isRefreshing: upcomingItemsResult.map { _ in false },
				displaySections: displaySections,
				backgroundViewHidden: displaySections.map { !$0.isEmpty }
			),
			.merge(
				input.add.map { ListAction.add },
				upcomingItemsResult.compactMap { $0.error }.map { ListAction.error($0) }
			)
		)
	}
}

struct UpcomingItem: Equatable {
	let dateRelation: NearTermDateRelation
	let dueDate: Date
	let title: String
}

enum NearTermDateRelation: Equatable {
	case outOfRange
	case today
	case tomorrow
	case laterThisWeek
	case nextWeek
}

private extension Section {
	init(dateRelation: NearTermDateRelation) {
		switch dateRelation {
		case .outOfRange:
			name = "OUT OF RANGE"
			imageName = "paper"
		case .today:
			name = "TODAY"
			imageName = "check"
		case .tomorrow:
			name = "TOMORROW"
			imageName = "alarm"
		case .laterThisWeek:
			name = "THIS WEEK"
			imageName = "circle"
		case .nextWeek:
			name = "NEXT WEEK"
			imageName = "calendar"
		}
	}
}

private extension UpcomingDisplayItem {
	init(_ item: UpcomingItem) {
		title = item.title
		dueDay = item.dateRelation == .today ? "" : dayFormatter.string(from: item.dueDate)
	}
}

private let dayFormatter: DateFormatter = {
	let result = DateFormatter()
	result.dateFormat = DateFormatter.dateFormat(fromTemplate: "EEEE", options: 0, locale: nil)
	return result
}()
