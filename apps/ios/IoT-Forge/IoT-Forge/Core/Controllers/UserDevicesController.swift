//
//  ViewController.swift
//  IoT-Forge
//
//  Created by Mizia, Miles - Student on 2/17/24.
//

import UIKit
import SwiftyJSON

class UserDevicesController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    lazy var tableView: UITableView = {
        UITableView(frame: self.view.bounds, style: .plain)
    }()
    let noDevicesLabel = UILabel()
    let callToActionButton = UIButton(type: .system)
    
    var savedDevices = JSON(stringLiteral: "[]")
    
    let dataHelper = DataHelper.shared
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        savedDevices = dataHelper.getSavedDevices()
        tableView.reloadData()
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
        
        noDevicesLabel.text = "you have no devices"
        noDevicesLabel.font = .systemFont(ofSize: 22, weight: .light)
        
        
        callToActionButton.translatesAutoresizingMaskIntoConstraints = false
        callToActionButton.isHidden = true
        
        callToActionButton.setTitle("explore possible devices", for: .normal)
        callToActionButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .light)
        callToActionButton.addTarget(self, action: #selector(headToNewDeviceScreen), for: .touchUpInside)
    }
    
    func setupSubviews() {
        view.addSubview(tableView)
        view.addSubview(noDevicesLabel)
        view.addSubview(callToActionButton)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
            
            noDevicesLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            noDevicesLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            callToActionButton.topAnchor.constraint(equalTo: noDevicesLabel.bottomAnchor, constant: 5),
            callToActionButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
        ])
    }
    
    @objc func headToNewDeviceScreen() {
        navigationController?.pushViewController(ExploreDevicesController(), animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = savedDevices.count
        
        if count == 0 {
            noDevicesLabel.isHidden = false
            callToActionButton.isHidden = false
        } else {
            noDevicesLabel.isHidden = true
            callToActionButton.isHidden = true
        }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        var config = cell.defaultContentConfiguration()
        
        config.text = savedDevices[indexPath.row]["nickname"].string
        cell.contentConfiguration = config
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let nextView = dataHelper.modelToControllerInstance(model: savedDevices[indexPath.row]["model"].string!) {
            nextView.profile = savedDevices[indexPath.row]
            navigationController?.pushViewController(nextView, animated: true)
        }
    }
}
