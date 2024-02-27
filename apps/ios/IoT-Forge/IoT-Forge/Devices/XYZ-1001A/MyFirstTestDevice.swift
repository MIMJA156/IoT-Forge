//
//  MyFirstTestDevice.swift
//  IoT-Forge
//
//  Created by Mizia, Miles - Student on 2/26/24.
//

import UIKit

class MyFirstTestDevice: LocalSystem {
    private let textView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .cyan
        
        setupTextView()
        displayProfileText()
    }

    private func setupTextView() {
        view.addSubview(textView)
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }

    private func displayProfileText() {
        let profile = createSampleDeviceConfigurationProfile()
        textView.text = textRepresentation(of: profile)
    }

    private func textRepresentation(of profile: DeviceConfigurationProfile) -> String {
        var result = ""

        result += "Nickname: \(profile.nickname ?? "N/A")\n"
        result += "Title: \(profile.title)\n"
        result += "Model: \(profile.model)\n"
        result += "Version: \(profile.version)\n"
        result += "Description: \(profile.description ?? "N/A")\n"
        result += "Bluetooth:\n"
        result += "  Token: \(profile.bluetooth.token ?? 0)\n"
        result += "  Pairing: \(profile.bluetooth.pairing)\n"
        result += "  Instructions: \(profile.bluetooth.instructions ?? "N/A")\n"
        result += "Settings:\n"
        result += "  Additional Config: \(profile.settings.additionalConfig)\n"
        result += "  Structure:\n"

        for setting in profile.settings.structure {
            switch setting.type {
            case .string:
                if let stringSetting = setting as? DeviceConfigurationProfileSettingsString {
                    result += "    Name: \(stringSetting.name), Type: String, Value: \(String(describing: stringSetting.value))\n"
                }
            case .integer:
                if let integerSetting = setting as? DeviceConfigurationProfileSettingsInteger {
                    result += "    Name: \(integerSetting.name), Type: Integer, Value: \(String(describing: integerSetting.value))\n"
                }
            case .boolean:
                if let booleanSetting = setting as? DeviceConfigurationProfileSettingsBoolean {
                    result += "    Name: \(booleanSetting.name), Type: Boolean, Value: \(String(describing: booleanSetting.value))\n"
                }
            }
        }

        return result
    }

    private func createSampleDeviceConfigurationProfile() -> DeviceConfigurationProfile {
        return profile
    }
}
