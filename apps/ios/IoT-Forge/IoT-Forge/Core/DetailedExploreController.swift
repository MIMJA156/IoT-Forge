//
//  DetailedExploreController.swift
//  IoT-Forge
//
//  Created by Mizia, Miles - Student on 2/18/24.
//

import UIKit

class DetailedExploreController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var selectedDeviceConfigurationProfile: DeviceConfigurationProfile!
    
    lazy var tableView: UITableView = {
        UITableView(frame: self.view.bounds, style: .grouped)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationItem.largeTitleDisplayMode = .never
    }
    
    func buildUI() {
        // BEGIN - MAIN VIEW
        view.backgroundColor = .systemBackground
        // END - MAIN VIEW
        
        // BEGIN - tableView
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        // END - tableView
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
