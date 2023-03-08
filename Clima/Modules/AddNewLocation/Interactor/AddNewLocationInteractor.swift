//
//  AddNewLocationInteractor.swift
//  Clima
//
//  Created by Igor Fernandes on 02/03/23.
//

import Foundation

enum AutoCompleteErrors: LocalizedError {
    case invalidURL
    case unknownError(reason: String)
    case failedToDecode
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "This is a invalid URL"
        case .unknownError(let reason):
            return "An error occurred: \(reason)"
        case .failedToDecode:
            return "Error while decoding struct"
        }
    }
    
}

protocol AnyAddNewLocationInteractor {
    var presenter: AnyAddNewLocationPresenter? { get set }
    func getAutocompleteResults(for searchTerm: String, completion: @escaping (Result<AutoComplete, AutoCompleteErrors>) -> Void)
}

class AddNewLocationInteractor: AnyAddNewLocationInteractor {
    var presenter: AnyAddNewLocationPresenter?
    
    let API_KEY = "AIzaSyD3vEKNHYWR11ulJD5302X7WDXufBKyrOU"

    func getAutocompleteResults(for searchTerm: String, completion: @escaping (Result<AutoComplete, AutoCompleteErrors>) -> Void) {
        let urlString = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=\(searchTerm)&language=en&types=(cities)&key=\(API_KEY)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(.failure(.unknownError(reason: error?.localizedDescription ?? "No description")))
                return
            }
            
            do {
                let json = try JSONDecoder().decode(AutoComplete.self, from: data)
                completion(.success(json))
            } catch {
                completion(.failure(.failedToDecode))
            }
        }
        task.resume()
    }
}
