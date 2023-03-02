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

protocol AnyHomeInteractor: AnyObject {
    var presenter: AnyHomePresenter? { get set }
    var locationManager: CLLocationManager? { get set }
    
    func fetchUserLocation()
    // TODO: tentar fazer uma funçao generica que inclua todos os tipos; posso colocar um enum como parametro e de acordo com cada tipo fazer uma chamada
    
    func getCurrentWeather(lat: CLLocationDegrees, lon: CLLocationDegrees)
    func getHourlyForecast(lat: CLLocationDegrees, lon: CLLocationDegrees)
    func getDailyForecast(lat: CLLocationDegrees, lon: CLLocationDegrees)
    func checkUniqueForecastDays(model: HourlyForecastEntity) -> [String: (tempMin: Double, tempMax: Double, icon: String)]
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
    
    func getHourlyForecast(lat: CLLocationDegrees, lon: CLLocationDegrees) {
        let latToString = String(lat)
        let lonToString = String(lon)
        
        var urlString = APIConfig.base_URL.rawValue + Endpoints.forecast.rawValue + "?lat=\(latToString)&lon=\(lonToString)&appid=" + APIConfig.api_key.rawValue + "&cnt=8"
        
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
    
    func getDailyForecast(lat: CLLocationDegrees, lon: CLLocationDegrees) {
        let latToString = String(lat)
        let lonToString = String(lon)
        
        var urlString = APIConfig.base_URL.rawValue + Endpoints.forecast.rawValue + "?lat=\(latToString)&lon=\(lonToString)&appid=" + APIConfig.api_key.rawValue
        
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
    
    /// gets the temp max and min for each day
    func checkUniqueForecastDays(model: HourlyForecastEntity) -> [String: (tempMin: Double, tempMax: Double, icon: String)] {
        guard let list = model.list else { return [:] }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let outputDateFormatter = DateFormatter()
        outputDateFormatter.dateFormat = "yyyy-MM-dd"
        
        // create a dictionary to store the max and min temperatures for each date
        var dailyTemperatures: [String: (tempMin: Double, tempMax: Double, icon: String)] = [:]

        // iterate over all items
        for item in list {
            guard let timestamp = item.dtTxt,
                  let temperatureMax = item.main?.tempMax,
                  let temperatureMin = item.main?.tempMin,
                  let icon = item.weather?.first?.icon else {
                continue
            }
            
            // convert from "yyyy-MM-dd HH:mm:ss" to "yyyy-MM-dd"
            let date = dateFormatter.date(from: timestamp) ?? Date()
            let outputDateString = outputDateFormatter.string(from: date)
            
            // check if the max and min temperatures for this date does exist
            if let existingTemperatures = dailyTemperatures[outputDateString] {
                // if it already exists compare the values and assign the min or max depending on each case
                let updatedMax = max(existingTemperatures.tempMax, temperatureMax)
                let updatedMin = min(existingTemperatures.tempMin, temperatureMin)
                dailyTemperatures[outputDateString] = (updatedMin, updatedMax, icon)
            } else {
                // if the timestamp doesnt exist in the dict, assign the new values
                dailyTemperatures[outputDateString] = (temperatureMin, temperatureMax, icon)
            }
        }
        
        return dailyTemperatures
    }
}
