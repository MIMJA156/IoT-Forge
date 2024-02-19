//
//  DataHelper.swift
//  IoT-Forge
//
//  Created by Mizia, Miles - Student on 2/17/24.
//

class DataHelper {
    static let shared = DataHelper()
    
    private var mem_devices: [String] = []
    
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
                title: "My Cool Local Device",
                model: "XYZ-1001A",
                current_version: "01.00.00",
                description: "WOW! This device profile is stored locally."
            ),
            DeviceConfigurationProfile(
                title: "Another Local Device",
                model: "ABC-2002B",
                current_version: "02.01.01",
                description: nil
            ),
            DeviceConfigurationProfile(
                title: "Additional Local Device",
                model: "GHI-4004D",
                current_version: "04.03.03",
                description: "No way, this one is also stored locally? How cool! Although I wish we had more than three local devices."
            ),
        ]
    }
    
    func getCloudDeviceConfigurationProfiles() -> [DeviceConfigurationProfile] {
        return [
            DeviceConfigurationProfile(
                title: "External Device",
                model: "DEF-3003C",
                current_version: "03.02.02",
                description: "This device profile was downloaded from the cloud!"
            )
        ]
    }
}
