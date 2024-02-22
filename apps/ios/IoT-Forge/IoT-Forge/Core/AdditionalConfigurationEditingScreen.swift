//
//  AdditionalConfigurationEditingScreen.swift
//  IoT-Forge
//
//  Created by Mizia, Miles - Student on 2/21/24.
//

import UIKit

class AdditionalConfigurationEditingScreen: UIViewController {
    var selectedSetting: DeviceConfigurationProfileSettingsGeneric!
    var selectedIndex: Int!
    
    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        
        print("HELLO!")
        print(selectedSetting)
        print(selectedIndex)
    }
}
