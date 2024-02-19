//
//  PairingController.swift
//  IoT-Forge
//
//  Created by Mizia, Miles - Student on 2/18/24.
//

import UIKit

class PairingController: UIViewController {
    var selectedDeviceProfile: DeviceConfigurationProfile!
    let generalRadius: CGFloat = 45
    let generalScaleFactor: CGFloat = 5
    
    private let circleLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.blue.cgColor
        layer.opacity = 0.25
        return layer
    }()
    
    private lazy var bluetoothCircle: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bluetooth")
        imageView.layer.cornerRadius = generalRadius
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
        
        let circlePath = UIBezierPath(
            arcCenter: view.center,
            radius: 1,
            startAngle: 0,
            endAngle: 2 * .pi,
            clockwise: true
        )

        circleLayer.path = circlePath.cgPath
        view.layer.addSublayer(circleLayer)
        
        animatePulsatingCircle()
        
        view.addSubview(bluetoothCircle)
        bluetoothCircle.translatesAutoresizingMaskIntoConstraints = false
        bluetoothCircle.heightAnchor.constraint(equalToConstant: generalRadius * 2).isActive = true
        bluetoothCircle.widthAnchor.constraint(equalToConstant: generalRadius * 2).isActive = true
        bluetoothCircle.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        bluetoothCircle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func buildUI() {
        // BEGIN - MAIN VIEW
        view.backgroundColor = .systemBackground
        // END - MAIN VIEW
    }
    
    private func animatePulsatingCircle() {
        let pulseAnimation = CABasicAnimation(keyPath: "path")
        pulseAnimation.duration = 3.0
        pulseAnimation.fromValue = circleLayer.path
        pulseAnimation.toValue = scaledPath()
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        pulseAnimation.repeatCount = .infinity

        let fadeOutAnimation = CABasicAnimation(keyPath: "opacity")
        fadeOutAnimation.duration = 1.0
        fadeOutAnimation.fromValue = 0.25
        fadeOutAnimation.toValue = 0.0
        fadeOutAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        fadeOutAnimation.beginTime = pulseAnimation.duration - fadeOutAnimation.duration

        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [pulseAnimation, fadeOutAnimation]
        groupAnimation.duration = 3.0
        groupAnimation.repeatCount = .infinity

        circleLayer.add(groupAnimation, forKey: "pulseAndFadeOut")
    }
    
    private func scaledPath() -> CGPath {
        let circleRadius: CGFloat = generalRadius * generalScaleFactor

        let scaledPath = UIBezierPath(arcCenter: view.center, radius: circleRadius, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        
        return scaledPath.cgPath
    }
}
