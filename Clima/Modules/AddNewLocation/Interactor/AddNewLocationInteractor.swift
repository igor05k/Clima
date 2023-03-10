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

enum GMapsAPIConstants: String {
    case api_key = "AIzaSyD3vEKNHYWR11ulJD5302X7WDXufBKyrOU"
}

protocol AnyAddNewLocationInteractor {
    var presenter: AnyAddNewLocationPresenter? { get set }
    func getAutocompleteResults(for searchTerm: String)
    func fetchWeatherForecast(for city: String)
}

class AddNewLocationInteractor: AnyAddNewLocationInteractor {
    var presenter: AnyAddNewLocationPresenter?
    
    func fetchWeatherForecast(for city: String) {
        guard let cityTrimmed = city.components(separatedBy: ",").first?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }

        let urlString = APIConfig.base_URL.rawValue + Endpoints.forecast.rawValue + "?q=\(cityTrimmed)" + "&cnt=8&appid=" + APIConfig.api_key.rawValue

        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data, error == nil else { return }

            do {
                let json = try JSONDecoder().decode(HourlyForecastEntity.self, from: data)
                self?.presenter?.didFetchWeatherForecast(for: .success(json))
            } catch {
                self?.presenter?.didFetchWeatherForecast(for: .failure(error))
            }
        }.resume()
    }
    
    func getAutocompleteResults(for searchTerm: String) {
        guard let termEncoded = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        let urlString = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=\(termEncoded)&language=en&types=(cities)&key=\(GMapsAPIConstants.api_key.rawValue)"
        
        guard let url = URL(string: urlString) else {
            presenter?.didFetchSuggestions(with: .failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let data = data, error == nil else {
                self?.presenter?.didFetchSuggestions(with: .failure(.unknownError(reason: error?.localizedDescription ?? "No desc")))
                return
            }
            
            do {
                let json = try JSONDecoder().decode(AutoComplete.self, from: data)
                self?.presenter?.didFetchSuggestions(with: .success(json))
            } catch {
                self?.presenter?.didFetchSuggestions(with: .failure(.failedToDecode))
            }
        }
        task.resume()
    }
}
