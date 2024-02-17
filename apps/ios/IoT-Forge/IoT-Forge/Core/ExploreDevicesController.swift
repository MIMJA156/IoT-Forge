//
//  ExploreDevicesController.swift
//  IoT-Forge
//
//  Created by Mizia, Miles - Student on 2/17/24.
//

import UIKit

class ExploreDevicesController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let dataHelper = DataHelper.shared
    
    let tableView = UITableView()
    
    var tableViewData: [TableViewSection] = [
        TableViewSection<DeviceConfigurationProfile>(title: "Built In", data: []),
        TableViewSection<DeviceConfigurationProfile>(title: "External", data: [])
    ]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setTableViewSectionDataBasedOnTitle(
            title: "Built In",
            data: dataHelper.getLocalDeviceConfigurationProfiles()
        )
        
        setTableViewSectionDataBasedOnTitle(
            title: "External",
            data: dataHelper.getCloudDeviceConfigurationProfiles()
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func buildUI() {
        // BEGIN - MAIN VIEW
        title = "Explore"
        view.backgroundColor = .systemBackground
        // END - MAIN VIEW
        
        // BEGIN - tableView
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        // END - tableView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableViewData[section].title
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewData[section].data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = DeviceConfigurationProfileCell()
        cell.configure(with: tableViewData[indexPath.section].data[indexPath.row])
        return cell
    }
    
    func setTableViewSectionDataBasedOnTitle(title: String, data: [DeviceConfigurationProfile]) {
        for (index, item) in tableViewData.enumerated() {
            if item.title == title {
                tableViewData[index].data = data
                break
            }
        }
    }
}
