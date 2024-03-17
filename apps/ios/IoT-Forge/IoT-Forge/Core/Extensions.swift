//
//  Extensions.swift
//  IoT-Forge
//
//  Created on 2/27/24.
//

import UIKit

extension UInt32 {
    subscript(index: Int) -> UInt8 {
        // Ensure that the index is within the valid range for UInt32 (0-3)
        precondition(index < MemoryLayout<UInt32>.size, "Index out of bounds")

        // Get the byte offset based on the little-endian byte order
        let byteOffset = index * MemoryLayout<UInt8>.size

        // Extract the byte from the UInt32 value
        return UInt8(truncatingIfNeeded: (self >> UInt32(byteOffset * 8)) & 0xFF)
    }
}

extension UIImage {
  public static func pixel(ofColor color: UIColor) -> UIImage {
    let pixel = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)

    UIGraphicsBeginImageContext(pixel.size)
    defer { UIGraphicsEndImageContext() }

    guard let context = UIGraphicsGetCurrentContext() else { return UIImage() }

    context.setFillColor(color.cgColor)
    context.fill(pixel)

    return UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
  }
}
