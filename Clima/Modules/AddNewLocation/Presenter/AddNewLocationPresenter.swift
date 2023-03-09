//
//  AddNewLocationPresenter.swift
//  Clima
//
//  Created by Igor Fernandes on 02/03/23.
//

import Foundation

protocol AnyAddNewLocationPresenter: AnyObject {
    var view: AnyAddNewLocationView? { get set }
    var interactor: AnyAddNewLocationInteractor { get set }
    var router: AddNewLocationRouter { get set }
    
    func searchFor(userInput term: String, completion: (() -> Void)?)
    func fetchWeatherData(for city: String)
}

class AddNewLocationPresenter: AnyAddNewLocationPresenter {
    weak var view: AnyAddNewLocationView?
    var interactor: AnyAddNewLocationInteractor
    var router: AddNewLocationRouter
    
    init(view: AnyAddNewLocationView? = nil, interactor: AnyAddNewLocationInteractor, router: AddNewLocationRouter) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    func fetchWeatherData(for city: String) {
        interactor.fetchWeather(for: city) { result in
            switch result {
            case .success(let success):
                print(success)
            case .failure(let failure):
                print(failure   )
            }
        }
    }
    
    func searchFor(userInput term: String, completion: (() -> Void)?) {
        interactor.getAutocompleteResults(for: term) { [weak self] result in
            switch result {
            case .success(let success):
                if let suggestions = success.predictions {
                    self?.view?.updateCitiesSuggestions(predictions: suggestions)
                    completion?()
                }
            case .failure(let failure):
                print(failure)
            }
        }
    }
}
