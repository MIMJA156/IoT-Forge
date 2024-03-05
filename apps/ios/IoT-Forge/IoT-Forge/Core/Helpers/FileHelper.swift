//
//  FileHelper.swift
//  IoT-Forge
//
//  Created by Mizia, Miles - Student on 3/4/24.
//

import Foundation
import SwiftyJSON

class FileHelper {
    static func getLocalDevicesJson() -> JSON {
        let filePath = Bundle.main.path(forResource: "Devices", ofType: "json")!
        
        do {
            let contents = try String(contentsOfFile: filePath, encoding: .utf8)
            return JSON(parseJSON: contents)
        } catch {
            fatalError("Error reading file: \(error.localizedDescription)")
        }
    }
}
