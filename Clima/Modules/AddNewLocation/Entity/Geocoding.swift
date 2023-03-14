//
//  Geocoding.swift
//  Clima
//
//  Created by Igor Fernandes on 14/03/23.
//

import Foundation

// MARK: - Geocoding
struct Geocoding: Codable {
    let results: [GeocodingResult]?
}

// MARK: - Result
struct GeocodingResult: Codable {
    let geometry: Geometry?
}

// MARK: - Geometry
struct Geometry: Codable {
    let location: Location?
}

// MARK: - Location
struct Location: Codable {
    let lat, lng: Double?
}
