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
        setupSubviews()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func buildUI() {
        title = "My Devices"
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Explore Devices",
            style: .done,
            target: self,
            action: #selector(headToNewDeviceScreen)
        )

        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        

        noDevicesLabel.translatesAutoresizingMaskIntoConstraints = false
        noDevicesLabel.isHidden = true
        
        noDevicesLabel.text = "You Have No Devices"
        noDevicesLabel.textAlignment = .center
    }
    
    func setupSubviews() {
        view.addSubview(tableView)
        view.addSubview(noDevicesLabel)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            
            noDevicesLabel.topAnchor.constraint(equalTo: view.topAnchor),
            noDevicesLabel.leftAnchor.constraint(equalTo: view.leftAnchor),
            noDevicesLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            noDevicesLabel.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
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

