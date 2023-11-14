//
//  AddViewController.swift
//  Trips
//
//  Created by Tanzila Rahman on 11/11/23.
//

import UIKit

class AddViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet var titleField: UITextField!
    @IBOutlet var bodyField: UITextField!
    @IBOutlet var datePicker: UIDatePicker!
    
    public var completion: ((String, String, Date) -> Void)? 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleField.delegate = self
        bodyField.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTapSaveButton))
    }
    
    @objc func didTapSaveButton() {
        if let titleText = titleField.text, !titleText.isEmpty,
           let bodyText = bodyField.text, !bodyText.isEmpty {
            let targetDate = datePicker.date

            completion?(titleText, bodyText, targetDate)

            // Saving the models array to UserDefaults using DataManager
            DataManager.saveModels(DataManager.loadModels() + [MyTrip(title: titleText, body: bodyText, date: targetDate, identifier: "id_\(titleText)")])

            // Navigating back to the ViewController
            navigationController?.popToRootViewController(animated: true)
        }
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
