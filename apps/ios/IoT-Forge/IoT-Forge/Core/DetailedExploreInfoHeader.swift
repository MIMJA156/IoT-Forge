//
//  DetailedExploreInfoTitle.swift
//  IoT-Forge
//
//  Created by Mizia, Miles - Student on 2/18/24.
//

import UIKit

class DetailedExploreInfoHeader: UITableViewHeaderFooterView {
    private let titleLabel = UILabel()
    private let modelLabel = UILabel()
    private let versionLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    private let createButton = UIButton(type: .system)
    private var buttonCallback: ((_ sender: UIButton) -> ())!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
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
        titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        
        modelLabel.translatesAutoresizingMaskIntoConstraints = false
        modelLabel.font = UIFont.systemFont(ofSize: 16, weight: .light)
        
        versionLabel.translatesAutoresizingMaskIntoConstraints = false
        versionLabel.font = UIFont.systemFont(ofSize: 16, weight: .light)
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.font = .systemFont(ofSize: 16)
        descriptionLabel.numberOfLines = 0
        
        
        createButton.translatesAutoresizingMaskIntoConstraints = false
        
        createButton.setTitle("Add", for: .normal)
        createButton.setTitleColor(.label, for: .normal)
        
        createButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .regular)
        createButton.backgroundColor = .systemGray5
        
        createButton.layer.cornerRadius = 5
        createButton.layer.borderColor = .some(UIColor.black.cgColor)
        createButton.layer.borderWidth = 1
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
        versionLabel.text = "Version: \(profile.version)"
        
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
