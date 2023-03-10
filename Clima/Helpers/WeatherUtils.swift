//
//  Weather.swift
//  Clima
//
//  Created by Igor Fernandes on 10/03/23.
//

import Foundation

class WeatherUtils {
    static let shared = WeatherUtils()
    
    private init() {}
    
    /// gets the temp max and min for each day
   func checkUniqueForecastDays(model: HourlyForecastEntity) -> [String: (tempMin: Double, tempMax: Double, icon: String)] {
        guard let list = model.list else { return [:] }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let outputDateFormatter = DateFormatter()
        outputDateFormatter.dateFormat = "yyyy-MM-dd"
        
        // create a dictionary to store the max and min temperatures for each date
        var dailyTemperatures: [String: (tempMin: Double, tempMax: Double, icon: String)] = [:]

        // iterate over all items
        for item in list {
            guard let timestamp = item.dtTxt,
                  let temperatureMax = item.main?.tempMax,
                  let temperatureMin = item.main?.tempMin,
                  let icon = item.weather?.first?.icon else {
                continue
            }
            
            // convert from "yyyy-MM-dd HH:mm:ss" to "yyyy-MM-dd"
            let date = dateFormatter.date(from: timestamp) ?? Date()
            let outputDateString = outputDateFormatter.string(from: date)
            
            // check if the max and min temperatures for this date does exist
            if let existingTemperatures = dailyTemperatures[outputDateString] {
                // if it already exists compare the values and assign the min or max depending on each case
                let updatedMax = max(existingTemperatures.tempMax, temperatureMax)
                let updatedMin = min(existingTemperatures.tempMin, temperatureMin)
                dailyTemperatures[outputDateString] = (updatedMin, updatedMax, icon)
            } else {
                // if the timestamp doesnt exist in the dict, assign the new values
                dailyTemperatures[outputDateString] = (temperatureMin, temperatureMax, icon)
            }
        }
        
        return dailyTemperatures
    }
    
    var currentDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let currentDateString = formatter.string(from: Date())
        return currentDateString
    }
}
