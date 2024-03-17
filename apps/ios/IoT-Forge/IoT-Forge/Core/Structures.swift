//
//  Structures.swift
//  IoT-Forge
//
//  Created on 2/17/24.
//

import UIKit
import SwiftyJSON

class LocalSystem: UIViewController {
    var system: SystemContainer!
}

class SystemContainer {
    let profile: JSON
    var settings: JSON = JSON(parseJSON: "{}")
    
    init(profile: JSON) {
        self.profile = profile
    }
}

struct TableViewSection<T> {
    let title: String
    var data: [T]
}

let currentUserColorStyleInverse = UIColor { traitCollection in
    return traitCollection.userInterfaceStyle == .dark ? UIColor.white : UIColor.black
}
