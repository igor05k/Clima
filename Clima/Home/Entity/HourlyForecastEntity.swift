//
//  HourlyForecastEntity.swift
//  Clima
//
//  Created by Igor Fernandes on 25/02/23.
//

import Foundation

struct HourlyForecastEntity: Codable {
    let cod: String?
    let message, cnt: Int?
    let list: [List]?
    let city: City?
}

// MARK: - City
struct City: Codable {
    let id: Int?
    let name: String?
    let coord: Coord?
    let country: String?
}

// MARK: - List
struct List: Codable {
    let dt: Int?
    let main: Main?
    let weather: [Weather]?
    let dtTxt: String?

    enum CodingKeys: String, CodingKey {
        case dt, main, weather
        case dtTxt = "dt_txt"
    }
}

