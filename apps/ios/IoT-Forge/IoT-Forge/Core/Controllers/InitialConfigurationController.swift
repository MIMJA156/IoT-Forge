//
//  InitailConfigurationScreen.swift
//  IoT-Forge
//
//  Created on 2/19/24.
//

import UIKit
import CoreBluetooth
import SwiftyJSON

class InitialConfigurationController: UIViewController, BLEManagerDelegate, UITextFieldDelegate {
    let titleLabel = UILabel()
    let instructionsLabel = UILabel()
    let nameTextField = UITextField()
    let actionButton = UIButton(type: .system)
    
    var newSystem: SystemContainer!
    var nickname: String!
    var requiresAdditionalConfig = false
    
    let ble = BLEManager.shared
    let dataHelper = DataHelper.shared
    
    override func viewWillAppear(_ animated: Bool) {
        ble.delegate = self
        nameTextField.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
        setupSubviews()
        
        let publicItems = newSystem.profile["settings"]["structure"]["publics"].arrayValue
        requiresAdditionalConfig = doesRequireAdditionalConfig(layer: publicItems)
        
        if requiresAdditionalConfig {
            actionButton.setTitle("Next", for: .normal)
        }
    }
    
    func buildUI() {
        view.backgroundColor = .systemBackground
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Cancel",
            image: nil,
            target: self,
            action: #selector(backButtonClicked)
        )
        
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Name your Device"
        titleLabel.font = .systemFont(ofSize: 22, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        
        
        instructionsLabel.translatesAutoresizingMaskIntoConstraints = false
        instructionsLabel.text = "If left empty, the device name will default to the placeholder."
        instructionsLabel.font = .systemFont(ofSize: 16)
        instructionsLabel.textAlignment = .center
        instructionsLabel.numberOfLines = 0
        
        
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.placeholder = getRandomAdjectivePhrase(words: 3)
        nameTextField.textAlignment = .center
        nameTextField.borderStyle = .roundedRect
        
        nameTextField.returnKeyType = .done
        nameTextField.autocapitalizationType = .none
        
        
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.addTarget(self, action: #selector(completionButtonClicked), for: .touchUpInside)
        
        actionButton.setTitle("Save", for: .normal)
        actionButton.setTitleColor(.label, for: .normal)
        
        actionButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .regular)
        actionButton.backgroundColor = .systemGray5
        
        actionButton.layer.cornerRadius = 5
        actionButton.layer.borderColor = .some(UIColor.black.cgColor)
        actionButton.layer.borderWidth = 1
    }
    
    func setupSubviews() {
        view.addSubview(titleLabel)
        view.addSubview(instructionsLabel)
        view.addSubview(nameTextField)
        view.addSubview(actionButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            
            instructionsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            instructionsLabel.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 16),
            instructionsLabel.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -16),
            
            nameTextField.topAnchor.constraint(equalTo: instructionsLabel.bottomAnchor, constant: 32),
            nameTextField.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 32),
            nameTextField.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -32),
            nameTextField.heightAnchor.constraint(equalToConstant: 40),
            
            actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32),
            actionButton.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 16),
            actionButton.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -16),
            actionButton.heightAnchor.constraint(equalToConstant: 45),
        ])
    }
    
    func doesRequireAdditionalConfig(layer: [JSON]) -> Bool {
        for item in layer {
            if item["type"].string == "section" {
                if doesRequireAdditionalConfig(layer: item["structure"].arrayValue) { return true }
            }
            else {
                if item["required"].boolValue && !item["default"].exists() { return true }
            }
        }
        
        return false
    }
    
    func getRandomAdjectivePhrase(words: Int) -> String {
        let adjectivesList = FileHelper.getEnglishAdjectivesList()
        
        var sentence = ""
        for _ in 1...words {
            sentence += adjectivesList[Int.random(in: 1...(adjectivesList.count - 1))] + "-"
        }
        sentence.removeLast()
        
        return sentence
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        return false
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
    
    func pullDefaultSettings(layer: [JSON]) {
        for item in layer {
            if item["type"].string == "section" { pullDefaultSettings(layer: item["structure"].arrayValue) }
            else {
                if item["default"].exists() {
                    newSystem.settings[item["id"].stringValue] = item["default"]
                }
            }
        }
    }
    
    @objc func completionButtonClicked() {
        var text: String!
        let name = getValidateName()
        
        if name == nil { text = nameTextField.placeholder }
        else { text = name }
        nickname = text
        
        newSystem.settings["#name"].string = nickname
        
        let publicItems = newSystem.profile["settings"]["structure"]["publics"].arrayValue
        pullDefaultSettings(layer: publicItems)
        
        let privateItems = newSystem.profile["settings"]["structure"]["privates"].arrayValue
        pullDefaultSettings(layer: privateItems)
        
        if requiresAdditionalConfig {
            let nextController = AdditionalConfigurationController()
            nextController.newSystem = newSystem
            navigationController?.pushViewController(nextController, animated: true)
        } else {
            let _ = dataHelper.addSavedDevices(new: newSystem)
            self.ble.disconnect()
            self.navigationController?.popToViewController(
                (self.navigationController?.viewControllers[0])!,
                animated: true
            )
        }
    }
    
    func getValidateName() -> String? {
        let text = nameTextField.text
        var result: String? = nil
        
        if text != "" && text != nil {
            result = text
        }
        
        return result
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {}
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {}
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {}
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {}
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {}
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {}
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {}
}
