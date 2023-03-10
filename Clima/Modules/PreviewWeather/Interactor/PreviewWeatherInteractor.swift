//
//  PreviewWeatherInteractor.swift
//  Clima
//
//  Created by Igor Fernandes on 10/03/23.
//

import Foundation

protocol AnyPreviewWeatherInteractor {
    var presenter: PreviewWeatherPresenter? { get set }
}

class PreviewWeatherInteractor: AnyPreviewWeatherInteractor {
    var presenter: PreviewWeatherPresenter?
}
