//
//  DetailedExploreInfoTitle.swift
//  IoT-Forge
//
//  Created by Mizia, Miles - Student on 2/18/24.
//

import UIKit

class DetailedExploreInfoHeader: UITableViewHeaderFooterView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        return label
    }()
    
    private let modelLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        return label
    }()
    
    private let versionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    private let createButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setTitle("Add", for: .normal)
        button.setTitleColor(.label, for: .normal)
        
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .regular)
        button.backgroundColor = .systemGray5
        
        button.layer.cornerRadius = 5
        button.layer.borderColor = .some(UIColor.black.cgColor)
        button.layer.borderWidth = 1
        
        return button
    }()
    private var buttonCallback: ((_ sender: UIButton) -> ())!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubviews()
    }

    private func setupSubviews() {
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(modelLabel)
        addSubview(versionLabel)
        addSubview(createButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            descriptionLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            descriptionLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
            
            modelLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 22),
            modelLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            modelLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
            
            versionLabel.topAnchor.constraint(equalTo: modelLabel.bottomAnchor, constant: 8),
            versionLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            versionLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
            
            createButton.topAnchor.constraint(equalTo: versionLabel.bottomAnchor, constant: 20),
            createButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            createButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
            createButton.heightAnchor.constraint(equalToConstant: 45),
            createButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
        ])
    }
    
    func configure(with profile: DeviceConfigurationProfile, add addCallback: @escaping (_ sender: UIButton) -> ()) {
        buttonCallback = addCallback
        
        createButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        createButton.addTarget(self, action: #selector(animateButtonOnTouchDown), for: .touchDown)
        
        createButton.addTarget(
            self, action: #selector(animateButtonOnTouchUp),
            for: [.touchUpInside, .touchUpOutside, .touchCancel]
        )
        
        titleLabel.text = profile.title
        modelLabel.text = "Model: \(profile.model)"
        versionLabel.text = "Version: \(profile.current_version)"
        
        if profile.description != nil {
            descriptionLabel.text = profile.description
        } else {
            descriptionLabel.font = .italicSystemFont(ofSize: 16)
            descriptionLabel.text = "no description"
        }
    }

    @objc func buttonPressed(sender: UIButton) {
        buttonCallback(sender)
    }

    @objc func animateButtonOnTouchDown(sender: UIButton) {
        sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        sender.backgroundColor = .systemGray4
    }

    @objc func animateButtonOnTouchUp(sender: UIButton) {
        UIView.animate(withDuration: 0.2) {
            sender.transform = .identity
            sender.backgroundColor = .systemGray5
        }
    }
}
