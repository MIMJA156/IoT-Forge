//
//  AdvancedConfigurationScreen.swift
//  IoT-Forge
//
//  Created by Mizia, Miles - Student on 2/21/24.
//

import UIKit
import CoreBluetooth

class AdditionalConfigurationScreen: UIViewController, UITableViewDelegate, UITableViewDataSource, BLEManagerDelegate {
    lazy var tableView: UITableView = {
        UITableView(frame: self.view.bounds, style: .grouped)
    }()
    let actionButton = UIButton(type: .system)
    
    var selectedDeviceProfile: DeviceConfigurationProfile!
    var unSetSettings: [DeviceConfigurationProfileSettingsGeneric] = []
    var unSetSettingsIndexMap: [Int] = []
    
    let ble = BLEManager.shared
    let dataHelper = DataHelper.shared
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ble.delegate = self
        tableView.reloadData()
    }
    
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
            }
            
            currentCount += 1
        }
        
        setAllBooleansToFalse()
    }
    
    func buildUI() {
        title = "Additional Configuration"
        view.backgroundColor = .systemBackground
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Cancel",
            image: nil,
            target: self,
            action: #selector(backButtonClicked)
        )
        
        navigationItem.backButtonTitle = "Back"
        
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.addTarget(self, action: #selector(completionButtonClicked), for: .touchUpInside)
        
        let crossed = NSAttributedString(
            string: "Save",
            attributes: [
                NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue
            ]
        )
        actionButton.setAttributedTitle(crossed, for: .disabled)
        actionButton.setTitleColor(.label, for: .disabled)
        
        let normal = NSAttributedString(string: "Save")
        actionButton.setAttributedTitle(normal, for: .normal)
        actionButton.setTitleColor(.label, for: .normal)
        
        actionButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .regular)
        actionButton.backgroundColor = .systemGray5
        
        actionButton.layer.cornerRadius = 5
        actionButton.layer.borderColor = .some(UIColor.black.cgColor)
        actionButton.layer.borderWidth = 1
        
        actionButton.isEnabled = false
    }
    
    func setupSubviews() {
        view.addSubview(tableView)
        view.addSubview(actionButton)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            
            actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32),
            actionButton.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 16),
            actionButton.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -16),
            actionButton.heightAnchor.constraint(equalToConstant: 45),
        ])
    }
    
    func updateSettingsItem(index: Int, setting: DeviceConfigurationProfileSettingsGeneric) {
        unSetSettings[index] = setting
        updateDoneButton()
    }
    
    func setAllBooleansToFalse() {
        for (index, setting) in unSetSettings.enumerated() {
            switch setting.type {
            case .boolean:
                var item = (setting as! DeviceConfigurationProfileSettingsBoolean)
                item.value = false
                updateSettingsItem(index: index, setting: item)
                break
                
            default:
                break
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
    
    func updateDoneButton() {
        var isGood = true
        
        for setting in unSetSettings {
            switch setting.type {
            case .boolean:
                let value = (setting as! DeviceConfigurationProfileSettingsBoolean).value
                if value == nil { isGood = false }
                break
                
            case .integer:
                let value = (setting as! DeviceConfigurationProfileSettingsInteger).value
                if value == nil { isGood = false }
                break
                
            case .string:
                let value = (setting as! DeviceConfigurationProfileSettingsString).value
                if value == nil { isGood = false }
                break
            }
        }
        
        if isGood { actionButton.isEnabled = true }
    }
    
    @objc func completionButtonClicked() {
        mergeToFinal()
        let _ = dataHelper.addSavedDevices(new: selectedDeviceProfile)
        self.ble.disconnect()
        self.navigationController?.popToViewController(
            (self.navigationController?.viewControllers[0])!,
            animated: true
        )
    }
    
    @objc func backButtonClicked() {
        let alert = UIAlertController(title: "Cancel?", message: "Are you sure you want to cancel?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "no", style: .cancel))
        alert.addAction(UIAlertAction(title: "yes", style: .destructive, handler: { _ in
            self.ble.disconnect()
            self.navigationController?.popToViewController(
                (self.navigationController?.viewControllers[2])!,
                animated: true
            )
        }))
        
        present(alert, animated: true)
    }
    
    func mergeToFinal() {
        for (i, unSetSetting) in unSetSettings.enumerated() {
            let index = unSetSettingsIndexMap[i]
            selectedDeviceProfile.settings.structure[index] = unSetSetting
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return unSetSettings.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return unSetSettings[section].info
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let unkownSettingsItem = unSetSettings[indexPath.section]
        
        switch unkownSettingsItem.type {
        case .string:
            let item = unkownSettingsItem as! DeviceConfigurationProfileSettingsString
            return buildDefualtCellWithTittleAndContent(title: unkownSettingsItem.name, content: item.value, indexPath: indexPath)
            
        case .integer:
            let item = unkownSettingsItem as! DeviceConfigurationProfileSettingsInteger
            let content = item.value != nil ? "\(item.value!)" : nil
            return buildDefualtCellWithTittleAndContent(title: unkownSettingsItem.name, content: content, indexPath: indexPath)
            
        case .boolean:
            let cell = AdditionalConfigurationScreenBooleanCell()
            cell.configure(with: unkownSettingsItem)
            cell.didToggle = { (isOn) -> () in
                let index = indexPath.section
                var selected = self.unSetSettings[index] as! DeviceConfigurationProfileSettingsBoolean
                selected.value = isOn
                self.updateSettingsItem(index: index, setting: selected)
            }
            return cell
        }
    }
    
    func buildDefualtCellWithTittleAndContent(title: String, content: String?, indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        cell.accessoryType = .disclosureIndicator
        
        var config = cell.defaultContentConfiguration()
        config.text = title
        
        if content == nil {
            config.secondaryAttributedText = NSAttributedString(string: "required", attributes: [
                .foregroundColor: UIColor.red
            ])
        } else {
            config.secondaryText = content
        }
        
        cell.contentConfiguration = config
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch unSetSettings[indexPath.section].type {
        case .string, .integer:
            let nextView = AdditionalConfigurationEditingScreen()
            
            nextView.selectedIndex = indexPath.section
            nextView.selectedSetting = unSetSettings[indexPath.section]
            nextView.updateFunction = self.updateSettingsItem
            
            navigationController?.pushViewController(nextView, animated: true)
            break
            
        default:
            break
        }
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {}
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {}
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {}
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {}
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {}
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {}
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {}
}
