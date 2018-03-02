//
//  MasterViewController.swift
//  AW-Integration
//
//  Created by Pascal Dreer on 28.02.18.
//  Copyright © 2018 Lakehorn AG. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

	@IBOutlet weak var replaceSwitch: UISwitch!
	
	var detailViewController: DetailViewController? = nil
	var groups = [Group]()


	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.

		let exportButton = UIBarButtonItem(title: "Export", style: .plain, target: self, action: #selector(exportButtonPressed(_:)))
		navigationItem.rightBarButtonItem = exportButton
		if let split = splitViewController {
		    let controllers = split.viewControllers
		    detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
		}
		
		
		// generate groups (should come from your app)
		groups.append(Group(name: "ZRH - HND", identfifiers: ["ZRH", "MUC", "PEK", "HND"]))
		groups.append(Group(name: "KSFO - KBOS", identfifiers: ["KSFO", "KIND", "KCMH", "KBOS"]))
	}

	override func viewWillAppear(_ animated: Bool) {
		clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
		super.viewWillAppear(animated)
		
		tableView.reloadData()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	@objc func exportButtonPressed(_ sender: Any) {
		var replaceOption: String? = nil
		if replaceSwitch.isOn {
			replaceOption = "replace"
		}
		
		let aeroWeatherDoc = AeroWeatherJSON(creatorBundleID: "com.lakehorn.aeroweather", creatorName: "Your App Name")	// use yours
		if let jsonObject = aeroWeatherDoc.jsonDataForGroups(groups, previousGroupsOption: replaceOption) {			// create JSON data
			var jsonDataWithURI = "aeroweather://createGroups/json=".data(using: .utf8)					// URI to call app and method
			jsonDataWithURI?.append(jsonObject)																		// append JSON data
			let url = URL(dataRepresentation: jsonDataWithURI!, relativeTo: nil)
			UIApplication.shared.open(url!, options: [:], completionHandler: { (success) in							// open AeroWeather and transfer data
				if !success {
					self.appNotOnDeviceAlert()
				}
			})
		}
	}

	
	private func appNotOnDeviceAlert() {
		let alertController = UIAlertController(title: "AeroWeather not found", message: "AeroWeather Pro needs to be installed in order to export data.", preferredStyle: .alert)
		alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
		
		self.present(alertController, animated: true, completion: nil)
	}
	
	
	// MARK: - Segues

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "showDetail" {
		    if let indexPath = tableView.indexPathForSelectedRow {
		        let object = groups[indexPath.row]
		        let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
		        controller.detailItem = object
		        controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
		        controller.navigationItem.leftItemsSupplementBackButton = true
		    }
		}
	}

	// MARK: - Table View

	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return groups.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

		let object = groups[indexPath.row]
		cell.textLabel!.text = object.name
		return cell
	}

}

