//
//  PreviewWeatherRouter.swift
//  Clima
//
//  Created by Igor Fernandes on 10/03/23.
//

import Foundation

protocol AnyPreviewWeatherRouter {
    var view: AnyPreviewWeatherView? { get set }
}

class PreviewWeatherRouter: AnyPreviewWeatherRouter {
    weak var view: AnyPreviewWeatherView?
}
