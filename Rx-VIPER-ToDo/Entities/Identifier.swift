//
//  Identifier.swift
//  Rx-VIPER-ToDo
//
//  Created by Daniel Tartaglia on 9/15/19.
//  Copyright © 2019 Daniel Tartaglia. All rights reserved.
//

import Foundation

struct Identifier<ID>: RawRepresentable, Codable, Equatable {
	let rawValue: UUID
}

extension Identifier {
	init() {
		rawValue = UUID()
	}
}
