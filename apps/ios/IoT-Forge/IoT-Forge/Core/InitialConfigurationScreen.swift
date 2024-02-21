//
//  InitailConfigurationScreen.swift
//  IoT-Forge
//
//  Created by Mizia, Miles - Student on 2/19/24.
//

import UIKit
import CoreBluetooth

class InitialConfigurationScreen: UIViewController, BLEManagerDelegate, UITextFieldDelegate {
    let titleLabel = UILabel()
    let instructionsLabel = UILabel()
    let nameTextField = UITextField()
    let nextButton = UIButton(type: .system)
    
    var selectedDeviceProfile: DeviceConfigurationProfile!
    var token: UInt32!
    
    let ble = BLEManager.shared
    
    override func viewWillAppear(_ animated: Bool) {
        ble.delegate = self
        nameTextField.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
        setupSubviews()
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
        nameTextField.placeholder = parseAdjectivesIntoPhrase(count: 2) ?? "some-random-filler"
        nameTextField.textAlignment = .center
        nameTextField.borderStyle = .roundedRect
        
        nameTextField.returnKeyType = .done
        nameTextField.autocapitalizationType = .none
        
        
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        
        nextButton.setTitle("Save", for: .normal)
        nextButton.setTitleColor(.label, for: .normal)
        
        nextButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .regular)
        nextButton.backgroundColor = .systemGray5
        
        nextButton.layer.cornerRadius = 5
        nextButton.layer.borderColor = .some(UIColor.black.cgColor)
        nextButton.layer.borderWidth = 1
    }
    
    func setupSubviews() {
        view.addSubview(titleLabel)
        view.addSubview(instructionsLabel)
        view.addSubview(nameTextField)
        view.addSubview(nextButton)
        
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
            
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32),
            nextButton.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 16),
            nextButton.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -16),
            nextButton.heightAnchor.constraint(equalToConstant: 45),
        ])
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
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {}
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {}
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {}
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {}
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {}
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {}
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {}
}

// oh cool, will probably remove later
extension UITextField {
    func underlined(color: UIColor){
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}
