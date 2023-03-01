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
    var interactor: AnyHomeInteractor? { get set }
    var router: AnyHomeRouter? { get set }
    
    func didFetchWeather(result: Result<CurrentWeatherEntity, Error>)
    func didFetchHourlyForecast(result: Result<HourlyForecastEntity, Error>)
    
    func didFetchUserCoordinates(lat: CLLocationDegrees, lon: CLLocationDegrees)
}

class HomePresenter: AnyHomePresenter {
    weak var view: AnyHomeView?
    
    var interactor: AnyHomeInteractor? {
        didSet {
             interactor?.fetchUserLocation()
        }
    }
    
    weak var router: AnyHomeRouter?
    
    func checkForecastDays(model: HourlyForecastEntity) -> [String: (tempMin: Double, tempMax: Double, icon: String)] {
        guard let list = model.list else { return [:] }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let outputDateFormatter = DateFormatter()
        outputDateFormatter.dateFormat = "yyyy-MM-dd"

        var uniqueDaysForecastProperties: [String: (tempMin: Double, tempMax: Double, icon: String)] = [:]
        
        for item in list {
            if let dateString = item.dtTxt, let date = dateFormatter.date(from: dateString) {
                let outputDateString = outputDateFormatter.string(from: date)
                if uniqueDaysForecastProperties[outputDateString] == nil {
                    let tempMin = item.main?.tempMin ?? 0
                    let tempMax = item.main?.tempMax ?? 0
                    let icon = item.weather?.first?.icon ?? ""
                    uniqueDaysForecastProperties[outputDateString] = (tempMin, tempMax, icon)
                } else {
                    // item already exists so skip it
                    continue
                }
            }
        }
        
        return uniqueDaysForecastProperties
    }
    
    func didFetchHourlyForecast(result: Result<HourlyForecastEntity, Error>) {
        switch result {
        case .success(let success):
            view?.updateHourlyForecast(with: success)
            let abc = checkForecastDays(model: success)
            print(abc)
        case .failure(let failure):
            // TODO: error handling
            print(failure)
        }
    }
    
    func didFetchUserCoordinates(lat: CLLocationDegrees, lon: CLLocationDegrees) {
//        interactor?.getCurrentWeather(lat: lat, lon: lon)
        interactor?.getHourlyForecast(lat: lat, lon: lon, cnt: 8)
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
