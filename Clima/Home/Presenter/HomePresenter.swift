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
    
    
    func didFetchHourlyForecast(result: Result<HourlyForecastEntity, Error>) {
        switch result {
        case .success(let success):
            print(success)
            view?.updateHourlyForecast(with: success)
        case .failure(let failure):
            // TODO: error handling
            print(failure)
        }
    }
    
    func didFetchUserCoordinates(lat: CLLocationDegrees, lon: CLLocationDegrees) {
//        interactor?.getCurrentWeather(lat: lat, lon: lon)
        interactor?.getHourlyForecast(lat: lat, lon: lon)
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
