//
//  AdditionalConfigurationEditingScreen.swift
//  IoT-Forge
//
//  Created by Mizia, Miles - Student on 2/21/24.
//

import UIKit
import SwiftyJSON

class AdditionalConfigurationEditingController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    lazy var tableView: UITableView = {
        UITableView(frame: self.view.bounds, style: .grouped)
    }()
    
    var selectedSetting: JSON!
    var currentValue: JSON!
    var updateFunction: ((String, JSON) -> ())!
    
    let additionalConfigurationEditingScreenCell = AdditionalConfigurationEditingScreenCell()
    
    let screen: [Int] = [0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
        setupSubviews()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        additionalConfigurationEditingScreenCell.getField().delegate = self
        additionalConfigurationEditingScreenCell.configure(with: selectedSetting, value: currentValue)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        additionalConfigurationEditingScreenCell.getField().becomeFirstResponder()
    }
    
    func buildUI() {
        view.backgroundColor = .systemBackground
        title = selectedSetting["name"].string
        
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
    }
    
    func setupSubviews() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
        ])
    }
    
    func displayInputError(error: String) {
        let alert = UIAlertController(
            title: error,
            message: nil,
            preferredStyle: .alert
        )
        
        alert.addAction(
            UIAlertAction(title: "Ok", style: .default)
        )
        
        present(alert, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return screen.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return AdditionalConfigurationEditingScreenCell.height
            
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return additionalConfigurationEditingScreenCell
            
        default:
            return UITableViewCell()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let text = textField.text
        let cleanedText = text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if selectedSetting["type"] == "string" {
            if isValidTextString(text: cleanedText) {
                updateFunction(selectedSetting["id"].stringValue, JSON(stringLiteral: cleanedText!))
                navigationController?.popViewController(animated: true)
            } else {
                print("invalid / string")
                displayInputError(error: "invalid string")
            }
        } else if selectedSetting["type"] == "integer" {
            if isValidTextInteger(text: cleanedText) {
                let newInt = Int(cleanedText!)!
                updateFunction(selectedSetting["id"].stringValue, JSON(integerLiteral: newInt))
                navigationController?.popViewController(animated: true)
            } else {
                print("invalid / integer")
                displayInputError(error: "invalid integer")
            }
        }
        
        return false
    }
    
    func isValidTextString(text: String?) -> Bool {
        var isValid = true
        
        if text == nil { isValid = false } else
        if text!.isEmpty { isValid = false }

        return isValid
    }
    
    func isValidTextInteger(text: String?) -> Bool {
        var isValid = true
        
        if text == nil { isValid = false } else
        if Int32(text!) == nil { isValid = false }
        
        return isValid
    }
}
