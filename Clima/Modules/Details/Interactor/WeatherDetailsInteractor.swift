//
//  WeatherDetailsInteractor.swift
//  Clima
//
//  Created by Igor Fernandes on 13/03/23.
//

import Foundation

protocol AnyWeatherDetailsInteractor: AnyObject {
    var presenter: AnyWeatherDetailsPresenter? { get set }
}

class WeatherDetailsInteractor: AnyWeatherDetailsInteractor {
    var presenter: AnyWeatherDetailsPresenter?
}
