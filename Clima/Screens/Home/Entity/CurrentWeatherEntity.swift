//
//  HomeEntity.swift
//  Clima
//
//  Created by Igor Fernandes on 23/02/23.
//

import Foundation

import Foundation

// MARK: - HomeEntity
struct CurrentWeatherEntity: Codable {
    let base: String?
    let cod: Int?
    let dt, id: Int?
    let main: Main?
    let name: String?
    let timezone, visibility: Int?
    let weather: [Weather]?
}

// MARK: - Main
struct Main: Codable {
    let feelsLike: Double?
    let temp, tempMax, tempMin: Double?

    enum CodingKeys: String, CodingKey {
        case feelsLike = "feels_like"
        case temp
        case tempMax = "temp_max"
        case tempMin = "temp_min"
    }
}

// MARK: - Weather
struct Weather: Codable {
    let description, icon: String?
    let id: Int?
    let main: String?
}
