//
//  Structures.swift
//  IoT-Forge
//
//  Created by Mizia, Miles - Student on 2/17/24.
//

import UIKit
import SwiftyJSON

class LocalSystem: UIViewController {
    var profile: JSON!
}

enum DeviceConfigurationProfileSettingsTypes {
    case string
    case integer
    case boolean
}

struct TableViewSection<T> {
    let title: String
    var data: [T]
}

struct DeviceConfigurationProfile {
    var nickname: String?
    
    let title: String
    let model: String
    let version: String
    let description: String?
    
    var bluetooth: DeviceConfigurationProfileBluetooth
    var settings: DeviceConfigurationProfileSettings
}

struct DeviceConfigurationProfileBluetooth {
    var token: UInt32?
    
    let pairing: String
    let instructions: String?
}

struct DeviceConfigurationProfileSettings {
    let additionalConfig: Bool
    var structure: [DeviceConfigurationProfileSettingsGeneric]
}

protocol DeviceConfigurationProfileSettingsGeneric {
    var type: DeviceConfigurationProfileSettingsTypes { get }
    var name: String { get }
    var info: String? { get }
}

struct DeviceConfigurationProfileSettingsString: DeviceConfigurationProfileSettingsGeneric {
    var type: DeviceConfigurationProfileSettingsTypes = .string
    var name: String
    var info: String?
    
    var value: String?
}

struct DeviceConfigurationProfileSettingsInteger: DeviceConfigurationProfileSettingsGeneric {
    var type: DeviceConfigurationProfileSettingsTypes = .integer
    var name: String
    var info: String?
    
    var value: Int32?
}

struct DeviceConfigurationProfileSettingsBoolean: DeviceConfigurationProfileSettingsGeneric {
    var type: DeviceConfigurationProfileSettingsTypes = .boolean
    var name: String
    var info: String?
    
    var value: Bool?
}
