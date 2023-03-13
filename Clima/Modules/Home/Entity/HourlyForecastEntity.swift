//
//  HourlyForecastEntity.swift
//  Clima
//
//  Created by Igor Fernandes on 25/02/23.
//

import Foundation

struct HourlyForecastEntity: Codable {
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

// MARK: - Coord
struct Coord: Codable {
    let lat, lon: Double?
}

// MARK: - List
struct List: Codable {
    let dt: Int?
    let main: Main?
    let weather: [Weather]?
    let wind: Wind?
    let dtTxt: String?
    let visibility: Int?
    let pop: Double?

    enum CodingKeys: String, CodingKey {
        case dt, main, weather, wind, visibility, pop
        case dtTxt = "dt_txt"
    }
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double?
    let deg: Int?
    let gust: Double?
}

