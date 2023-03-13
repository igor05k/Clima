//
//  WeatherDetailsBuilder.swift
//  Clima
//
//  Created by Igor Fernandes on 13/03/23.
//

import UIKit

class WeatherDetailsBuilder {
    
    static func build() -> UIViewController {
        let controller = WeatherDetailsView()
        let interactor = WeatherDetailsInteractor()
        let router = WeatherDetailsRouter()
        
        let presenter = WeatherDetailsPresenter(view: controller, router: router, interacotr: interactor)
        
        controller.presenter = presenter
        interactor.presenter = presenter
        router.controller = controller
        
        return controller
    }
}
