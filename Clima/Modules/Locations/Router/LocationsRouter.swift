//
//  LocationsRouter.swift
//  Clima
//
//  Created by Igor Fernandes on 07/03/23.
//

import UIKit

protocol AnyLocationsRouter {
    var view: LocationsView? { get set }
}

class LocationsRouter: AnyLocationsRouter {
    weak var view: LocationsView?
    
    static func build() -> UIViewController {
        let view = LocationsView()
        let interactor = LocationsInteractor()
        let router = LocationsRouter()
        let presenter = LocationsPresenter(view: view, interactor: interactor, router: router)
        
        view.presenter = presenter
        router.view = view
        interactor.presenter = presenter
        
        return view
    }
}
