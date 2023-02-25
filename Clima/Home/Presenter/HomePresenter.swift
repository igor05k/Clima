//
//  HomePresenter.swift
//  Clima
//
//  Created by Igor Fernandes on 23/02/23.
//

import Foundation
import CoreLocation

protocol AnyHomePresenter: AnyObject {
    var view: AnyHomeView? { get set }
    var interactor: AnyHomeInteractor? { get set }
    var router: AnyHomeRouter? { get set }
    
    func didFetchWeather(result: Result<HomeEntity, Error>)
    func didFetchUserCoordinates(lat: CLLocationDegrees, lon: CLLocationDegrees)
}

class HomePresenter: AnyHomePresenter {
    func didFetchUserCoordinates(lat: CLLocationDegrees, lon: CLLocationDegrees) {
        interactor?.getCurrentWeather(lat: lat, lon: lon)
    }
    
    func didFetchWeather(result: Result<HomeEntity, Error>) {
        switch result {
        case .success(let success):
            print(success)
            // atualiza a view
            view?.updateView(with: success)
        case .failure(let failure):
            print(failure)
        }
    }
    
    weak var view: AnyHomeView?
    
    var interactor: AnyHomeInteractor? {
        didSet {
//            interactor?.fetchUserLocation()
        }
    }
    
    weak var router: AnyHomeRouter?
}
