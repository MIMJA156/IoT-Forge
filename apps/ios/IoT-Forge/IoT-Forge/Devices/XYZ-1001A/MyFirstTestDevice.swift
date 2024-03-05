//
//  MyFirstTestDevice.swift
//  IoT-Forge
//
//  Created by Mizia, Miles - Student on 2/26/24.
//

import UIKit
import CoreBluetooth
import SwiftyJSON

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
        title = profile["title"].string
        
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

    private func textRepresentation(of profile: JSON) -> String {
        var result = ""

        result += "Nickname: \(profile["nickname"].string ?? "N/A")\n"
        result += "Title: \(profile["title"].string!)\n"
        result += "Model: \(profile["model"].string!)\n"
        result += "Version: \(profile["version"].string!)\n"
        result += "Description: \(profile["description"].string ?? "N/A")\n"
        result += "Bluetooth:\n"
        result += "  Token: \(profile["bluetooth"]["token"].uInt32 ?? 0)\n" // finish changin the rest to use swift json
        result += "  Pairing: \(profile["bluetooth"]["pairing"].string ?? "N/A")\n"
        result += "  Instructions: \(profile["bluetooth"]["instructions"].string ?? "N/A")\n"
        result += "Settings:\n"
        result += "  Additional Config: \(profile["settings"]["additionalConfig"].bool!)\n"
        result += "  Structure:\n"

        for (_, setting) in profile["settings"]["structure"] {
            result += "    Name: \(setting["name"].string!)\n"
            result += "      Type: \(setting["type"].string!)\n"
            result += "      Value: \(String(describing: setting["value"]))\n"
        }

        return result
    }

    private func createSampleDeviceConfigurationProfile() -> JSON {
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
            
            if (pulledModel == profile["model"].string) {
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
                         profile["bluetooth"]["token"].uInt32![0],
                         profile["bluetooth"]["token"].uInt32![1],
                         profile["bluetooth"]["token"].uInt32![2],
                         profile["bluetooth"]["token"].uInt32![3]]),
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
