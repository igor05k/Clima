//
//  PreviewWeatherPresenter.swift
//  Clima
//
//  Created by Igor Fernandes on 10/03/23.
//

import Foundation

protocol AnyPreviewWeatherPresenter: AnyObject {
    var view: AnyPreviewWeatherView? { get set }
    var interactor: AnyPreviewWeatherInteractor { get set }
    var router: AnyPreviewWeatherRouter { get set }
    
    func didTapSaveCity(data: CityInfo)
    func didSaveInfo()
}

class PreviewWeatherPresenter: AnyPreviewWeatherPresenter {
    weak var view: AnyPreviewWeatherView?
    var interactor: AnyPreviewWeatherInteractor
    var router: AnyPreviewWeatherRouter
    
    init(view: AnyPreviewWeatherView? = nil, interactor: AnyPreviewWeatherInteractor, router: AnyPreviewWeatherRouter) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    func didTapSaveCity(data: CityInfo) {
        interactor.save(data: data)
    }
    
    func didSaveInfo() {
        router.dismissModal()
    }
}
