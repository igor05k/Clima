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
    
    func didFetchCities(data: [CityInfo])
    func didDeleteItem(id: Int)
    
    func fetchData()
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
    
    func didFetchCities(data: [CityInfo]) {
        view?.updateCities(with: data)
    }
    
    func didDeleteItem(id: Int) {
        view?.updateTableView(id: id)
    }
    
    func delete(item: CityInfo, id: Int) {
        interactor.delete(item: item, id: id)
    }
    
    func fetchData() {
        interactor.retrieveValues()
    }
    
}
