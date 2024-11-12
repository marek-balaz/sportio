//
//  RouterEntry.swift
//  Sportio
//
//  Created by Marek Baláž on 10/11/2024.
//

import Foundation

struct RouteEntry<T>: Equatable {
    
	let name: String
	
	init(_ name: String) {
		self.name = name
	}
}

struct AnyRouteEntry {
    
	let getName: () -> String
	
	init<T>(item: RouteEntry<T>) {
		self.getName = { item.name }
	}
}
