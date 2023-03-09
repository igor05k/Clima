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

enum APIConstants: String {
    case base_url = "https://api.openweathermap.org/data/2.5/weather?q=Mumbai&appid=07654e4f64da69e379560cfdda5dbe99"
}

enum GMapsAPIConstants: String {
    case api_key = "AIzaSyD3vEKNHYWR11ulJD5302X7WDXufBKyrOU"
}

protocol AnyAddNewLocationInteractor {
    var presenter: AnyAddNewLocationPresenter? { get set }
    func getAutocompleteResults(for searchTerm: String, completion: @escaping (Result<AutoComplete, AutoCompleteErrors>) -> Void)
    func fetchWeather(for city: String, completion: @escaping (Result<CurrentWeatherEntity, Error>) -> Void)
}

class AddNewLocationInteractor: AnyAddNewLocationInteractor {
    var presenter: AnyAddNewLocationPresenter?
    
    func fetchWeather(for city: String, completion: @escaping (Result<CurrentWeatherEntity, Error>) -> Void) {
        guard let cityTrimmed = city.components(separatedBy: ",").first?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        
        let urlString = APIConfig.base_URL.rawValue + Endpoints.currentWeather.rawValue + "?q=\(cityTrimmed)" + "&appid=" + APIConfig.api_key.rawValue

        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data, error == nil else { return }
            
            do {
                let json = try JSONDecoder().decode(CurrentWeatherEntity.self, from: data)
                completion(.success(json))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    
    func getAutocompleteResults(for searchTerm: String, completion: @escaping (Result<AutoComplete, AutoCompleteErrors>) -> Void) {
        let urlString = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=\(searchTerm)&language=en&types=(cities)&key=\(GMapsAPIConstants.api_key.rawValue)"
        
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
