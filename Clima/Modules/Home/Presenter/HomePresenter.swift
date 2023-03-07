//
//  HomePresenter.swift
//  Clima
//
//  Created by Igor Fernandes on 23/02/23.
//

import Foundation
import CoreLocation

protocol AnyHomePresenter: AnyObject {
    var view: AnyHomeView? { get set }
    var interactor: AnyHomeInteractor { get set }
    var router: AnyHomeRouter { get set }
    
    func didFetchWeather(result: Result<CurrentWeatherEntity, Error>)
    func didFetchHourlyForecast(result: Result<HourlyForecastEntity, Error>)
    func didFetchDailyForecast(result: Result<HourlyForecastEntity, Error>)
    func didFetchUserCoordinates(lat: CLLocationDegrees, lon: CLLocationDegrees)
    
    func didTapAddNewLocation()
    
    func kelvinToCelsius(_ k: Double) -> Double
}

class HomePresenter: AnyHomePresenter {
    weak var view: AnyHomeView?
    
    var interactor: AnyHomeInteractor
    var router: AnyHomeRouter
    
    init(view: AnyHomeView? = nil, interactor: AnyHomeInteractor, router: AnyHomeRouter) {
        self.view = view
        self.interactor = interactor
        self.router = router
        
        interactor.fetchUserLocation()
    }
    
    func didTapAddNewLocation() {
        router.goToAddNewLocation()
    }
    
    private func convertDateToDictWeekdays(dict: [String: (tempMin: Double, tempMax: Double, icon: String)]?) -> [String: String]? {
        guard let keys = dict?.keys else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let dayOfWeekFormatter = DateFormatter()
        dayOfWeekFormatter.dateFormat = "EEEE"
        
        var weekdays: [String: String] = [:]
        
        for key in keys {
            if let dayOfWeek = dateFormatter.date(from: key) {
                
                let formatted = dayOfWeekFormatter.string(from: dayOfWeek) // Quarta-feira
                weekdays[key] = formatted
            }
        }
        
        return weekdays
    }
    
    private func getForecastKeyDays(result: [String: (tempMin: Double, tempMax: Double, icon: String)]) -> [String] {
        let weekdaysKeys = result.keys
        
        var keys: [String] = [String]()
        
        for key in weekdaysKeys {
            keys.append(key)
        }
        
        return keys
    }
    
    func kelvinToCelsius(_ k: Double) -> Double { k - 273.15 }
    
    func didFetchHourlyForecast(result: Result<HourlyForecastEntity, Error>) {
        switch result {
        case .success(let success):
            // update hourly forecast
            view?.updateHourlyForecast(with: success)
        case .failure(let failure):
            print(failure)
        }
    }
    
    func didFetchDailyForecast(result: Result<HourlyForecastEntity, Error>) {
        switch result {
        case .success(let success):
            // update daily forecast
            let result = interactor.checkUniqueForecastDays(model: success)
            if let weekDays = convertDateToDictWeekdays(dict: result) {
                let keys = getForecastKeyDays(result: result).sorted()
                
                view?.updateDailyForecast(with: result, keys: keys, weekDays: weekDays)
            }
        case .failure(let failure):
            // TODO: error handling
            print(failure)
        }
    }
    
    func didFetchUserCoordinates(lat: CLLocationDegrees, lon: CLLocationDegrees) {
        interactor.getCurrentWeather(lat: lat, lon: lon)
        interactor.fetchForecastData(lat: lat, lon: lon, type: .daily)
        interactor.fetchForecastData(lat: lat, lon: lon, type: .hourly)
    }
    
    func didFetchWeather(result: Result<CurrentWeatherEntity, Error>) {
        switch result {
        case .success(let success):
            view?.updateCurrentTemperature(with: success)
        case .failure(let failure):
            // TODO: error handling
            print(failure)
        }
    }
}
