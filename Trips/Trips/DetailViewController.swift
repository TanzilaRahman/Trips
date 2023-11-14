//
//  DetailViewController.swift
//  Trips
//
//  Created by Tanzila Rahman on 11/12/23.
//

import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var titleField: UITextField!
    @IBOutlet var bodyField: UITextField!
    @IBOutlet var datePicker: UIDatePicker!

    var trip: MyTrip?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    private func setupUI() {
        // Set initial values from the trip
        titleField.text = trip?.title
        bodyField.text = trip?.body
        datePicker.date = trip?.date ?? Date()
    }

    @IBAction func saveButtonTapped(_ sender: UIButton) {
        // Update the data model with edited details
        if let trip = trip,
           let newTitle = titleField.text,
           let newBody = bodyField.text {
            let newDate = datePicker.date
            DataManager.updateTrip(trip: trip, withNewTitle: newTitle, newBody: newBody, newDate: newDate)
        }

        // Optionally, dismiss the view controller or update the UI as needed
        navigationController?.popViewController(animated: true)
    }
}
