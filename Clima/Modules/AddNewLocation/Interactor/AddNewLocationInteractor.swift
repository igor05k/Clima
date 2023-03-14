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
    func getCoordinates(for city: String)
}

enum GeocodingAPIConfig: String {
    case base_URL = "https://maps.googleapis.com/maps/api/geocode/json?address="
    case api_key = "AIzaSyD3vEKNHYWR11ulJD5302X7WDXufBKyrOU"
}

class AddNewLocationInteractor: AnyAddNewLocationInteractor {
    var presenter: AnyAddNewLocationPresenter?
    
    func getCoordinates(for city: String) {
        guard let cityEncoded = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        
        let urlString = GeocodingAPIConfig.base_URL.rawValue + cityEncoded + "&key=" + GeocodingAPIConfig.api_key.rawValue

        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data, error == nil else { return }

            do {
                let json = try JSONDecoder().decode(Geocoding.self, from: data)
                if let lat = json.results?[0].geometry?.location?.lat,
                   let lon = json.results?[0].geometry?.location?.lng {
                    self?.fetchWeatherForecast(using: lat, lon: lon) { result in
                        switch result {
                        case .success(let success):
                            self?.presenter?.didFetchWeatherForecast(for: .success(success))
                        case .failure(let failure):
                            self?.presenter?.didFetchWeatherForecast(for: .failure(failure))
                        }
                    }
                }
            } catch {
                print(error)
            }
        }.resume()
    }
    
    private func fetchWeatherForecast(using lat: Double, lon: Double, completion: @escaping (Result<HourlyForecastEntity, Error>) -> Void) {
        let urlString = APIConfig.base_URL.rawValue + Endpoints.forecast.rawValue + "?lat=\(lat)" + "&cnt=8&lon=\(lon)&appid=" + APIConfig.api_key.rawValue

        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data, error == nil {
                do {
                    let json = try JSONDecoder().decode(HourlyForecastEntity.self, from: data)
                    completion(.success(json))
                } catch {
                    completion(.failure(error))
                }
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
