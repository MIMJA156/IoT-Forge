//
//  Structures.swift
//  IoT-Forge
//
//  Created by Mizia, Miles - Student on 2/17/24.
//

import UIKit
import SwiftyJSON

class LocalSystem: UIViewController {
    var system: NewSystemContainer!
}

class NewSystemContainer {
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
