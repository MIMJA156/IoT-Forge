//
//  PairingController.swift
//  IoT-Forge
//
//  Created on 2/18/24.
//

import UIKit
import CoreBluetooth
import SwiftyJSON

class PairingController: UIViewController, BLEManagerDelegate {
    let titleLabel = UILabel()
    let instructionsLabel = UILabel()
    let indicator = BluetootSearchingIndicator()
    
    var token: UInt32!
    var newSystem: SystemContainer!
    
    let pairingAlert: UIAlertController = {
        let alert = UIAlertController(
            title: "pairing",
            message: nil,
            preferredStyle: .alert
        )
        
        let indicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        indicator.hidesWhenStopped = true
        indicator.style = .large
        indicator.startAnimating()
        
        alert.view.addSubview(indicator)
        
        return alert
    }()
    
    let ble = BLEManager.shared
    
    override func viewWillAppear(_ animated: Bool) {
        ble.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildUI()
        setupSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        indicator.setupLayers()
        indicator.startPulsing()
    }
    
    func buildUI() {
        view.backgroundColor = .systemBackground
        
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.text = "Searcing for Device"
        titleLabel.font = .systemFont(ofSize: 22, weight: .bold)
        
        
        instructionsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        if newSystem.profile["bluetooth"]["instructions"].string != nil {
            instructionsLabel.font = .systemFont(ofSize: 16)
            instructionsLabel.text = newSystem.profile["bluetooth"]["instructions"].string
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
    
    
    //-------------------------//
    //-------------------------//
    //----//---- BLE ----//----//
    //-------------------------//
    //-------------------------//
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            ble.scan(with: [DataHelper.universalBLEUUID])
            
        default:
            print("other state")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let raw: [CBUUID: Data] = advertisementData["kCBAdvDataServiceData"] as! [CBUUID: Data]
        
        if let data = raw[DataHelper.universalBLEUUID] {
            let isPairing = data[9] == 2 ? true : false
            let model = String(data: data[0...8], encoding: .ascii)
            
            if (isPairing && model == newSystem.profile["model"].string) {
                ble.connect(peripheral: peripheral)
            }
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        if presentedViewController == nil { present(pairingAlert, animated: true) }
        peripheral.discoverServices([DataHelper.universalBLEUUID])
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        pairingAlert.dismiss(animated: true)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let services = peripheral.services {
            for service in services {
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let charecteristics = service.characteristics {
            for charecteristic in charecteristics {
                if charecteristic.uuid == DataHelper.authenticationBLEUUID {
                    peripheral.setNotifyValue(true, for: charecteristic)
                }
            }
            
            let success = ble.write(data: Data([2]), cbuuid: DataHelper.authenticationBLEUUID)
            print("simple pairing - get token /", success)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if characteristic.uuid == DataHelper.authenticationBLEUUID {
            let value: [UInt8] = [UInt8](characteristic.value!)
            
            if value.count == 4 {
                token = Data(value).withUnsafeBytes { $0.load(as: UInt32.self) }
                
                var response = Data([1])
                response.append(contentsOf: value)
                
                let success = ble.write(data: response, cbuuid: DataHelper.authenticationBLEUUID)
                print("simple pairing - confirm token /", success)
                
            } else if value.count == 1 {
                let didPassPairing = value[0]
                
                if didPassPairing == 1 {
                    pairingAlert.dismiss(animated: false) {
                        if self.token != 0 {
                            let screen = InitialConfigurationController()
                            self.newSystem.settings["#token"].uInt32 = self.token
                            screen.newSystem = self.newSystem
                            
                            self.navigationController?.pushViewController(
                                screen,
                                animated: true
                            )
                        } else {
                            print("simple pairing - token invalid")
                        }
                    }
                } else {
                    ble.disconnect()
                }
            }
        }
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
        pulsingCircleLayer.zPosition = 5
        
        staticCircleLayer.fillColor = UIColor.systemBlue.cgColor
        staticCircleLayer.opacity = 0.5
        staticCircleLayer.zPosition = 10
        
        bluetoothImageView.translatesAutoresizingMaskIntoConstraints = false
        bluetoothImageView.layer.zPosition = 15
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
        group.isRemovedOnCompletion = false
        
        pulsingCircleLayer.add(group, forKey: "pulseAndFadeOut")
    }
}
