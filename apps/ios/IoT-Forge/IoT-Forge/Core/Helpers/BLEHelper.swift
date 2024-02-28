//
//  BLEHelper.swift
//  IoT-Forge
//
//  Created by Mizia, Miles - Student on 2/17/24.
//

import CoreBluetooth

protocol BLEManagerDelegate: AnyObject {
    func centralManagerDidUpdateState(_ central: CBCentralManager)
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber)
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral)
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?)
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?)
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?)
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?)
}

class BLEManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    static let shared = BLEManager()
    
    private var central: CBCentralManager!
    var peripheral: CBPeripheral?
    
    private weak var _delegate: BLEManagerDelegate?
    
    weak var delegate: BLEManagerDelegate? {
        get {
            return _delegate
        }
        
        set {
            _delegate = newValue
            delegate?.centralManagerDidUpdateState(central)
        }
    }
    
    private override init() {
        super.init()
        central = CBCentralManager(delegate: self, queue: nil)
    }
    
    //--
    
    func write(data: Foundation.Data, cbuuid: CBUUID) -> Bool {
        if let services = peripheral?.services {
            for service in services {
                if let characteristics = service.characteristics {
                    for characteristic in characteristics {
                        if characteristic.uuid == cbuuid {
                            peripheral?.writeValue(data, for: characteristic, type: .withResponse)
                            return true
                        }
                    }
                }
            }
        }
        
        return false
    }
    
    func read(cbuuid: CBUUID) -> Bool {
        if let services = peripheral?.services {
            for service in services {
                if let characteristics = service.characteristics {
                    for characteristic in characteristics {
                        if characteristic.uuid == cbuuid {
                            peripheral?.readValue(for: characteristic)
                            return true
                        }
                    }
                }
            }
        }
        
        return false
    }
    
    func scan(with: [CBUUID]?) {
        central.scanForPeripherals(withServices: with)
    }
    
    func connect(peripheral: CBPeripheral) {
        peripheral.delegate = self
        self.peripheral = peripheral
        central.connect(peripheral)
    }
    
    func disconnect() {
        if let peripheral = peripheral { central.cancelPeripheralConnection(peripheral) }
        peripheral = nil
    }
    
    //--
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        delegate?.centralManagerDidUpdateState(central)
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        delegate?.centralManager(central, didDiscover: peripheral, advertisementData: advertisementData, rssi: RSSI)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        delegate?.centralManager(central, didConnect: peripheral)
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        delegate?.centralManager(central, didDisconnectPeripheral: peripheral, error: error)
    }
        
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        delegate?.peripheral(peripheral, didDiscoverServices: error)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        delegate?.peripheral(peripheral, didDiscoverCharacteristicsFor: service, error: error)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        delegate?.peripheral(peripheral, didUpdateValueFor: characteristic, error: error)
    }
}
