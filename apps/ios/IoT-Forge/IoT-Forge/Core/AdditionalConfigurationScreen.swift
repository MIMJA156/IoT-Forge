//
//  AdvancedConfigurationScreen.swift
//  IoT-Forge
//
//  Created by Mizia, Miles - Student on 2/21/24.
//

import UIKit

class AdditionalConfigurationScreen: UIViewController, UITableViewDelegate, UITableViewDataSource {
    lazy var tableView: UITableView = {
        UITableView(frame: self.view.bounds, style: .grouped)
    }()
    
    var selectedDeviceProfile: DeviceConfigurationProfile!
    var unSetSettings: [DeviceConfigurationProfileSettingsGeneric] = []
    var unSetSettingsIndexMap: [Int] = []
    
    override func viewDidLoad() {
        buildUI()
        setupSubviews()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        var currentCount = 0
        for item in selectedDeviceProfile.settings.structure {
            let isNil = testForNilSetting(item: item)
            
            if isNil {
                unSetSettings.append(item)
                unSetSettingsIndexMap.append(currentCount)
            } else {
                currentCount += 1
            }
        }
    }
    
    func testForNilSetting(item: DeviceConfigurationProfileSettingsGeneric) -> Bool {
        switch item.type {
        case .string:
            let a = item as! DeviceConfigurationProfileSettingsString
            return a.value == nil
            
        case .integer:
            let a = item as! DeviceConfigurationProfileSettingsInteger
            return a.value == nil
            
        case .boolean:
            let a = item as! DeviceConfigurationProfileSettingsBoolean
            return a.value == nil
        }
    }
    
    func buildUI() {
        title = "Additional Configuration"
        view.backgroundColor = .systemBackground
        
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupSubviews() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
        ])
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return unSetSettings.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        unSetSettings[section].info
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        cell.accessoryType = .disclosureIndicator
        
        var config = cell.defaultContentConfiguration()
        let unkownSettingsItem = unSetSettings[indexPath.section]
        config.text = unkownSettingsItem.name
        
        switch unkownSettingsItem.type {
        case .string:
            let item = unkownSettingsItem as! DeviceConfigurationProfileSettingsString
            if item.value == nil {
                config.secondaryAttributedText = NSAttributedString(string: "required", attributes: [
                    .foregroundColor: UIColor.red
                ])
            } else {
                config.secondaryText = item.value!
            }
            break
            
        case .integer:
            let item = unkownSettingsItem as! DeviceConfigurationProfileSettingsInteger
            if item.value == nil {
                config.secondaryAttributedText = NSAttributedString(string: "required", attributes: [
                    .foregroundColor: UIColor.red
                ])
            } else {
                config.secondaryText = "\(item.value!)"
            }
            break
            
        case .boolean:
            let item = unkownSettingsItem as! DeviceConfigurationProfileSettingsBoolean
            if item.value == nil {
                config.secondaryAttributedText = NSAttributedString(string: "required", attributes: [
                    .foregroundColor: UIColor.red
                ])
            } else {
                config.secondaryText = "\(item.value!)"
            }
            break
        }
        
        cell.contentConfiguration = config
        return cell
    }
    
    func updateSettingsItem(index: Int, setting: DeviceConfigurationProfileSettingsGeneric) {
        unSetSettings[index] = setting
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextView = AdditionalConfigurationEditingScreen()
        nextView.selectedIndex = indexPath.section
        nextView.selectedSetting = unSetSettings[indexPath.section]
        navigationController?.pushViewController(nextView, animated: true)
    }
}
