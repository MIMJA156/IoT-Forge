//
//  DataHelper.swift
//  IoT-Forge
//
//  Created by Mizia, Miles - Student on 2/17/24.
//

import CoreBluetooth
import UIKit
import SwiftyJSON

class DataHelper {
    static let shared = DataHelper()
    
    private var mem_devices = JSON(parseJSON: "[]")
    private var modelToControllerMap: [String: LocalSystem.Type] = [
        "XYZ-1001A": MyFirstTestDevice.self
    ]
    
    static let universalBLEUUID = CBUUID(string: "A25503A0-49CE-4821-A3F2-25D11DAB7188")
    static let authenticationBLEUUID = CBUUID(string: "E50D58B4-11F2-49C5-8D2A-D71F5A6CDE3F")
    static let eventbusBLEUUID = CBUUID(string: "389E5355-6224-4134-9257-062BEB5B67B3")
    
    func getSavedDevices() -> JSON {
        return mem_devices
    }
    
    func addSavedDevices(new: JSON) -> JSON {
        mem_devices.arrayObject?.append(new)
        return mem_devices
    }
    
    func modelToControllerInstance(model: String) -> LocalSystem? {
        if let controller = modelToControllerMap[model] {
            return controller.init()
        }
        
        return nil
    }
    
    //--
    
    func getLocalDeviceConfigurationProfiles() -> JSON {
        return FileHelper.getLocalDevicesJson()
    }
}
