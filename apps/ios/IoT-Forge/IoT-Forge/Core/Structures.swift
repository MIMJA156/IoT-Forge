//
//  Structures.swift
//  IoT-Forge
//
//  Created by Mizia, Miles - Student on 2/17/24.
//

struct TableViewSection<T> {
    let title: String
    var data: [T]
}

struct DeviceConfigurationProfile {
    let title: String
    let model: String
    let current_version: String
    let description: String?
    
    let bluetooth: DeviceConfigurationProfileBluetooth
}

struct DeviceConfigurationProfileBluetooth {
    let pairing: String
    let instructions: String?
}
