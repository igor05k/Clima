//
//  WeatherDetailsPresenter.swift
//  Clima
//
//  Created by Igor Fernandes on 13/03/23.
//

import Foundation

protocol AnyWeatherDetailsPresenter: AnyObject {
    var view: AnyWeatherDetailsView? { get set }
    var router: AnyWeatherDetailsRouter { get set }
    var interacotr: AnyWeatherDetailsInteractor { get set }
    
    func didFetchHourlyForecast(result: Result<HourlyForecastEntity, Error>)
}

class WeatherDetailsPresenter: AnyWeatherDetailsPresenter {
    weak var view: AnyWeatherDetailsView?
    var router: AnyWeatherDetailsRouter
    var interacotr: AnyWeatherDetailsInteractor
    
    init(view: AnyWeatherDetailsView? = nil, router: AnyWeatherDetailsRouter, interacotr: AnyWeatherDetailsInteractor, city: CityInfo) {
        self.view = view
        self.router = router
        self.interacotr = interacotr
        
//        interacotr.getHourlyForecast(lat: city.lat, lon: city.lon)
    }
    
    // update view
    func didFetchHourlyForecast(result: Result<HourlyForecastEntity, Error>) {
        switch result {
        case .success(let success):
            view?.updateView(with: success)
        case .failure(let failure):
            print(failure)
        }
    }
}
