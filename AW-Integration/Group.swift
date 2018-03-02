//
//  Group.swift
//  AW-Integration
//
//  Created by Pascal Dreer on 28.02.18.
//  Copyright © 2018 Lakehorn AG. All rights reserved.
//

import Foundation

class Group: NSObject {
	
	// group properties
	var name:		String?
	var sortOrder:	String = "countryWithName"		// userDefined, icaoCode, iataCode, name, countryWithName, countryWithIcao, proximity (optional)
	var dataFormat:	String = "raw"						// raw or decoded  (optional)
	var style:		String = "regular"				// regular  or timebased (optional)
	
	var locations:	[String]?							// array of IACO or IATA identifiers

	
	convenience init(name: String, identfifiers: [String]) {
		self.init()
		
		self.name = name
		self.locations = identfifiers
	}
	
	
	func toDictionary() -> [String : Any] {
		var dictionary = [String: Any]()
		dictionary["name"] = name
		dictionary["sortOrder"] = sortOrder
		dictionary["dataFormat"] = dataFormat
		dictionary["style"] = style
		dictionary["locations"] = locations
		return dictionary
	}


}
