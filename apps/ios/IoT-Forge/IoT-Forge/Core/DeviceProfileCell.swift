//
//  DeviceProfileCell.swift
//  IoT-Forge
//
//  Created by Mizia, Miles - Student on 2/17/24.
//

import UIKit

class DeviceConfigurationProfileCell: UITableViewCell {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()

    private let modelLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()

    private let versionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubviews()
    }

    private func setupSubviews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(modelLabel)
        contentView.addSubview(versionLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            modelLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            modelLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            modelLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            versionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            versionLabel.leadingAnchor.constraint(equalTo: modelLabel.trailingAnchor, constant: 10),
            versionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])
    }

    func configure(with profile: DeviceConfigurationProfile) {
        titleLabel.text = profile.title
        modelLabel.text = "Model: \(profile.model)"
        versionLabel.text = "Version: \(profile.current_version)"
    }
}
