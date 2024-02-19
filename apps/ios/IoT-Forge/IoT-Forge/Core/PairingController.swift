//
//  PairingController.swift
//  IoT-Forge
//
//  Created by Mizia, Miles - Student on 2/18/24.
//

import UIKit

class PairingController: UIViewController {
    let titleLabel = UILabel()
    let instructionsLabel = UILabel()

    var selectedDeviceProfile: DeviceConfigurationProfile!
    let indicator = BluetootSearchingIndicator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildUI()
        setupSubviews()
    }
    
    func buildUI() {
        view.backgroundColor = .systemBackground
        
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.text = "Searcing for Device"
        titleLabel.font = .systemFont(ofSize: 22, weight: .bold)
        
        
        instructionsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        if selectedDeviceProfile.bluetooth.instructions != nil {
            instructionsLabel.font = .systemFont(ofSize: 16)
            instructionsLabel.text = selectedDeviceProfile.bluetooth.instructions
        } else {
            instructionsLabel.font = .italicSystemFont(ofSize: 16)
            instructionsLabel.text = "no instructions"
        }
        
        instructionsLabel.textAlignment = .center
        instructionsLabel.numberOfLines = 0
    }
    
    func setupSubviews() {
        view.addSubview(titleLabel)
        view.addSubview(instructionsLabel)
        view.addSubview(indicator)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            
            instructionsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            instructionsLabel.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 16),
            instructionsLabel.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -16),
            
            indicator.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            indicator.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            indicator.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            indicator.heightAnchor.constraint(equalToConstant: 75),
        ])
    }
    
    override func viewDidLayoutSubviews() {
        indicator.setupLayers()
        indicator.startPulsing()
    }
}

// -- // -- // -- // -- // -- // -- //
// -- // -- // -- // -- // -- // -- //
// -- // -- // -- // -- // -- // -- //
// -- // -- // -- // -- // -- // -- //
// -- // -- // -- // -- // -- // -- //
// -- // -- // -- // -- // -- // -- //

class BluetootSearchingIndicator: UIView {
    private lazy var minCirlce = UIBezierPath(
        arcCenter: CGPoint(x: self.bounds.midX, y: self.bounds.midY),
        radius: animatedCircleMinRadius,
        startAngle: 0,
        endAngle: .pi * 2,
        clockwise: true
    )
    
    private lazy var maxCirlce = UIBezierPath(
        arcCenter: CGPoint(x: self.bounds.midX, y: self.bounds.midY),
        radius: animatedCircleMaxRadius,
        startAngle: 0,
        endAngle: .pi * 2,
        clockwise: true
    )
    
    private lazy var staticCircle = UIBezierPath(
        arcCenter: CGPoint(x: self.bounds.midX, y: self.bounds.midY),
        radius: staticCircleRadius,
        startAngle: 0,
        endAngle: .pi * 2,
        clockwise: true
    )
    
    private let pulsingCircleLayer = CAShapeLayer()
    private let staticCircleLayer = CAShapeLayer()
    private let bluetoothImageView = UIImageView(image: UIImage(named: "bluetooth"))
    
    private let animatedCircleMaxRadius: CGFloat = 200
    private let animatedCircleMinRadius: CGFloat = 25
    private let animationDuration: CGFloat = 2 // seconds
    private let bluetoothImageSize: CGFloat = 35
    
    private let staticCircleRadius: CGFloat = 25
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildUI()
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        buildUI()
        setupSubviews()
    }
    
    private func buildUI() {
        pulsingCircleLayer.fillColor = UIColor.systemBlue.cgColor
        pulsingCircleLayer.opacity = 0.25
        
        staticCircleLayer.fillColor = UIColor.systemBlue.cgColor
        staticCircleLayer.opacity = 0.5
        
        bluetoothImageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupSubviews() {
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(bluetoothImageView)
        
        NSLayoutConstraint.activate([
            bluetoothImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            bluetoothImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            bluetoothImageView.widthAnchor.constraint(equalToConstant: bluetoothImageSize),
            bluetoothImageView.heightAnchor.constraint(equalToConstant: bluetoothImageSize),
        ])
    }
    
    func setupLayers() {
        pulsingCircleLayer.path = minCirlce.cgPath
        layer.addSublayer(pulsingCircleLayer)
        
        staticCircleLayer.path = staticCircle.cgPath
        layer.addSublayer(staticCircleLayer)
    }
    
    func startPulsing() {
        let pulse = CABasicAnimation(keyPath: "path")
        pulse.duration = animationDuration
        pulse.fromValue = minCirlce.cgPath
        pulse.toValue = maxCirlce.cgPath
        pulse.timingFunction = CAMediaTimingFunction(name: .easeOut)
        pulse.repeatCount = .infinity
        
        let fade = CABasicAnimation(keyPath: "opacity")
        fade.duration = 1
        fade.fromValue = 0.25
        fade.toValue = 0
        fade.timingFunction = CAMediaTimingFunction(name: .easeOut)
        fade.beginTime = pulse.duration - fade.duration
        
        let group = CAAnimationGroup()
        group.animations = [pulse, fade]
        group.duration = animationDuration
        group.repeatCount = .infinity
        
        pulsingCircleLayer.add(group, forKey: "pulseAndFadeOut")
    }
}
