//
//  DetailViewController.swift
//  AW-Integration
//
//  Created by Pascal Dreer on 28.02.18.
//  Copyright © 2018 Lakehorn AG. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

	@IBOutlet weak var groupName: UITextField!
	@IBOutlet weak var locationList: UITextField!
	@IBOutlet weak var dataFormat: UILabel!
	@IBOutlet weak var sortOrder: UILabel!
	
	func configureView() {
		// Update the user interface for the detail item.
		if let detail = detailItem {
			if let groupName = groupName {
				groupName.text = detail.name
				dataFormat.text = detail.dataFormat
				sortOrder.text = detail.sortOrder
				locationList.text = detail.locations?.joined(separator: " ")
			}
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		configureView()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	var detailItem: Group? {
		didSet {
		    // Update the view.
		    configureView()
		}
	}

}


extension DetailViewController: UITextFieldDelegate {
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		if textField == groupName {
			detailItem?.name = textField.text
		}
		else if textField == locationList {
			if let list = textField.text?.components(separatedBy: CharacterSet.whitespaces) {
				detailItem?.locations = list
			}
		}
	}
	
}
