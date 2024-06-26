//
//  AdditionalConfigurationScreenBooleanCell.swift
//  IoT-Forge
//
//  Created on 2/24/24.
//

import UIKit
import SwiftyJSON

class AdditionalConfigurationControllerBooleanCell: UITableViewCell {
    private let title = UILabel()
    private let toggle = UISwitch()
    
    var didToggle: (Bool)->() = { (isOn)->() in }
    
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
        selectionStyle = .none
        
        
        title.translatesAutoresizingMaskIntoConstraints = false
        
        
        toggle.translatesAutoresizingMaskIntoConstraints = false
        toggle.addTarget(self, action: #selector(didToggleSwitch), for: .valueChanged)
    }

    private func setupSubviews() {
        contentView.addSubview(title)
        contentView.addSubview(toggle)
        
        NSLayoutConstraint.activate([
            title.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            title.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            
            toggle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            toggle.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
        ])
    }
    
    func configure(with: JSON, value: JSON) {
        if with["type"] == "boolean" {
            title.text = with["name"].string
            toggle.isOn = value.boolValue
        }
    }
    
    @objc func didToggleSwitch(sender: UISwitch) {
        didToggle(sender.isOn)
    }
}
