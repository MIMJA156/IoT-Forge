//
//  MyFirstTestDevice.swift
//  IoT-Forge
//
//  Created by Mizia, Miles - Student on 2/26/24.
//

import UIKit
import CoreBluetooth
import SwiftyJSON

class MyFirstTestDevice: LocalSystem {
    override func viewDidLoad() {
        super.viewDidLoad()

        title = system.settings["#name"].string

        let textView1 = UITextView()
        textView1.text = system.profile.description
        textView1.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height / 2)
        textView1.layer.borderWidth = 1.0
        textView1.layer.borderColor = UIColor.black.cgColor

        let textView2 = UITextView()
        textView2.text = system.settings.description
        textView2.frame = CGRect(x: 0, y: view.bounds.height / 2, width: view.bounds.width, height: view.bounds.height / 4)
        textView2.layer.borderWidth = 1.0
        textView2.layer.borderColor = UIColor.black.cgColor

        let actionView = UIView()
        actionView.backgroundColor = .systemBackground
        actionView.frame = CGRect(x: 0, y: view.bounds.height * 3 / 4, width: view.bounds.width, height: view.bounds.height / 4)
        actionView.layer.borderWidth = 1.0
        actionView.layer.borderColor = UIColor.black.cgColor

        let button1 = UIButton()
        button1.setTitle("Click Me", for: .normal)
        button1.setBackgroundImage(.pixel(ofColor: .systemBlue), for: .normal)
        button1.translatesAutoresizingMaskIntoConstraints = false

        actionView.addSubview(button1)

        NSLayoutConstraint.activate([
            button1.widthAnchor.constraint(equalToConstant: 200),
            button1.heightAnchor.constraint(equalToConstant: 50),
            button1.centerXAnchor.constraint(equalTo: actionView.centerXAnchor),
            button1.centerYAnchor.constraint(equalTo: actionView.centerYAnchor)
        ])

        view.addSubview(textView1)
        view.addSubview(textView2)
        view.addSubview(actionView)
    }
}
