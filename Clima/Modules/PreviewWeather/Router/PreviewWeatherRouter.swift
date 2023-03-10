//
//  PreviewWeatherRouter.swift
//  Clima
//
//  Created by Igor Fernandes on 10/03/23.
//

import Foundation

protocol AnyPreviewWeatherRouter {
    var view: PreviewWeatherViewController? { get set }
    
    func dismissModal()
}

class PreviewWeatherRouter: AnyPreviewWeatherRouter {
    weak var view: PreviewWeatherViewController?
    
    func dismissModal() {
        view?.dismiss(animated: true)
    }
}
