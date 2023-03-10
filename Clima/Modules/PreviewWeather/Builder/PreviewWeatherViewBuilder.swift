//
//  PreviewWeatherViewBuilder.swift
//  Clima
//
//  Created by Igor Fernandes on 10/03/23.
//

import UIKit

class PreviewWeatherViewBuilder {
    
    static func build(data: HourlyForecastEntity) -> UIViewController {
        let view = PreviewWeatherViewController()
        let interactor = PreviewWeatherInteractor()
        let router = PreviewWeatherRouter()
        let presenter = PreviewWeatherPresenter(view: view, interactor: interactor, router: router)
        
        view.configWeather(data: data)

        view.presenter = presenter
        router.view = view
        interactor.presenter = presenter

        return view
    }
}
