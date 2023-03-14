//
//  WeatherDetailsInteractor.swift
//  Clima
//
//  Created by Igor Fernandes on 13/03/23.
//

import Foundation

protocol AnyWeatherDetailsInteractor: AnyObject {
    var presenter: AnyWeatherDetailsPresenter? { get set }
    
    func getHourlyForecast(lat: Double, lon: Double)
}

class WeatherDetailsInteractor: AnyWeatherDetailsInteractor {
    var presenter: AnyWeatherDetailsPresenter?
    
    func getHourlyForecast(lat: Double, lon: Double) {
        let latToString = String(lat)
        let lonToString = String(lon)
        
        let urlString = APIConfig.base_URL.rawValue + Endpoints.forecast.rawValue + "?lat=\(latToString)&lon=\(lonToString)&appid=" + APIConfig.api_key.rawValue + "&cnt=8"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data, error == nil else { return }
            
            do {
                let json = try JSONDecoder().decode(HourlyForecastEntity.self, from: data)
                self?.presenter?.didFetchHourlyForecast(result: .success(json))
            } catch {
                self?.presenter?.didFetchHourlyForecast(result: .failure(error))
            }
        }.resume()
    }
}
