//
//  DataHelper.swift
//  IoT-Forge
//
//  Created by Mizia, Miles - Student on 2/17/24.
//

import CoreBluetooth

class DataHelper {
    static let shared = DataHelper()
    
    private var mem_devices: [DeviceConfigurationProfile] = []
    
    static let universalBLEUUID = CBUUID(string: "A25503A0-49CE-4821-A3F2-25D11DAB7188")
    static let authenticationBLEUUID = CBUUID(string: "E50D58B4-11F2-49C5-8D2A-D71F5A6CDE3F")
    
    func getSavedDevices() -> [DeviceConfigurationProfile] {
        return mem_devices
    }
    
    func addSavedDevices(new: DeviceConfigurationProfile) -> [DeviceConfigurationProfile] {
        mem_devices.append(new)
        return mem_devices
    }
    
    //--
    
    func getLocalDeviceConfigurationProfiles() -> [DeviceConfigurationProfile] {
        return [
            DeviceConfigurationProfile(
                title: "A Cool Local Device",
                model: "XYZ-1001A",
                version: "01.00.00",
                description: "WOW! This device profile is stored locally.",
                bluetooth: DeviceConfigurationProfileBluetooth(
                    pairing: "basic",
                    instructions: "Hold down the power button on the device until the light turns yellow (~2s) then release."
                ),
                settings: DeviceConfigurationProfileSettings(
                    additionalConfig: true,
                    structure: [
                        DeviceConfigurationProfileSettingsBoolean(
                            name: "Testing Boolean",
                            info: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut at auctor eros. Sed convallis nisl.",
                            value: nil),
                        
                        DeviceConfigurationProfileSettingsInteger(
                            name: "Testing Number",
                            info: nil,
                            value: nil),
                        
                        DeviceConfigurationProfileSettingsString(
                            name: "Testing String",
                            info: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut at auctor eros. Sed convallis nisl.",
                            value: nil),
                    ]
                )
            ),
            DeviceConfigurationProfile(
                title: "Another Local Device",
                model: "ABC-2002B",
                version: "02.01.01",
                description: nil,
                bluetooth: DeviceConfigurationProfileBluetooth(pairing: "basic", instructions: nil),
                settings: DeviceConfigurationProfileSettings(
                    additionalConfig: false,
                    structure: [
                        DeviceConfigurationProfileSettingsBoolean(
                            name: "My fun boolean",
                            value: false),
                        
                        DeviceConfigurationProfileSettingsInteger(
                            name: "Wow this is an int?",
                            info: "It even has a limit so you can only enter values within the correct range :3",
                            value: 50)
                    ]
                )
            ),
            DeviceConfigurationProfile(
                title: "Additional Local Device",
                model: "GHI-4004D",
                version: "04.03.03",
                description: "No way, this one is also stored locally? How cool! Although I wish we had more than three local devices.",
                bluetooth: DeviceConfigurationProfileBluetooth(
                    pairing: "basic",
                    instructions: "Please hold down the center button for 3 seconds then pull the nob out and twist it clockwise. Wait for three beeps (about 15s), once you hear the beeps, let go of the button and nob. Wait until the light stops bleanking and then do 15 jumping jacks and finally press the pairing button on the back of the device."
                ),
                settings: DeviceConfigurationProfileSettings(
                    additionalConfig: false,
                    structure: []
                )
            ),
        ]
    }
}
