//
//  phrase-generator.swift
//  IoT-Forge
//
//  Created by Mizia, Miles - Student on 2/21/24.
//

import Foundation

func readFile(atPath filePath: String) -> String? {
    do {
        let fileURL = URL(fileURLWithPath: filePath)
        let fileData = try Data(contentsOf: fileURL)

        if let fileContent = String(data: fileData, encoding: .utf8) {
            return fileContent
        } else {
            print("Unable to convert data to string.")
            return nil
        }
    } catch {
        print("Error reading file: \(error)")
        return nil
    }
}

func parseAdjectivesIntoPhrase(count: Int) -> String? {
    let words = count
    
    let unSplitString = readFile(atPath: Bundle.main.resourcePath! +  "/english-adjectives.txt")
    let splitString = unSplitString?.split(separator: "\n")
    
    if splitString == nil { return nil }
    
    var phrase = ""
    for _ in 1...words {
        phrase += splitString![Int.random(in: 1...splitString!.count)] + "-"
    }
    phrase.removeLast()
    
    return phrase
}
