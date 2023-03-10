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

    func searchFor(userInput term: String)
    func fetchWeatherData(for city: String)
    
    func didFetchSuggestions(with result: Result<AutoComplete, AutoCompleteErrors>)
    func didFetchWeatherForecast(for city: Result<HourlyForecastEntity, Error>)
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
    
    func didFetchSuggestions(with result: Result<AutoComplete, AutoCompleteErrors>) {
        switch result {
        case .success(let success):
            if let predict = success.predictions {
                view?.updateCitiesSuggestions(predictions: predict)
            }
        case .failure(let failure):
            print(failure)
        }
    }
    
    func didFetchWeatherForecast(for city: Result<HourlyForecastEntity, Error>) {
        switch city {
        case .success(let success):
            router.goToPreviewCityWeather(data: success)
        case .failure(let failure):
            print(failure)
        }
    }
    
    func searchFor(userInput term: String) {
        interactor.getAutocompleteResults(for: term)
    }
    
    func fetchWeatherData(for city: String) {
        interactor.fetchWeatherForecast(for: city)
    }
    
//    func fetchWeatherData(for city: String) {
//        interactor.fetchWeather(for: city) { [weak self] result in
//            switch result {
//            case .success(let success):
//                DispatchQueue.main.async {
//                    self?.router.goToPreviewCityWeather(data: success)
//                }
//            case .failure(let failure):
//                print(failure)
//            }
//        }
//    }
}
