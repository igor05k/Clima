//
//  LocationsPresenter.swift
//  Clima
//
//  Created by Igor Fernandes on 07/03/23.
//

import Foundation

protocol AnyLocationsPresenter {
    var view: AnyLocationsView? { get set }
    var interactor: AnyLocationsInteractor { get set }
    var router: AnyLocationsRouter { get set }
}

class LocationsPresenter: AnyLocationsPresenter {
    var view: AnyLocationsView?
    var interactor: AnyLocationsInteractor
    var router: AnyLocationsRouter
    
    init(view: AnyLocationsView? = nil, interactor: AnyLocationsInteractor, router: AnyLocationsRouter) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
}
