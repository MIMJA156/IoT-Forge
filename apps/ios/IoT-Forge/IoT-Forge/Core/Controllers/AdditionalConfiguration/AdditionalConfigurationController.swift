//
//  AdvancedConfigurationScreen.swift
//  IoT-Forge
//
//  Created by Mizia, Miles - Student on 2/21/24.
//

import UIKit
import CoreBluetooth
import SwiftyJSON

class AdditionalConfigurationController: UIViewController, UITableViewDelegate, UITableViewDataSource, BLEManagerDelegate {
    lazy var tableView: UITableView = {
        UITableView(frame: self.view.bounds, style: .grouped)
    }()
    let actionButton = UIButton(type: .system)
    
    var newSystem: NewSystemContainer!
    var settingsToSet: [JSON] = []
    
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
        
        let publicItems = newSystem.profile["settings"]["structure"]["publics"].arrayValue
        settingsToSet = pullAllUnsetRequiredSettings(layer: publicItems)
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
    
    func pullAllUnsetRequiredSettings(layer: [JSON]) -> [JSON] {
        var returnItems: [JSON] = []
        
        for item in layer {
            if item["type"].string == "section" {
                returnItems.append(contentsOf: pullAllUnsetRequiredSettings(layer: item["structure"].arrayValue))
            } else {
                if item["required"].boolValue && !item["default"].exists() {
                    returnItems.append(item)
                }
            }
        }
        
        return returnItems
    }
    
    func updateSettingsItem(id: String, new: JSON) {
        newSystem.settings[id] = new
        updateDoneButton()
    }
    
    func updateDoneButton() {
        var isGood = true
        
        for setting in settingsToSet {
            let val = newSystem.settings[setting["id"].stringValue]
            if !val.exists() { isGood = false; break }
        }
        
        if isGood { actionButton.isEnabled = true }
    }
    
    @objc func completionButtonClicked() {
        let _ = dataHelper.addSavedDevices(new: newSystem)
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return settingsToSet.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return settingsToSet[section]["info"].string
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let unkownSettingsItem = settingsToSet[indexPath.section]
        
        if unkownSettingsItem["type"] == "string" {
            return buildDefualtCellWithTittleAndContent(
                title: unkownSettingsItem["name"].string!,
                content: newSystem.settings[unkownSettingsItem["id"].stringValue].string,
                indexPath: indexPath
            )
        }
        
        if unkownSettingsItem["type"] == "integer" {
            let value = newSystem.settings[unkownSettingsItem["id"].stringValue].int32
            let content = value != nil ? "\(value!)" : nil
            
            return buildDefualtCellWithTittleAndContent(
                title: unkownSettingsItem["name"].string!,
                content: content,
                indexPath: indexPath
            )
        }
        
        if unkownSettingsItem["type"] == "boolean" {
            let cell = AdditionalConfigurationControllerBooleanCell()
            cell.configure(with: unkownSettingsItem)
            cell.didToggle = { (isOn) -> () in
                let index = indexPath.section
                let id = self.settingsToSet[index]["id"].stringValue
                self.updateSettingsItem(id: id, new: JSON(booleanLiteral: isOn))
            }
            return cell
        }
        
        return UITableViewCell()
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
        
        switch settingsToSet[indexPath.section]["type"].string {
        case "string", "integer":
            let nextView = AdditionalConfigurationEditingController()
            let settingToSet = settingsToSet[indexPath.section]
            
            nextView.selectedSetting = settingToSet
            nextView.currentValue = newSystem.settings[settingToSet["id"].stringValue]
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
