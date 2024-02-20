//
//  InitailConfigurationScreen.swift
//  IoT-Forge
//
//  Created by Mizia, Miles - Student on 2/19/24.
//

import UIKit
import CoreBluetooth

class InitialConfigurationScreen: UIViewController, BLEManagerDelegate {
    var selectedDeviceProfile: DeviceConfigurationProfile!
    var token: UInt32!
    
    let ble = BLEManager.shared
    
    override func viewWillAppear(_ animated: Bool) {
        ble.delegate = self
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Cancel",
            image: nil,
            target: self,
            action: #selector(backButtonClicked)
        )
        
        print("profile -> \n \(selectedDeviceProfile.title)\n \(selectedDeviceProfile.description ?? "nil")\n \(selectedDeviceProfile.model)\n \(selectedDeviceProfile.version)\n \(token ?? 0)")
    }
    
    @objc func backButtonClicked() {
        ble.disconnect()
        navigationController?.popToViewController((navigationController?.viewControllers[2])!, animated: true)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {}
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {}
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {}
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {}
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {}
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {}
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {}
}
