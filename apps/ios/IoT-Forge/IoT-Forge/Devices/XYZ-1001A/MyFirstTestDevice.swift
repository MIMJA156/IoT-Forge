//
//  MyFirstTestDevice.swift
//  IoT-Forge
//
//  Created by Mizia, Miles - Student on 2/26/24.
//

import UIKit
import CoreBluetooth

class MyFirstTestDevice: LocalSystem, BLEManagerDelegate {
    private let textView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    let flashLED = UIButton(type: .system)
    
    let ble = BLEManager.shared
    var loadingAlert: UIAlertController?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showLoadingAlert()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        ble.disconnect()
        ble.delegate = nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .cyan
        title = profile.title
        
        ble.delegate = self
        
        buildUI()
        layoutSubviews()
        
        displayProfileText()
    }
    
    func buildUI() {
        textView.font = .systemFont(ofSize: 14)
        
        
        flashLED.translatesAutoresizingMaskIntoConstraints = false
        flashLED.addTarget(self, action: #selector(flashLEDFunc), for: .touchUpInside)
        
        flashLED.setTitle("Flash LED", for: .normal)
        flashLED.tintColor = .white
        flashLED.setBackgroundImage(.pixel(ofColor: .systemBlue), for: .normal)
    }

    func layoutSubviews() {
        view.addSubview(flashLED)
        view.addSubview(textView)
        
        NSLayoutConstraint.activate([
            flashLED.heightAnchor.constraint(equalToConstant: 50),
            flashLED.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            flashLED.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16),
            flashLED.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16),
            
            textView.topAnchor.constraint(equalTo: flashLED.bottomAnchor, constant: 16),
            textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            textView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16),
            textView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16),
        ])
    }

    private func displayProfileText() {
        let profile = createSampleDeviceConfigurationProfile()
        textView.text = textRepresentation(of: profile)
    }

    private func textRepresentation(of profile: DeviceConfigurationProfile) -> String {
        var result = ""

        result += "Nickname: \(profile.nickname ?? "N/A")\n"
        result += "Title: \(profile.title)\n"
        result += "Model: \(profile.model)\n"
        result += "Version: \(profile.version)\n"
        result += "Description: \(profile.description ?? "N/A")\n"
        result += "Bluetooth:\n"
        result += "  Token: \(profile.bluetooth.token ?? 0)\n"
        result += "  Pairing: \(profile.bluetooth.pairing)\n"
        result += "  Instructions: \(profile.bluetooth.instructions ?? "N/A")\n"
        result += "Settings:\n"
        result += "  Additional Config: \(profile.settings.additionalConfig)\n"
        result += "  Structure:\n"

        for setting in profile.settings.structure {
            switch setting.type {
            case .string:
                if let stringSetting = setting as? DeviceConfigurationProfileSettingsString {
                    result += "    Name: \(stringSetting.name)\n"
                    result += "      Type: String\n"
                    result += "      Value: \(String(describing: stringSetting.value))\n"
                }
            case .integer:
                if let integerSetting = setting as? DeviceConfigurationProfileSettingsInteger {
                    result += "    Name: \(integerSetting.name)\n"
                    result += "      Type: Integer\n"
                    result += "      Value: \(String(describing: integerSetting.value))\n"
                }
            case .boolean:
                if let booleanSetting = setting as? DeviceConfigurationProfileSettingsBoolean {
                    result += "    Name: \(booleanSetting.name)\n"
                    result += "      Type: Boolean\n"
                    result += "      Value: \(String(describing: booleanSetting.value))\n"
                }
            }
        }

        return result
    }

    private func createSampleDeviceConfigurationProfile() -> DeviceConfigurationProfile {
        return profile
    }
    
    @objc func flashLEDFunc() {
        let _ = ble.write(data: Data([3]), cbuuid: DataHelper.eventbusBLEUUID)
    }
    
    func showLoadingAlert() {
        loadingAlert = UIAlertController(title: nil, message: "Connecting...", preferredStyle: .alert)
        navigationController?.present(loadingAlert!, animated: true, completion: nil)
    }
    
    func dismissLoadingAlert(animated: Bool = true) {
        loadingAlert?.dismiss(animated: animated, completion: nil)
    }
    
    func showBadAuthAlert() {
        let alertController = UIAlertController(
            title: "Authentication Failed",
            message: nil,
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
        
        alertController.addAction(okAction)
        
        navigationController?.present(alertController, animated: true, completion: nil)
    }
    
    func showBLEDisconnectAlert() {
        let alertController = UIAlertController(
            title: "Lost Connection",
            message: nil,
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
        
        alertController.addAction(okAction)
        
        navigationController?.present(alertController, animated: true, completion: nil)
    }
    
    //-------------------------//
    //-------------------------//
    //----//---- BLE ----//----//
    //-------------------------//
    //-------------------------//
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOff, .unauthorized:
            print("bad ble")
        default:
            central.scanForPeripherals(withServices: [DataHelper.universalBLEUUID])
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let raw: [CBUUID: Data] = advertisementData["kCBAdvDataServiceData"] as! [CBUUID: Data]
        
        if let data = raw[DataHelper.universalBLEUUID] {
            let pulledModel = String(data: data[0...8], encoding: .ascii)
            
            if (pulledModel == profile.model) {
                ble.connect(peripheral: peripheral)
            }
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.discoverServices([DataHelper.universalBLEUUID])
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let services = peripheral.services {
            for service in services {
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let charecteristics = service.characteristics {
            for charecteristic in charecteristics {
                if charecteristic.uuid == DataHelper.authenticationBLEUUID {
                    peripheral.setNotifyValue(true, for: charecteristic)
                }
            }
            
            let success = ble.write(
                data:
                    Data(
                        [1,
                         profile.bluetooth.token![0],
                         profile.bluetooth.token![1],
                         profile.bluetooth.token![2],
                         profile.bluetooth.token![3]]),
                cbuuid: DataHelper.authenticationBLEUUID
            )
            print("simple auth - post token /", success)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if characteristic.uuid == DataHelper.authenticationBLEUUID {
            let value: [UInt8] = [UInt8](characteristic.value!)
            print("simple auth - success /", value[0] == 0 ? "false" : "true")
            
            if value[0] == 0 {
                dismissLoadingAlert(animated: false)
                showBadAuthAlert()
            } else if value[0] == 1 {
                dismissLoadingAlert()
            }
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        showBLEDisconnectAlert()
    }
}
