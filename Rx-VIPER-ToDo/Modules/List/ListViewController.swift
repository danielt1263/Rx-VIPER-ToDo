//
//  ListViewController.swift
//  Rx-VIPER-ToDo
//
//  Created by Daniel Tartaglia on 9/12/19.
//  Copyright © 2019 Daniel Tartaglia. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class ListViewController: UITableViewController, HasPresenter {

	struct Input {
		let add: Observable<Void>
		let refresh: Observable<Date>
	}

	struct Output {
		let isRefreshing: Observable<Bool>
		let displaySections: Observable<[UpcomingDisplaySection]>
		let backgroundViewHidden: Observable<Bool>
	}

	@IBOutlet weak var addItem: UIBarButtonItem!
	@IBOutlet weak var backgroundView: UIView!

	var buildOutput: (Input) -> Output = { _ in fatalError() }

	private let disposeBag = DisposeBag()

	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.dataSource = nil
		tableView.backgroundView = backgroundView

		let input = Input(
			add: addItem.rx.tap.asObservable(),
			refresh: tableView.refreshControl!.rx.controlEvent(.valueChanged).startWith(()).map { Date() }
		)
		let output = buildOutput(input)

		disposeBag.insert(
			output.isRefreshing.bind(to: tableView.refreshControl!.rx.isRefreshing),
			output.displaySections.bind(to: tableView.rx.items(dataSource: dataSource)),
			output.backgroundViewHidden.bind(to: tableView.backgroundView!.rx.isHidden)
		)
	}
}

private let dataSource: RxTableViewSectionedReloadDataSource<UpcomingDisplaySection> = {
	let result = RxTableViewSectionedReloadDataSource<UpcomingDisplaySection>(
		configureCell: { (dataSource, tableView, indexPath, item) -> UITableViewCell in
			let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
			cell.textLabel?.text = item.title
			cell.detailTextLabel?.text = item.dueDay
			cell.imageView?.image = UIImage(named: dataSource.sectionModels[indexPath.section].model.imageName)
			cell.selectionStyle = .none
			return cell
		},
		titleForHeaderInSection: { (dataSource, section) -> String? in
			return dataSource.sectionModels[section].model.name
		}
	)

	return result
}()

typealias UpcomingDisplaySection = SectionModel<Section, UpcomingDisplayItem>

struct Section: Equatable {
	let name: String
	let imageName: String
}

struct UpcomingDisplayItem: Equatable {
	let title: String
	let dueDay: String
}
