//
//  DeviceProfileCell.swift
//  IoT-Forge
//
//  Created by Mizia, Miles - Student on 2/17/24.
//

import UIKit
import SwiftyJSON

class DeviceConfigurationProfileCell: UITableViewCell {
    private let titleLabel = UILabel()
    private let modelLabel = UILabel()

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
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        
        modelLabel.translatesAutoresizingMaskIntoConstraints = false
        modelLabel.font = UIFont.systemFont(ofSize: 14)
    }

    private func setupSubviews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(modelLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            modelLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            modelLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            modelLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])
    }

    func configure(with profile: JSON) {
        titleLabel.text = profile["name"].string
        modelLabel.text = "Model: \(profile["model"].string!)"
    }
}
