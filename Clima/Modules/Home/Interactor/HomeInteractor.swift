//
//  HomeInteractor.swift
//  Clima
//
//  Created by Igor Fernandes on 23/02/23.
//

import Foundation
import CoreLocation

enum Endpoints: String {
    case currentWeather = "weather"
    case forecast = "forecast"
}

enum APIConfig: String {
    case base_URL = "https://api.openweathermap.org/data/2.5/"
    case api_key = "07654e4f64da69e379560cfdda5dbe99"
}

enum Forecast {
    case hourly
    case daily
}

protocol AnyHomeInteractor: AnyObject {
    var presenter: AnyHomePresenter? { get set }
    var locationManager: CLLocationManager? { get set }
    
    func fetchUserLocation()
    func getCurrentWeather(lat: CLLocationDegrees, lon: CLLocationDegrees)
    func fetchForecastData(lat: CLLocationDegrees, lon: CLLocationDegrees, type: Forecast)
}

class HomeInteractor: NSObject, AnyHomeInteractor, CLLocationManagerDelegate {
    var presenter: AnyHomePresenter?
    var locationManager: CLLocationManager?
    
    // MARK: API Calls
    func getCurrentWeather(lat: CLLocationDegrees, lon: CLLocationDegrees) {
        let latToString = String(lat)
        let lonToString = String(lon)
        
        guard let url = URL(string: APIConfig.base_URL.rawValue + Endpoints.currentWeather.rawValue + "?lat=\(latToString)&lon=\(lonToString)&appid=" + APIConfig.api_key.rawValue) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data, error == nil else { return }
            
            do {
                let json = try JSONDecoder().decode(CurrentWeatherEntity.self, from: data)
                self?.presenter?.didFetchWeather(result: .success(json))
            } catch {
                self?.presenter?.didFetchWeather(result: .failure(error))
            }
        }.resume()
    }
    
    func fetchForecastData(lat: CLLocationDegrees, lon: CLLocationDegrees, type: Forecast) {
        switch type {
        case .hourly:
            getHourlyForecast(lat: lat, lon: lon)
        case .daily:
            getDailyForecast(lat: lat, lon: lon)
        }
    }
    
    private func getHourlyForecast(lat: CLLocationDegrees, lon: CLLocationDegrees) {
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
    
    private func getDailyForecast(lat: CLLocationDegrees, lon: CLLocationDegrees) {
        let latToString = String(lat)
        let lonToString = String(lon)
        
        let urlString = APIConfig.base_URL.rawValue + Endpoints.forecast.rawValue + "?lat=\(latToString)&lon=\(lonToString)&appid=" + APIConfig.api_key.rawValue
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data, error == nil else { return }
            
            do {
                let json = try JSONDecoder().decode(HourlyForecastEntity.self, from: data)
                self?.presenter?.didFetchDailyForecast(result: .success(json))
            } catch {
                self?.presenter?.didFetchDailyForecast(result: .failure(error))
            }
        }.resume()
    }

    // MARK: Location manager
    func fetchUserLocation() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        locationManager?.stopUpdatingLocation()
        
        presenter?.didFetchUserCoordinates(lat: latitude, lon: longitude)
    }
}
