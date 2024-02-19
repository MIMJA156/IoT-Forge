//
//  ViewController.swift
//  IoT-Forge
//
//  Created by Mizia, Miles - Student on 2/17/24.
//

import UIKit

class UserDevicesController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let dataHelper = DataHelper.shared
    
    let tableView = UITableView()
    let noDevicesLabel = UILabel()
    
    var savedDevices: [String] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        savedDevices = dataHelper.getSavedDevices()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func buildUI() {
        // BEGIN - MAIN VIEW
        title = "My Devices"
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
//        let titleLabel = UILabel()
//        titleLabel.text = "My Devices"
//        titleLabel.font = .boldSystemFont(ofSize: 26)
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: titleLabel)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Explore Devices",
            style: .done,
            target: self,
            action: #selector(headToNewDeviceScreen)
        )
        // END - MAIN VIEW
        
        // BEGIN - tableView
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        // END - tableView
        
        // BEGIN - noDevicesLabel
        noDevicesLabel.isHidden = true
        
        noDevicesLabel.text = "You Have No Devices"
        noDevicesLabel.textAlignment = .center
        
        view.addSubview(noDevicesLabel)
        noDevicesLabel.translatesAutoresizingMaskIntoConstraints = false
        noDevicesLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        noDevicesLabel.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        noDevicesLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        noDevicesLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        // END - noDevicesLabel
    }
    
    @objc func headToNewDeviceScreen() {
        navigationController?.pushViewController(ExploreDevicesController(), animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = savedDevices.count
        
        if count == 0 {
            noDevicesLabel.isHidden = false
        } else {
            noDevicesLabel.isHidden = true
        }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        var config = cell.defaultContentConfiguration()
        
        config.text = savedDevices[indexPath.row]
        cell.contentConfiguration = config
    
        return cell
    }
}

