//
//  AeroWeatherJSON.swift
//  AW-Integration
//
//  Created by Pascal Dreer on 28.02.18.
//  Copyright © 2018 Lakehorn AG. All rights reserved.
//

import Foundation

class AeroWeatherJSON: NSObject {

	private var creatorBundleID: String = "your.bundle.ID"	// bundleID of your app
	private var creatorName: String?							// app name (optional, but useful for user)
	private var createdDate: String?							// ISO_8601

	
	convenience init(creatorBundleID: String, creatorName: String?) {
		self.init()
		
		self.creatorBundleID = creatorBundleID
		self.creatorName = creatorName
		
		let formatter = DateFormatter()
		formatter.locale = Locale(identifier: "en_US_POSIX")
		formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
		self.createdDate = formatter.string(from: Date())
	}

	
	func jsonDataForGroups(_ groups: [Group], previousGroupsOption: String?) -> Data? {
		var jsonObject = [String: AnyObject]()

		// add metadata (header)
		var metaData_dictionary = [String: Any]()
		metaData_dictionary["creatorBundleID"] = creatorBundleID
		if let creatorName = creatorName {
			metaData_dictionary["creatorName"] = creatorName
		}
		if let createdDate = createdDate {
			metaData_dictionary["createdDate"] = createdDate
		}
		if let previousGroup = previousGroupsOption {
			metaData_dictionary["previousGroups"] = previousGroup
		}
		jsonObject["metadata"] = metaData_dictionary as AnyObject
		
		
		// add groups (dictionary builder is in Group class)
		var g = [AnyObject]()
		for group in groups {
			g.append(group.toDictionary() as AnyObject)
		}
		jsonObject["groups"] = g as AnyObject
		
		
		// validate and create JSON object
		if JSONSerialization.isValidJSONObject(jsonObject) {
			do {
				let jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: JSONSerialization.WritingOptions(rawValue: 0))
				return jsonData
			} catch let dataError {
				print(dataError)
				return nil
			}
		}
		else {
			print("invalidJSONObject")
			return nil
		}
	}
	
	

}
