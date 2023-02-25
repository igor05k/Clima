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
    let clouds: Clouds?
    let cod: Int?
    let coord: Coord?
    let dt, id: Int?
    let main: Main?
    let name: String?
    let sys: Sys?
    let timezone, visibility: Int?
    let weather: [Weather]?
    let wind: Wind?
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int?
}

// MARK: - Coord
struct Coord: Codable {
    let lat, lon: Double?
}

// MARK: - Main
struct Main: Codable {
    let feelsLike: Double?
    let grndLevel, humidity, pressure, seaLevel: Int?
    let temp, tempMax, tempMin: Double?

    enum CodingKeys: String, CodingKey {
        case feelsLike = "feels_like"
        case grndLevel = "grnd_level"
        case humidity, pressure
        case seaLevel = "sea_level"
        case temp
        case tempMax = "temp_max"
        case tempMin = "temp_min"
    }
}

// MARK: - Sys
struct Sys: Codable {
    let country: String?
    let sunrise, sunset: Int?
}

// MARK: - Weather
struct Weather: Codable {
    let description, icon: String?
    let id: Int?
    let main: String?
}

// MARK: - Wind
struct Wind: Codable {
    let deg: Int?
    let gust, speed: Double?
}
