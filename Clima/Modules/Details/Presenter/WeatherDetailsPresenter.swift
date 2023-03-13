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
}

class WeatherDetailsPresenter: AnyWeatherDetailsPresenter {
    weak var view: AnyWeatherDetailsView?
    var router: AnyWeatherDetailsRouter
    var interacotr: AnyWeatherDetailsInteractor
    
    init(view: AnyWeatherDetailsView? = nil, router: AnyWeatherDetailsRouter, interacotr: AnyWeatherDetailsInteractor) {
        self.view = view
        self.router = router
        self.interacotr = interacotr
    }
}
