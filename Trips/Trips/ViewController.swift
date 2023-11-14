
//
//  ViewController.swift
//  Trips
//
//  Created by Tanzila Rahman on 11/11/23.
//

import UserNotifications
import UIKit

class ViewController: UIViewController {

    @IBOutlet var table: UITableView!

    var models = [MyTrip]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.delegate = self
        table.dataSource = self

        loadModels()
    }

    func loadModels() {
        if let encodedData = UserDefaults.standard.data(forKey: "tripModels") {
            do {
                // Decoding the data to models array using Codable
                let decoder = JSONDecoder()
                models = try decoder.decode([MyTrip].self, from: encodedData)
            } catch {
                // Handling decoding error
                print("Error decoding models: \(error)")
            }
        }
    }

    @IBAction func didTapAdd() {
        guard let vc = storyboard?.instantiateViewController(identifier: "add") as? AddViewController else {
            return
        }

        vc.title = "New Trip"
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.completion = { title, body, date in
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
                let new = MyTrip(title: title, body: body, date: date, identifier: "id_\(title)")

                self.models.append(new)
                self.table.reloadData()

                let content = UNMutableNotificationContent()
                content.title = title
                content.sound = .default
                content.body = body

                let targetDate = date
                let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: targetDate), repeats: false)

                let request = UNNotificationRequest(identifier: "some_long_id", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
                    if error != nil {
                        print("something went wrong")
                    }
                })
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func didTapTest() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { success, error in
            if success {
                self.scheduleTest()
            } else if error != nil {
                print("error occurred")
            }
        })
    }

    func scheduleTest() {
        let content = UNMutableNotificationContent()
        content.title = "Hello World"
        content.sound = .default
        content.body = "a long body of text . a long body of text. a long body of text"

        let targetDate = Date().addingTimeInterval(10)
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: targetDate), repeats: false)

        let request = UNNotificationRequest(identifier: "some_long_id", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
            if error != nil {
                print("something went wrong")
            }
        })
 
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)

            // Deselect the selected row, if any
            if let selectedIndexPath = table.indexPathForSelectedRow {
                table.deselectRow(at: selectedIndexPath, animated: true)
            }
        }

}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTrip = models[indexPath.row]
        performSegue(withIdentifier: "showDetail", sender: selectedTrip)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail", let destinationVC = segue.destination as? DetailViewController, let selectedTrip = sender as? MyTrip {
            destinationVC.trip = selectedTrip
        }
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = models[indexPath.row].title
        let date = models[indexPath.row].date

        let formatter = DateFormatter()
        formatter.dateFormat = "MM/ dd/ YYYY"

        cell.detailTextLabel?.text = formatter.string(from: date)
        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Remove the item from the models array
            models.remove(at: indexPath.row)

            // Save the updated models array to UserDefaults
            saveModels()

            // Delete the row from the table view
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    func saveModels() {
        // Convert models array to Data
        if let encodedData = try? JSONEncoder().encode(models) {
            // Save the encoded data to UserDefaults
            UserDefaults.standard.set(encodedData, forKey: "tripModels")
        }
    }

}

struct MyTrip: Codable {
    var title: String
    var body: String
    var date: Date
    let identifier: String
}


