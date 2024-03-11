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
        
        ble.delegate = self
        
        title = system.settings["#name"].string
        
        let textView1 = UITextView()
        textView1.text = system.profile.description
        textView1.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height / 2)
        textView1.layer.borderWidth = 1.0
        textView1.layer.borderColor = UIColor.black.cgColor
        
        let textView2 = UITextView()
        textView2.text = system.settings.description
        textView2.frame = CGRect(x: 0, y: view.bounds.height / 2, width: view.bounds.width, height: view.bounds.height / 4)
        textView2.layer.borderWidth = 1.0
        textView2.layer.borderColor = UIColor.black.cgColor
        
        let actionView = UIView()
        actionView.backgroundColor = .systemBackground
        actionView.frame = CGRect(x: 0, y: view.bounds.height * 3 / 4, width: view.bounds.width, height: view.bounds.height / 4)
        actionView.layer.borderWidth = 1.0
        actionView.layer.borderColor = UIColor.black.cgColor
        
        let button1 = UIButton()
        button1.setTitle("Toggle LED", for: .normal)
        button1.setBackgroundImage(.pixel(ofColor: .systemBlue), for: .normal)
        button1.translatesAutoresizingMaskIntoConstraints = false
        button1.addTarget(self, action: #selector(flashLEDFunc), for: .touchUpInside)
        
        actionView.addSubview(button1)
        
        NSLayoutConstraint.activate([
            button1.widthAnchor.constraint(equalToConstant: 200),
            button1.heightAnchor.constraint(equalToConstant: 50),
            button1.centerXAnchor.constraint(equalTo: actionView.centerXAnchor),
            button1.centerYAnchor.constraint(equalTo: actionView.centerYAnchor)
        ])
        
        view.addSubview(textView1)
        view.addSubview(textView2)
        view.addSubview(actionView)
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
            
            if (pulledModel == system.profile["model"].string) {
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
                         system.settings["#token"].uInt32![0],
                         system.settings["#token"].uInt32![1],
                         system.settings["#token"].uInt32![2],
                         system.settings["#token"].uInt32![3]]),
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
