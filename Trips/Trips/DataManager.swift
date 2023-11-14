

//
//  DataManager.swift
//  Trips
//
//  Created by Tanzila Rahman on 11/11/23.
//

import Foundation

class DataManager {
    static var models = [MyTrip]()

    static func saveModels(_ models: [MyTrip]) {
        self.models = models // Updating the static array when saving
        if let encodedData = try? JSONEncoder().encode(models) {
            UserDefaults.standard.set(encodedData, forKey: "tripModels")
        }
    }

    static func loadModels() -> [MyTrip] {
        if let encodedData = UserDefaults.standard.data(forKey: "tripModels") {
            do {
                return try JSONDecoder().decode([MyTrip].self, from: encodedData)
            } catch {
                print("Error decoding models: \(error)")
            }
        }
        return []
    }

    static func updateTrip(trip: MyTrip, withNewTitle title: String, newBody body: String, newDate date: Date) {
        // Finding the index of the trip in the models array
        if let index = models.firstIndex(where: { $0.identifier == trip.identifier }) {
            // Updating the trip with new values
            models[index].title = title
            models[index].body = body
            models[index].date = date

            // Saving the updated models array to UserDefaults
            saveModels(models)
        }
    }
}
