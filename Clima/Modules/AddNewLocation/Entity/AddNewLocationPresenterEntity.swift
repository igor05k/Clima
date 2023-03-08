//
//  AddNewLocationPresenterEntity.swift
//  Clima
//
//  Created by Igor Fernandes on 02/03/23.
//

import Foundation

// MARK: - AutoComplete
struct AutoComplete: Codable {
    let predictions: [Prediction]?
}

// MARK: - Prediction
struct Prediction: Codable {
    let description: String?
}

