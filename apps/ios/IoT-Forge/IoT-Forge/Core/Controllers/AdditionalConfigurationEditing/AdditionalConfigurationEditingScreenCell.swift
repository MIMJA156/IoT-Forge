//
//  AdditionalConfigurationEditingScreenCell.swift
//  IoT-Forge
//
//  Created by Mizia, Miles - Student on 2/23/24.
//

import UIKit
import SwiftyJSON

class AdditionalConfigurationEditingScreenCell: UITableViewCell {
    static let height: CGFloat = 45
    
    private let textFeild = UITextField()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildUI()
        setupSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        buildUI()
        setupSubviews()
    }
    
    private func buildUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        
        textFeild.translatesAutoresizingMaskIntoConstraints = false
        textFeild.clearButtonMode = .whileEditing
        textFeild.autocapitalizationType = .none
        textFeild.borderStyle = .roundedRect
        textFeild.returnKeyType = .done
    }

    private func setupSubviews() {
        contentView.addSubview(textFeild)
        
        NSLayoutConstraint.activate([
            textFeild.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            textFeild.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor),
            textFeild.leftAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leftAnchor, constant: 10),
            textFeild.rightAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.rightAnchor, constant: -10),
        ])
    }
    
    func getField() -> UITextField {
        return textFeild
    }
    
    func configure(with: JSON) {
        switch with["type"].string {
        case "string":
            let value = with["value"].string
            if value != nil { textFeild.text = value }
            break
        
        case "integer":
            let value = with["value"].string
            if value != nil { textFeild.text = "\(value!)" }
            
            textFeild.keyboardType = .numbersAndPunctuation
            break
            
        default:
            break
        }
    }
}
