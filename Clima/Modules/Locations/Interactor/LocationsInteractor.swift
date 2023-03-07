//
//  LocationsInteractor.swift
//  Clima
//
//  Created by Igor Fernandes on 07/03/23.
//

import Foundation

protocol AnyLocationsInteractor {
    var presenter: LocationsPresenter? { get set }
}

class LocationsInteractor: AnyLocationsInteractor {
    var presenter: LocationsPresenter?
}


