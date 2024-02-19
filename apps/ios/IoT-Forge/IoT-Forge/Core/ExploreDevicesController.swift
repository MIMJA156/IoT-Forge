//
//  ExploreDevicesController.swift
//  IoT-Forge
//
//  Created by Mizia, Miles - Student on 2/17/24.
//

import UIKit

class ExploreDevicesController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let dataHelper = DataHelper.shared
    
    lazy var tableView: UITableView = {
        let table = UITableView(frame: self.view.bounds, style: .plain)
        return table
    }()
    
    var tableViewData: [TableViewSection] = [
        TableViewSection<DeviceConfigurationProfile>(title: "Built In", data: [])
    ]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setTableViewSectionDataBasedOnTitle(
            title: "Built In",
            data: dataHelper.getLocalDeviceConfigurationProfiles()
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
        setupSubviews()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func buildUI() {
        title = "Explore"
        view.backgroundColor = .systemBackground
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupSubviews() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
        ])
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
        
        let chevron = UIImageView(image: UIImage(systemName: "chevron.right"))
        cell.accessoryView = chevron
        
        cell.configure(with: tableViewData[indexPath.section].data[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let next = DetailedExploreController()
        next.selectedDeviceConfigurationProfile = tableViewData[indexPath.section].data[indexPath.row]
        navigationController?.pushViewController(next, animated: true)
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
