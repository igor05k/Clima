//
//  WeatherDetailsRouter.swift
//  Clima
//
//  Created by Igor Fernandes on 13/03/23.
//

import Foundation

protocol AnyWeatherDetailsRouter: AnyObject {
    var controller: WeatherDetailsView? { get set }
}

class WeatherDetailsRouter: AnyWeatherDetailsRouter {
    var controller: WeatherDetailsView?
}
