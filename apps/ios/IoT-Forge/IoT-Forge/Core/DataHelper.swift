//
//  DataHelper.swift
//  IoT-Forge
//
//  Created by Mizia, Miles - Student on 2/17/24.
//

import CoreBluetooth

class DataHelper {
    static let shared = DataHelper()
    
    private var mem_devices: [String] = []
    
    static let universalBLEUUID = CBUUID(string: "A25503A0-49CE-4821-A3F2-25D11DAB7188")
    
    func getSavedDevices() -> [String] {
        return mem_devices
    }
    
    func addSavedDevices(new: String) -> [String] {
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
                    instructions: "Hold down the power button until the light turns yellow (5s) then release."
                )
            ),
            DeviceConfigurationProfile(
                title: "Another Local Device",
                model: "ABC-2002B",
                version: "02.01.01",
                description: nil,
                bluetooth: DeviceConfigurationProfileBluetooth(pairing: "basic", instructions: nil)
            ),
            DeviceConfigurationProfile(
                title: "Additional Local Device",
                model: "GHI-4004D",
                version: "04.03.03",
                description: "No way, this one is also stored locally? How cool! Although I wish we had more than three local devices.",
                bluetooth: DeviceConfigurationProfileBluetooth(
                    pairing: "basic",
                    instructions: "Please hold down the center button for 3 seconds then pull the nob out and twist it clockwise. Wait for three beeps (about 15s), once you hear the beeps, let go of the button and nob. Wait until the light stops bleanking and then do 15 jumping jacks and finally press the pairing button on the back of the device."
                )
            ),
        ]
    }
    
    func getCloudDeviceConfigurationProfiles() -> [DeviceConfigurationProfile] {
        return [
            DeviceConfigurationProfile(
                title: "External Device",
                model: "DEF-3003C",
                version: "03.02.02",
                description: "This device profile was downloaded from the cloud!",
                bluetooth: DeviceConfigurationProfileBluetooth(pairing: "basic", instructions: nil)
            )
        ]
    }
}
