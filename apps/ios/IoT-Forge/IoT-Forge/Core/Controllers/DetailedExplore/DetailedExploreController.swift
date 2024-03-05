//
//  DetailedExploreController.swift
//  IoT-Forge
//
//  Created by Mizia, Miles - Student on 2/18/24.
//

import UIKit
import SwiftyJSON

class DetailedExploreController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var selectedDeviceConfigurationProfile: JSON!
    
    lazy var tableView: UITableView = {
        UITableView(frame: self.view.bounds, style: .grouped)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
        setupSubviews()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationItem.largeTitleDisplayMode = .never
    }
    
    func buildUI() {
        view.backgroundColor = .systemBackground
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delaysContentTouches = false
    }
    
    func setupSubviews() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
        ])
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.backgroundColor = .green
        
        return cell
    }
    
    func doSomeStuffWhenButtonGoYes(sender: UIButton) {
        let nextView = PairingController()
        nextView.selectedDeviceProfile = selectedDeviceConfigurationProfile
        navigationController?.pushViewController(nextView, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = DetailedExploreInfoHeader()
        
        header.configure(
            with: selectedDeviceConfigurationProfile,
            add: doSomeStuffWhenButtonGoYes
        )
        
        header.backgroundView = UIView()
        header.backgroundView?.backgroundColor = .systemBackground
        
        return header
    }
}
