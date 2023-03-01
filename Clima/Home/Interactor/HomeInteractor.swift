//
//  HomeInteractor.swift
//  Clima
//
//  Created by Igor Fernandes on 23/02/23.
//

import Foundation
import CoreLocation

enum APIConfig: String {
    case base_URL_currentWeather = "https://api.openweathermap.org/data/2.5/weather?"
    case base_URL_forecast = "https://api.openweathermap.org/data/2.5/forecast?"
    case api_key = "07654e4f64da69e379560cfdda5dbe99"
}

protocol AnyHomeInteractor: AnyObject {
    var presenter: AnyHomePresenter? { get set }
    var locationManager: CLLocationManager? { get set }
    
    func fetchUserLocation()
    
    func getCurrentWeather(lat: CLLocationDegrees, lon: CLLocationDegrees)
    func getHourlyForecast(lat: CLLocationDegrees, lon: CLLocationDegrees, cnt: Int?)
}

class HomeInteractor: NSObject, AnyHomeInteractor, CLLocationManagerDelegate {
    var presenter: AnyHomePresenter?
    var locationManager: CLLocationManager?
    
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
    
    func getCurrentWeather(lat: CLLocationDegrees, lon: CLLocationDegrees) {
        let latToString = String(lat)
        let lonToString = String(lon)
        
        guard let url = URL(string: APIConfig.base_URL_currentWeather.rawValue + "lat=\(latToString)&lon=\(lonToString)&appid=" + APIConfig.api_key.rawValue) else { return }
        
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
    
    func getHourlyForecast(lat: CLLocationDegrees, lon: CLLocationDegrees, cnt: Int?) {
        let latToString = String(lat)
        let lonToString = String(lon)
        
        var urlString = APIConfig.base_URL_forecast.rawValue + "lat=\(latToString)&lon=\(lonToString)&appid=" + APIConfig.api_key.rawValue
        
        if let cnt {
            urlString += "&cnt=\(cnt)"
        }
        
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
