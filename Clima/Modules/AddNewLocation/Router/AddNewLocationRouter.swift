//
//  AddNewLocationRouter.swift
//  Clima
//
//  Created by Igor Fernandes on 02/03/23.
//

import UIKit

protocol AnyAddNewLocationRouter: AnyObject {
    var view: AddNewLocationView? { get set }
    func goToPreviewCityWeather(data: CurrentWeatherEntity)
}

class AddNewLocationRouter: AnyAddNewLocationRouter {
    var view: AddNewLocationView?
    
    func goToPreviewCityWeather(data: CurrentWeatherEntity) {
        let previewWeatherVC = PreviewWeatherViewController()
        previewWeatherVC.configWeather(data: data)
        let navigation = UINavigationController(rootViewController: previewWeatherVC)
        view?.present(navigation, animated: true)
    }
}
